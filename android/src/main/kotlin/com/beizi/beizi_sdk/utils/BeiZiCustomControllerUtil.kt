package com.beizi.beizi_sdk.utils

import com.beizi.ad.model.BeiZiLocation
import com.beizi.beizi_sdk.data.BeiziInitKeys
import com.beizi.fusion.BeiZiCustomController

/**
 * 一个单例工具对象，用于从Map创建BeiZiCustomController的实现。
 */
object BeiZiCustomControllerUtil {
    /**
     * 从一个只读的Map创建一个BeiZiCustomController的具体实现。
     * 这个方法是线程安全的，因为它不依赖于任何外部状态。
     *
     * @param map 从Flutter端传递过来的配置Map。使用不可变的Map更安全。
     * @return BeiZiCustomController的一个匿名实现，其行为由传入的map决定。
     */
    fun createControllerFromMap(map: Map<*, *>): BeiZiCustomController {
        return object : BeiZiCustomController() {
            override fun isCanUseLocation(): Boolean =
                map.getOrDefault(BeiziInitKeys.CAN_USE_LOCATION, true) as Boolean

            override fun isCanUseWifiState(): Boolean =
                map.getOrDefault(BeiziInitKeys.CAN_USE_WIFI_STATE, true) as Boolean

            override fun isCanUsePhoneState(): Boolean =
                map.getOrDefault(BeiziInitKeys.CAN_USE_PHONE_STATE, true) as Boolean

            override fun isCanUseOaid(): Boolean =
                map.getOrDefault(BeiziInitKeys.CAN_USE_OAID, true) as Boolean

            override fun isCanUseGaid(): Boolean =
                map.getOrDefault(BeiziInitKeys.CAN_USE_GAID, true) as Boolean

            override fun isCanUseAppList(): Boolean =
                map.getOrDefault(BeiziInitKeys.CAN_USE_APP_LIST, true) as Boolean

            override fun isCanUseAndroidId(): Boolean =
                map.getOrDefault(BeiziInitKeys.CAN_USE_ANDROID_ID, true) as Boolean

            override fun forbidSensor(): Boolean =
                map.getOrDefault(BeiziInitKeys.SHOULD_FORBID_SENSOR, false) as Boolean

            override fun getAndroidId(): String? =
                map[BeiziInitKeys.ANDROID_ID] as? String ?: super.getAndroidId()

            override fun getDevOaid(): String? =
                map[BeiziInitKeys.DEV_OAID] as? String ?: super.getDevOaid()

            override fun getOaidVersion(): String? =
                map[BeiziInitKeys.OAID_VERSION] as? String ?: super.getOaidVersion()

            override fun getLocation(): BeiZiLocation? {
                val locationMap = map[BeiziInitKeys.LOCATION] as? Map<*, *>
                    ?: return super.getLocation()
                val lon = locationMap[BeiziInitKeys.LONGITUDE] as? String
                val lat = locationMap[BeiziInitKeys.LATITUDE] as? String
                val type = locationMap[BeiziInitKeys.TYPE] as? String
                val time = (locationMap[BeiziInitKeys.TIME] as? Number)?.toLong() ?: 0L
                return BeiZiLocation(lon, lat, type, time)
            }
        }
    }
}
