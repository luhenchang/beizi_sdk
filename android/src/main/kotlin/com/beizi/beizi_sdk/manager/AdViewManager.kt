package com.beizi.beizi_sdk.manager

import android.view.View
import java.util.concurrent.ConcurrentHashMap

class AdViewManager private constructor() {
    // 使用ConcurrentHashMap保证线程安全
    private val adViewMap: MutableMap<String, View> = ConcurrentHashMap()

    companion object {
        // 单例实例，使用双重校验锁保证线程安全
        @Volatile
        private var instance: AdViewManager? = null

        fun getInstance(): AdViewManager {
            return instance ?: synchronized(this) {
                instance ?: AdViewManager().also { instance = it }
            }
        }
    }

    /**
     * 将View添加到Map中
     * @param adId 广告的唯一ID
     * @param view 要存储的View实例
     */
    fun addAdView(adId: String, view: View) {
        if (adId.isNotBlank()) {
            adViewMap[adId] = view
        }
    }


    /**
     * 根据adId获取View实例
     * @param adId 广告的唯一ID
     * @return 对应的View实例，如果不存在则返回null
     */
    fun getAdView(adId: String): View? {
        return adViewMap[adId]
    }


    /**
     * 根据adId删除View实例
     * @param adId 广告的唯一ID
     * @return 是否成功删除
     */
    fun removeAdView(adId: String): Boolean {
        return adViewMap.remove(adId) != null
    }


    /**
     * 清空所有存储的View实例
     */
    fun clearAllAdsView() {
        adViewMap.clear()
    }



    /**
     * 检查是否存在指定adId的View
     * @param adId 广告的唯一ID
     * @return 如果存在返回true，否则返回false
     */
    fun containsAdView(adId: String): Boolean {
        return adViewMap.containsKey(adId)
    }



    /**
     * 获取当前存储的View数量
     * @return View的数量
     */
    fun getAdViewCount(): Int {
        return adViewMap.size
    }

}
    