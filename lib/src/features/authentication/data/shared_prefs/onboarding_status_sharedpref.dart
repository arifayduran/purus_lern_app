import 'package:shared_preferences/shared_preferences.dart';

class OnboardingStatusSharedpref {
  Future<void> setOnboardingStatusSharedpref(bool isDone) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', isDone);
  }

  Future<bool> isOnboardingDone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_done') ?? false;
  }
}
