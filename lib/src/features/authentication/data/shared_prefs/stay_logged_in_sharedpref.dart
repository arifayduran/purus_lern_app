import "dart:convert";
import "package:purus_lern_app/src/features/authentication/data/current_user.dart";
import "package:purus_lern_app/src/features/authentication/data/shared_prefs/user_token_sharedpref.dart";
import "package:purus_lern_app/src/features/authentication/domain/user.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:intl/intl.dart";

class StayLoggedInSharedpref {
  Future<void> setLoginStatus(
      bool stayLoggedInSharedpref, User? currentUser, String? userToken) async {
    final prefs = await SharedPreferences.getInstance();

    if (stayLoggedInSharedpref) {
      await prefs.setBool("isLoggedIn", true);

      String loginDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
      await prefs.setString("loginDate", loginDate);
      await prefs.setString("currentUser", jsonEncode(currentUser!.toJson()));
      setUserTokenSharedpref(userToken!);
    } else {
      await prefs.setBool("isLoggedIn", false);
      await prefs.remove("loginDate");
      await prefs.remove("currentUser");
      clearUserTokenSharedpref();
    }
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool("isLoggedIn");
    String? loginDate = prefs.getString("loginDate");

    if (isLoggedIn == null || !isLoggedIn || loginDate == null) {
      await sharedLogout();
      return false;
    }

    DateTime savedDate = DateFormat("yyyy-MM-dd").parse(loginDate);
    DateTime currentDate = DateTime.now();

    if (currentDate.difference(savedDate).inDays > 30) {
      await sharedLogout();
      return false;
    }

    lastLoggedInAsDay = savedDate;
    remainingLoggedInAsDays = 30 - currentDate.difference(savedDate).inDays;
    userToken = await getUserToken();
    return true;
  }

  Future<void> sharedLogout() async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool("isLoggedIn", false);
    await prefs.remove("isLoggedIn");
    await prefs.remove("loginDate");
    await prefs.remove("currentUser");
    clearUserTokenSharedpref();
  }
}
