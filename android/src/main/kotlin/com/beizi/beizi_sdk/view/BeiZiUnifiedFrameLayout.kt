package com.beizi.beizi_sdk.view

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.text.TextUtils
import android.util.Log
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.widget.Button
import android.widget.FrameLayout
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.widget.AppCompatImageView
import androidx.appcompat.widget.AppCompatTextView
import androidx.core.graphics.toColorInt
import com.beizi.ad.internal.activity.DownloadAppInfoActivity
import com.beizi.beizi_sdk.data.AppDetailKeys
import com.beizi.beizi_sdk.data.BeiZiNativeUnifiedAdChannelMethod
import com.beizi.beizi_sdk.data.NativeUnifiedChild
import com.beizi.beizi_sdk.data.NativeUnifiedModule
import com.beizi.beizi_sdk.manager.BeiZiEventManager
import com.beizi.beizi_sdk.utils.ImageManager
import com.beizi.fusion.NativeUnifiedAdResponse
import com.beizi.fusion.model.UnifiedAdDownloadAppInfo
import com.example.amps_sdk.utils.dpToPx


// 定义点击事件类型，与 Flutter 端和数据模型保持一致
object AdClickType {
    const val NONE = -1
    const val CLICK = 0
}

// 1. 定义用于封装返回结果的数据类
data class AdRenderResult(
    val clickableViews: List<View>
)

/**
 * 一个自定义 View，负责根据数据模型动态构建原生广告 UI
 */
class AmpsUnifiedFrameLayout(context: Context) : FrameLayout(context) {
    private val TAG = "AmpsUnifiedFrameLayout"

    // 用来记录可点击的视图和需要上报的视图
    private val clickableViews = mutableListOf<View>()

    /**
     * 主构建方法，接收数据模型和广告数据，并生成 UI
     *
     * @param module 解析好的 UI 布局模型
     * @param unifiedItem 包含具体广告内容的包装器
     */
    fun render(
        module: NativeUnifiedModule?,
        unifiedItem: NativeUnifiedAdResponse,
        params: LayoutParams,
        adId: String
    ): AdRenderResult? {
        // 清理旧的视图，以便重用
        removeAllViews()
        clickableViews.clear()
        if (module == null) {
            Log.e(TAG, "render module is null")
            return null
        }
        // 1. 设置根容器的属性
        applyRootProperties(module, params)
        // 2. 根据模型和数据，按顺序创建并添加子视图
        module.mainImageChild?.let { child ->
            createMainImageView(child, unifiedItem)?.let { view ->
                addView(view)
            }
        }

        module.videoChild?.let { child ->
            createVideoChild(child, unifiedItem, adId)?.let { view ->
                addView(view)
            }
        }

        module.titleChild?.let { child ->
            unifiedItem.title?.let { titleText ->
                createTitleView(child, titleText)?.let { titleView ->
                    clickableViews.add(titleView)
                    addView(titleView)
                }
            }
        }

        module.descriptionChild?.let { child ->
            unifiedItem.description?.let { descText ->
                createDescriptionView(child, descText)?.let { dspView ->
                    clickableViews.add(dspView)
                    addView(dspView)
                }
            }
        }

        module.adSourceLogoChild?.let { child ->
            createAdSourceLogoView(child, unifiedItem)?.let { view ->
                addView(view)
            }
        }

        module.appIconChild?.let { child ->
            createAppIconView(child, unifiedItem)?.let { view ->
                addView(view)
            }
        }

        //渲染操作按钮,需支持文本和图片两种情况
        module.actionButtonChild?.let { child ->
            createActionView(child, unifiedItem)?.let { actionView ->
                clickableViews.add(actionView)
                addView(actionView)
            }
        }

        module.closeIconChild?.let { child ->
            // 关闭按钮的图片通常是本地资源
            createCloseIconView(child, adId)?.let { view ->
                addView(view)
            }
        }

        //在方法末尾，创建并返回 AdRenderResult 实例
        return AdRenderResult(clickableViews)
    }


    private fun applyRootProperties(
        module: NativeUnifiedModule,
        params: LayoutParams
    ) {
        params.gravity = Gravity.CENTER_HORIZONTAL
        layoutParams = params
        module.backgroundColor?.let { bgColor ->
            try {
                setBackgroundColor(bgColor.toColorInt())
            } catch (_: IllegalArgumentException) {
            }
        }
    }

    /**
     * 创建主图视图的核心方法，封装了所有逻辑。
     * - 根据 unifiedItem 的类型（isViewObject），决定是返回渠道提供的 View 还是自己创建 ImageView。
     * - 如果无法创建，则返回 null。
     *
     * @return 返回配置好的 View，如果无法创建则返回 null。
     */
    private fun createMainImageView(
        child: NativeUnifiedChild.MainImage,
        unifiedItem: NativeUnifiedAdResponse
    ): View? {
        val view = unifiedItem.imageUrl?.let { imageUrl ->
            AppCompatImageView(context).apply {
                layoutParams = createLayoutParams(child.width, child.height, child.x, child.y)
                scaleType = ImageView.ScaleType.FIT_XY//目前用户设置多大就多大。
                ImageManager.with(context).load(imageUrl).into(this)
                // 为我们自己创建的视图设置点击监听
                setupClickListener(this, child.clickType, child.clickIdType)
            }
        }

        return view?.apply {
            layoutParams = createLayoutParams(child.width, child.height, child.x, child.y)
            child.backgroundColor?.let { bgColor ->
                try {
                    setBackgroundColor(bgColor.toColorInt())
                } catch (_: IllegalArgumentException) { /* 忽略错误 */
                }
            }
        }
    }


    private fun createVideoChild(
        child: NativeUnifiedChild.Video,
        unifiedItem: NativeUnifiedAdResponse,
        adId: String
    ): View? {
        var mediaView: View? = null
        if (unifiedItem.videoView != null) {
            mediaView = unifiedItem.videoView
            mediaView.layoutParams = createLayoutParams(child.width, child.height, child.x, child.y)
        }
        return mediaView
    }

    //--主题添加--
    private fun createTitleView(
        child: NativeUnifiedChild.Title,
        text: String
    ): View? {
        return AppCompatTextView(context).apply {
            this.text = text
            layoutParams = createLayoutParams(null, null, child.x, child.y)
            child.fontSize?.let { textSize = it.toFloat() }
            child.color?.let {
                try {
                    setTextColor(it.toColorInt())
                } catch (_: Exception) {
                }
            }
            setupClickListener(this, child.clickType, child.clickIdType)
        }
    }

    //描述
    private fun createDescriptionView(child: NativeUnifiedChild.Description, text: String): View? {
        return AppCompatTextView(context).apply {
            this.text = text
            layoutParams = createLayoutParams(child.width, null, child.x, child.y)
            child.fontSize?.let { textSize = it.toFloat() }
            child.color?.let {
                try {
                    setTextColor(it.toColorInt())
                } catch (_: Exception) {
                }
            }
            setupClickListener(this, child.clickType, child.clickIdType)
        }
    }

    //操作按钮
    private fun createActionView(
        child: NativeUnifiedChild.ActionButton,
        unifiedItem: NativeUnifiedAdResponse
    ): View? {
        val layoutParams = createLayoutParams(child.width, child.height, child.x, child.y)

        val actionButtonText = unifiedItem.actionText
        if (actionButtonText == null || actionButtonText.isEmpty()) {
            return null
        }
        if (actionButtonText.startsWith("http")) {
            val actionIv = ImageView(context)
            actionIv.scaleType = ImageView.ScaleType.FIT_CENTER
            actionIv.layoutParams = layoutParams
            ImageManager.with(context).load(actionButtonText).into(actionIv)
            return actionIv
        } else {
            val textView = Button(context)
            textView.text = actionButtonText
            child.fontColor?.let {
                try {
                    textView.setTextColor(it.toColorInt())
                } catch (_: Exception) {
                }
            }
            child.backgroundColor?.let {
                try {
                    textView.setBackgroundColor(it.toColorInt())
                } catch (_: Exception) {
                }
            }
            child.fontSize?.let {
                textView.setTextSize(TypedValue.COMPLEX_UNIT_SP, it.toFloat())
            }
            textView.layoutParams = layoutParams
            return textView
        }
    }


    //---adSourceIcon创建--
    private fun createAdSourceLogoView(
        child: NativeUnifiedChild.AdSourceLogo,
        unifiedItem: NativeUnifiedAdResponse
    ): View? {
        return (if (!TextUtils.isEmpty(unifiedItem.adLogoUrl)) {
            AppCompatImageView(context).apply {
                layoutParams = createLayoutParams(child.width, child.height, child.x, child.y)
                ImageManager.with(context).load(unifiedItem.adLogoUrl).into(this)
                setupClickListener(this, child.clickType, child.clickIdType)
            }
        } else {
            null
        })
    }

    //---appIcon创建--
    private fun createAppIconView(
        child: NativeUnifiedChild.AppIcon,
        unifiedItem: NativeUnifiedAdResponse
    ): View? {
        return if (unifiedItem.iconUrl != null) {
            AppCompatImageView(context).apply {
                layoutParams = createLayoutParams(child.width, child.height, child.x, child.y)
                ImageManager.with(context).load(unifiedItem.iconUrl).into(this)
                setupClickListener(this, child.clickType, child.clickIdType)
            }
        } else {
            null
        }
    }


    private fun createCloseIconView(
        child: NativeUnifiedChild.CloseIcon,
        adId: String
    ): View? {
        if (child.imagePath == null) {
            return null
        }
        return AppCompatImageView(context).apply {
            layoutParams = createLayoutParams(child.width, child.height, child.x, child.y)
            // 从 Flutter assets 加载图片（这是一个简化的例子）
            // 在实际项目中，你可能需要一个更稳健的方法来获取资源 ID
            val flutterAssetPath = "flutter_assets/${child.imagePath}"
            val inputStream = context.assets.open(flutterAssetPath)
            // 将文件流解码为 Bitmap 对象
            val bitmap: Bitmap = BitmapFactory.decodeStream(inputStream)
            scaleType = ImageView.ScaleType.FIT_CENTER
            setImageBitmap(bitmap)
            // 关闭按钮通常有固定的点击行为
            setOnClickListener {
                sendMessageToFlutter(
                    BeiZiNativeUnifiedAdChannelMethod.ON_AD_CLOSED, adId
                )
            }
        }
    }

    private fun sendMessageToFlutter(method: String, args: Any?) {
        BeiZiEventManager.getInstance()
            .sendMessageToFlutter(method, args)
    }

    private fun createLayoutParams(
        width: Double?,
        height: Double?,
        x: Double?,
        y: Double?
    ): LayoutParams {
        val params = LayoutParams(
            width?.dpToPx(context) ?: LayoutParams.WRAP_CONTENT,
            height?.dpToPx(context) ?: LayoutParams.WRAP_CONTENT
        )
        // 在 FrameLayout 中，通过 margins 来模拟 offset (x, y)
        params.leftMargin = x?.dpToPx(context) ?: 0
        params.topMargin = y?.dpToPx(context) ?: 0
        return params
    }

    //
    private fun setupClickListener(
        view: View,
        clickType: Int?,
        clickIdType: Int?
    ) {
        val finalClickType = clickType ?: AdClickType.NONE
        if (finalClickType == AdClickType.NONE) {
            return
        }
        clickableViews.add(view)
    }
}

fun isDownloadAd(appDetail: UnifiedAdDownloadAppInfo?): Boolean {
    if (appDetail == null) {
        return false
    }
    if (TextUtils.isEmpty(appDetail.appName)) {
        return false
    }
    if (TextUtils.isEmpty(appDetail.appVersion)) {
        return false
    }
    if (TextUtils.isEmpty(appDetail.appDeveloper)) {
        return false
    }
    if (TextUtils.isEmpty(appDetail.appPermission)) {
        return false
    }
    if (TextUtils.isEmpty(appDetail.appPrivacy)) {
        return false
    }
    if (TextUtils.isEmpty(appDetail.appIntro)) {
        return false
    }
    return true
}