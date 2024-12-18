import "dart:convert";
import "package:purus_lern_app/src/config/const_stay_logged_in_days.dart";
import "package:purus_lern_app/src/features/authentication/data/current_user.dart";
import "package:purus_lern_app/src/features/authentication/data/shared_prefs/biometrics_sharedpref.dart";
import "package:purus_lern_app/src/features/authentication/data/shared_prefs/user_token_sharedpref.dart";
import "package:purus_lern_app/src/features/authentication/domain/user.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:intl/intl.dart";

class StayLoggedInSharedpref {
  Future<void> setLoginStatus(
      bool stayLoggedInSharedpref, User? currentUser, String? userToken) async {
    final prefs = await SharedPreferences.getInstance();

    if (stayLoggedInSharedpref) {
      await prefs.setBool("isAutoLoggedIn", true);

      // ignore: no_leading_underscores_for_local_identifiers
      String _configuredAutoLoginDate =
          DateFormat("yyyy-MM-dd").format(DateTime.now());
      await prefs.setString(
          "configuredAutoLoginDate", _configuredAutoLoginDate);
      await prefs.setString("currentUser", jsonEncode(currentUser!.toJson()));
      setUserTokenSharedpref(userToken!);
    } else {
      await prefs.setBool("isAutoLoggedIn", false);
      await prefs.remove("configuredAutoLoginDate");
      await prefs.remove("currentUser");
      clearUserTokenSharedpref();
      updateBiometrics(false);
    }
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isAutoLoggedIn = prefs.getBool("isAutoLoggedIn");
    // ignore: no_leading_underscores_for_local_identifiers
    String? _configuredAutoLoginDate =
        prefs.getString("configuredAutoLoginDate");

    if (isAutoLoggedIn == null ||
        !isAutoLoggedIn ||
        _configuredAutoLoginDate == null) {
      await sharedLogout();
      return false;
    }

    DateTime savedDate =
        DateFormat("yyyy-MM-dd").parse(_configuredAutoLoginDate);
    DateTime currentDate = DateTime.now();

    if (currentDate.difference(savedDate).inDays > constStayLoggedInDays) {
      await sharedLogout();
      return false;
    }

    configuredAutoLoginDate = savedDate;
    remainingAutoLoggedInAsDays =
        constStayLoggedInDays - currentDate.difference(savedDate).inDays;
    userToken = await getUserToken();

    return true;
  }

  Future<void> sharedLogout() async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool("isAutoLoggedIn", false);
    await prefs.remove("isAutoLoggedIn");
    await prefs.remove("configuredAutoLoginDate");
    await prefs.remove("currentUser");
    clearUserTokenSharedpref();
    updateBiometrics(false);
  }
}
