import 'package:purus_lern_app/src/features/authentication/data/login_conditions.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> updateBiometrics(bool value) async {
  isBiometricsConfigured = value;
  BiometricsSharedpref sharedPrefBiometrics = BiometricsSharedpref();
  await sharedPrefBiometrics.setBiometricsAvailability(value);
}

class BiometricsSharedpref {
  Future<void> setBiometricsAvailability(bool isBiometricsAvailable) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isBiometricsAvailable', isBiometricsAvailable);
  }

  Future<bool> getBiometricsAvailability() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isBiometricsAvailable') ?? false;
  }
}
