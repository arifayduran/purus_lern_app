import 'package:purus_lern_app/src/features/authentication/data/login_conditions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricDontAskMeAgainSharedpref {
  Future<void> setDontAskAgainPreference(bool value) async {
    biometricAskedBeforeAndNo = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dontAskForBiometricsAgain', value);
  }

  Future<bool> getDontAskAgainPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dontAskForBiometricsAgain') ?? false;
  }
}
