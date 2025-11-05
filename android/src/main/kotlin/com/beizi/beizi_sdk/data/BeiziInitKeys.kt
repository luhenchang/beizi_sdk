package com.beizi.beizi_sdk.data

class BeiziInitKeys private constructor() {
    companion object {
        const val APP_ID: String = "appId"
        //个性化
        const val IS_PERSONAL_RECOMMEND: String = "isPersonalRecommend"
        // 位置相关
        const val CAN_USE_LOCATION: String = "canUseLocation"
        const val LOCATION: String = "location"
        const val LONGITUDE: String = "longitude";
        const val LATITUDE = "latitude";
        const val TYPE = "type";

        /// The timestamp of the location fix in milliseconds since the epoch. Corresponds to `getTime()`.
        const val TIME = "time";
        // WiFi状态相关
        const val CAN_USE_WIFI_STATE: String = "canUseWifiState"

        // 电话状态相关
        const val CAN_USE_PHONE_STATE: String = "canUsePhoneState"

        // OAID相关
        const val CAN_USE_OAID: String = "canUseOaid"
        const val DEV_OAID: String = "devOaid"
        const val OAID_VERSION: String = "oaidVersion"

        // GAID相关
        const val CAN_USE_GAID: String = "canUseGaid"

        // 应用列表相关
        const val CAN_USE_APP_LIST: String = "canUseAppList"

        // 传感器相关
        const val SHOULD_FORBID_SENSOR: String = "shouldForbidSensor"

        // Android ID相关
        const val CAN_USE_ANDROID_ID: String = "canUseAndroidId"
        const val ANDROID_ID: String = "androidId"
    }
}