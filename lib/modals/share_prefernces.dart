import 'package:shared_preferences/shared_preferences.dart';

saveInSharedPreferences(key, value) async {
  if (value is int) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  } else if (value is bool) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  } else if (value is double) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  } else if (value is String) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
}

Future<String?> getStringValuesSP(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? stringValue = prefs.getString(key);
  return stringValue;
}

Future<bool> getBoolValuesSP(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return bool
  bool boolValue = prefs.getBool(key) ?? false;
  return boolValue;
}

getIntValuesSP(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return int
  int? intValue = prefs.getInt(key);
  return intValue;
}

getDoubleValuesSP(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return double
  double? doubleValue = prefs.getDouble(key);
  return doubleValue;
}

Future<bool> isDataSaved(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(key);
}

removeSPData(key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
  return true;
}
