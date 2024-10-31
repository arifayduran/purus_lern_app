import 'package:flutter/material.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/log_any.dart';
import 'package:purus_lern_app/src/features/authentication/application/local_auth/check_biometric_availability.dart';
import 'package:purus_lern_app/src/features/authentication/application/local_auth/local_auth_service.dart';
import 'package:purus_lern_app/src/features/authentication/data/login_conditions.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> updateBiometrics(bool value) async {
  isDeviceSupportedForBiometric.value =
      await LocalAuthService().isDeviceSupported();
  await checkBiometricAvailability();
  availableBiometricsString =
      await LocalAuthService().getAvailableBiometricsInString();

  if (value) {
    if (availableBiometricsString != "Biometrics sind nicht aktiv" &&
        isDeviceSupportedForBiometric.value &&
        isBiometricsAvailable.value) {
      logAny("updateBiometrics", value.toString());
      isBiometricsConfigured = value;
      BiometricsSharedpref sharedPrefBiometrics = BiometricsSharedpref();
      await sharedPrefBiometrics.setBiometricsConfigured(value);
      debugPrint("Biometrics updated to $value");
    } else {
      debugPrint(
          "Fehler bei der Einrichtung von Biometrics. $availableBiometricsString, ${isDeviceSupportedForBiometric.value.toString()}, ${isBiometricsAvailable.value.toString()}");
    }
  } else {
    logAny("updateBiometrics", value.toString());
    isBiometricsConfigured = value;
    BiometricsSharedpref sharedPrefBiometrics = BiometricsSharedpref();
    await sharedPrefBiometrics.setBiometricsConfigured(value);
    debugPrint("Biometrics updated to $value");
  }
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
