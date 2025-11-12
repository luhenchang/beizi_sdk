package com.beizi.beizi_sdk.manager

import com.beizi.fusion.NativeUnifiedAdResponse
import java.util.concurrent.ConcurrentHashMap

class AdResponseManager private constructor() {
    // 使用ConcurrentHashMap保证线程安全
    private val adResponseMap: MutableMap<String, NativeUnifiedAdResponse> = ConcurrentHashMap()

    companion object {
        // 单例实例，使用双重校验锁保证线程安全
        @Volatile
        private var instance: AdResponseManager? = null

        fun getInstance(): AdResponseManager {
            return instance ?: synchronized(this) {
                instance ?: AdResponseManager().also { instance = it }
            }
        }
    }

    /**
     * 将View添加到Map中
     * @param adId 广告的唯一ID
     * @param view 要存储的View实例
     */
    fun addAdResponse(adId: String, response: NativeUnifiedAdResponse) {
        if (adId.isNotBlank()) {
            adResponseMap[adId] = response
        }
    }


    /**
     * 根据adId获取View实例
     * @param adId 广告的唯一ID
     * @return 对应的View实例，如果不存在则返回null
     */
    fun getAdResponse(adId: String): NativeUnifiedAdResponse? {
        return adResponseMap[adId]
    }


    /**
     * 根据adId删除View实例
     * @param adId 广告的唯一ID
     * @return 是否成功删除
     */
    fun removeAdResponse(adId: String): Boolean {
        return adResponseMap.remove(adId) != null
    }


    /**
     * 清空所有存储的View实例
     */
    fun clearAllAdsResponse() {
        adResponseMap.clear()
    }



    /**
     * 检查是否存在指定adId的View
     * @param adId 广告的唯一ID
     * @return 如果存在返回true，否则返回false
     */
    fun containsAdResponse(adId: String): Boolean {
        return adResponseMap.containsKey(adId)
    }



    /**
     * 获取当前存储的View数量
     * @return View的数量
     */
    fun getAdResponseCount(): Int {
        return adResponseMap.size
    }

}
    