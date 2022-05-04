import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  static Future<SharedPreferences> get _instance async =>
      mSharedPrefs = await SharedPreferences.getInstance();
  static SharedPreferences? mSharedPrefs;

  static Future<SharedPreferences?> init() async {
    mSharedPrefs = await _instance;
    return mSharedPrefs;
  }

  static String getUserName(String userName, [String? defValue]) {
    return mSharedPrefs?.getString(userName) ?? defValue ?? "";
  }

  static Future<bool> setUserName(String userName, String value) async {
    var prefs = await _instance;
    return prefs.setString(userName, value);
  }
  static String getShopId(String shopId, [String? defValue]) {
    return mSharedPrefs?.getString(shopId) ?? defValue ?? "";
  }

  static Future<bool> setShopId(String shopId, String value) async {
    var prefs = await _instance;
    return prefs.setString(shopId, value);
  }
  static String getOrderId(String orderId, [String? defValue]) {
    return mSharedPrefs?.getString(orderId) ?? defValue ?? "";
  }

  static Future<bool> setOrderId(String orderId, String value) async {
    var prefs = await _instance;
    return prefs.setString(orderId, value);
  }
}