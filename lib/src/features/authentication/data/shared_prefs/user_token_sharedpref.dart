import "package:shared_preferences/shared_preferences.dart";

Future<void> setUserTokenSharedpref(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("user_token", token);
}

Future<String?> getUserToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("user_token");
}

Future<void> clearUserTokenSharedpref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("user_token");
}
