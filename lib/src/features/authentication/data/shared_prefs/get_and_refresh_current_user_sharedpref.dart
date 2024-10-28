import 'dart:convert';

import 'package:purus_lern_app/src/features/authentication/application/moodle/refresh_user_info_from_id.dart';
import 'package:purus_lern_app/src/features/authentication/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User?> getAndRefreshCurrentUserSharedpref() async {
  final prefs = await SharedPreferences.getInstance();
  String? currentUserJson = prefs.getString("currentUser");

  if (currentUserJson != null) {
    Map<String, dynamic> userMap = jsonDecode(currentUserJson);

    User? user = await refreshUserinfoFromId(userMap["id"]);
    await prefs.setString("currentUser", jsonEncode(user!.toJson()));

    // debugPrint(
    //     "Logged Userid: ${userMap["id"]}, Username: ${userMap["username"]}, firstname: ${userMap["firstname"]}, lastname: ${userMap["lastname"]}, Email: ${userMap["email"]}");

    return user;
  }
  return null;
}
