import "dart:convert";
import "package:flutter/material.dart";
import "package:purus_lern_app/src/core/moodle/get_user_info_from_login.dart";
import "package:purus_lern_app/src/core/moodle/refresh_user_info_from_id.dart";
import "package:purus_lern_app/src/features/authentication/data/current_user.dart";
import "package:purus_lern_app/src/features/authentication/domain/user.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:intl/intl.dart";

class StayLoggedInSharedpref {
  Future<void> setLoginStatus(
      bool stayLoggedInSharedpref, User currentUser) async {
    final prefs = await SharedPreferences.getInstance();

    if (stayLoggedInSharedpref) {
      await prefs.setBool("isLoggedIn", true);

      String loginDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      await prefs.setString("loginDate", loginDate);
      await prefs.setString("currentUser", jsonEncode(currentUser.toJson()));
    } else {
      await prefs.setBool("isLoggedIn", false);
      await prefs.remove("loginDate");
      await prefs.remove("currentUser");
    }
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool("isLoggedIn");
    String? loginDate = prefs.getString("loginDate");

    if (isLoggedIn == null || !isLoggedIn || loginDate == null) {
      return false;
    }

    DateTime savedDate = DateFormat("yyyy-MM-dd").parse(loginDate);
    DateTime currentDate = DateTime.now();

    if (currentDate.difference(savedDate).inDays > 30) {
      await sharedLogout();
      return false;
    }

    return true;
  }

  Future<void> sharedLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("isLoggedIn");
    await prefs.remove("loginDate");
    await prefs.remove("currentUser");
  }
}

Future<User?> getAndRefreshCurrentUser() async {
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
