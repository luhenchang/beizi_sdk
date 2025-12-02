/*
 * Copyright © 2017 Hubcloud.com.cn. All rights reserved.
 * ImageManager.java
 * BeiZiSDK
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */
package com.beizi.beizi_sdk.utils

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.LruCache
import android.widget.ImageView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream
import java.net.HttpURLConnection
import java.net.URL
import kotlin.coroutines.CoroutineContext

/**
 * Created by 54062 on 2017/7/26.
 */
@SuppressLint("StaticFieldLeak")
object ImageManager : CoroutineScope {

    private lateinit var mContext: Context
    private val job = Job()
    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main + job

    private val imageCache = LruCache<String, Bitmap>(1024 * 1024 * 4) // 4MB cache

    @JvmStatic
    fun with(context: Context): ImageManager {
        mContext = FlutterPluginUtil.getActivity() ?: context
        return this
    }

    fun load(url: String): RequestCreator {
        return RequestCreator(url)
    }

    class RequestCreator(private val url: String) {
        private var holderResId: Int = 0
        private var errorResId: Int = 0
        private lateinit var imageView: ImageView

        fun placeholder(holderResId: Int): RequestCreator {
            this.holderResId = holderResId
            return this
        }

        fun error(errorResId: Int): RequestCreator {
            this.errorResId = errorResId
            return this
        }

        fun into(imageView: ImageView) {
            this.imageView = imageView

            // Set placeholder if provided
            if (holderResId != 0) {
                imageView.setImageResource(holderResId)
            }

            if (url.isEmpty()) return

            // 1. Check memory cache
            val memoryBitmap = imageCache.get(url)
            if (memoryBitmap != null) {
                imageView.setImageBitmap(memoryBitmap)
                return
            }

            // 2. Check disk cache
            val diskBitmap = getBitmapFile()
            if (diskBitmap != null) {
                imageView.setImageBitmap(diskBitmap)
                imageCache.put(url, diskBitmap) // Add to memory cache
                return
            }

            // 3. Fetch from network
            launch(Dispatchers.IO) {
                try {
                    val networkBitmap = downloadBitmap(url)
                    withContext(Dispatchers.Main) {
                        imageView.setImageBitmap(networkBitmap)
                    }
                    // Cache the downloaded bitmap
                    networkBitmap?.let {
                        imageCache.put(url, it)
                        saveBitmapToDisk(url, it)
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                    withContext(Dispatchers.Main) {
                        showError()
                    }
                }
            }
        }

        private fun getBitmapFile(): Bitmap? {
            val fileName = HashingFunctions.md5(url.substring(url.lastIndexOf("/") + 1))
            val file = File(FileUtil.getCacheDirectory(mContext), fileName)
            return if (file.exists() && file.length() > 0) {
                BitmapFactory.decodeFile(file.absolutePath)
            } else {
                null
            }
        }

        private fun showError() {
            if (errorResId != 0) {
                imageView.setImageResource(errorResId)
            }
        }
    }

    fun getBitmap(imgUrl: String, listener: BitmapLoadedListener) {
        getBitmap(imgUrl, true, listener)
    }

    fun getBitmap(imgUrl: String, isSwitchMainThread: Boolean, listener: BitmapLoadedListener) {
        if (imgUrl.isEmpty()) return
        // 1. Check memory cache
        val memoryBitmap = imageCache.get(imgUrl)
        if (memoryBitmap != null) {
            launch(Dispatchers.IO) {
                deliverBitmap(memoryBitmap, isSwitchMainThread, listener)
            }
            return
        }

        // Coroutine for disk and network operations
        launch(Dispatchers.IO) {
            // 2. Check disk cache
            val fileName = HashingFunctions.md5(imgUrl.substring(imgUrl.lastIndexOf('/') + 1))
            val file = File(FileUtil.getResourceCacheDirectory(mContext), fileName)
            if (file.exists() && file.length() > 0) {
                val diskBitmap = BitmapFactory.decodeFile(file.absolutePath)
                if (diskBitmap != null) {
                    imageCache.put(imgUrl, diskBitmap)
                    deliverBitmap(diskBitmap, isSwitchMainThread, listener)
                    return@launch
                }
            }

            // 3. Fetch from network
            try {
                val networkBitmap = downloadBitmap(imgUrl)
                if (networkBitmap != null) {
                    imageCache.put(imgUrl, networkBitmap)
                    saveBitmapToDisk(
                        imgUrl,
                        networkBitmap,
                        FileUtil.getResourceCacheDirectory(mContext)
                    )
                    deliverBitmap(networkBitmap, isSwitchMainThread, listener)
                } else {
                    throw Exception("Downloaded bitmap is null")
                }
            } catch (e: Exception) {
                if (isSwitchMainThread) {
                    withContext(Dispatchers.Main) { listener.onBitmapLoadFailed() }
                } else {
                    listener.onBitmapLoadFailed()
                }
            } finally {
                FileUtil.deleteOldFiles(mContext)
            }
        }
    }

    private suspend fun deliverBitmap(
        bitmap: Bitmap,
        isSwitchMainThread: Boolean,
        listener: BitmapLoadedListener
    ) {
        if (isSwitchMainThread) {
            withContext(Dispatchers.Main) {
                listener.onBitmapLoaded(bitmap)
            }
        } else {
            listener.onBitmapLoaded(bitmap)
        }
    }

    private fun downloadBitmap(url: String): Bitmap? {
        var connection: HttpURLConnection? = null
        var inputStream: InputStream? = null
        return try {
            val urlConnection = URL(url).openConnection() as HttpURLConnection
            connection = urlConnection.apply {
                requestMethod = "GET"
                connectTimeout = 2000
                connect()
            }

            if (connection.responseCode == HttpURLConnection.HTTP_OK) {
                inputStream = connection.inputStream
                BitmapFactory.decodeStream(inputStream)
            } else {
                null
            }
        } finally {
            inputStream?.close()
            connection?.disconnect()
        }
    }

    private fun saveBitmapToDisk(
        url: String,
        bitmap: Bitmap,
        directory: File = FileUtil.getCacheDirectory(mContext)
    ) {
        val fileName = HashingFunctions.md5(url.substring(url.lastIndexOf("/") + 1))
        val file = File(directory, fileName)
        FileOutputStream(file).use { out ->
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
        }
    }
}

interface BitmapLoadedListener {
    fun onBitmapLoaded(bitmap: Bitmap?)
    fun onBitmapLoadFailed()
}
