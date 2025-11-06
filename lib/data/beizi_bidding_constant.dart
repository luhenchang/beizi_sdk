/// 竞价参数说明 - 外部键
class BeiZiBiddingConstant {
  // 竞胜价格
  static const String winPriceKey = "winPrice";
  // 失败渠道中最高价格
  static const String highestLossPriceKey = "highestLossPrice";
  // 失败原因
  static const String lossReasonKey = "lossReason";
  // 竞胜渠道ID
  static const String adnIdKey = "adnId";
}

/// 渠道ID
class BeiZiAdn {
  // BeiZi渠道
  static const String adnBz = "6666";
  // 广点通渠道
  static const String adnGdt = "1012";
  // 穿山甲渠道
  static const String adnCsj = "1013";
  // 百度渠道
  static const String adnBd = "1018";
  // 快手渠道
  static const String adnKs = "1019";
  // 华为渠道
  static const String adnHw = "1020";
  // 京东渠道
  static const String adnJd = "1021";
  // GroMore渠道
  static const String adnGm = "1022";
  // 趣盟渠道
  static const String adnQm = "1030";
  // 其它
  static const String adnOther = "9999";
}

/// 竞价失败原因
class BeiZiLossReason {
  // 价格低于其它渠道
  static const String lowPrice = "1";
  // 获取价格超时
  static const String loadTimeOut = "2";
  // 其它
  static const String other = "999";
}