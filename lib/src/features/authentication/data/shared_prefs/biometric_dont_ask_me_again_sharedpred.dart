import 'package:shared_preferences/shared_preferences.dart';

class BiometricDontAskMeAgainSharedpref {
  Future<void> setDontAskAgainPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dontAskForBiometricsAgain', value);
  }

  Future<bool> getDontAskAgainPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dontAskForBiometricsAgain') ?? false;
  }
}
