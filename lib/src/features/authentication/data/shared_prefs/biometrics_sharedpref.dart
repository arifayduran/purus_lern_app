import 'package:purus_lern_app/src/core/firebase/firebase_analytics/log_any.dart';
import 'package:purus_lern_app/src/features/authentication/data/login_conditions.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> updateBiometrics(bool value) async {
  logAny("updateBiometrics", value.toString());
  isBiometricsConfigured = value;
  BiometricsSharedpref sharedPrefBiometrics = BiometricsSharedpref();
  await sharedPrefBiometrics.setBiometricsConfigured(value);
}

class BiometricsSharedpref {
  Future<void> setBiometricsConfigured(bool isBiometricsConfigured) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isBiometricsConfigured', isBiometricsConfigured);
  }

  Future<bool> getBiometricsConfigured() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isBiometricsConfigured') ?? false;
  }
}
