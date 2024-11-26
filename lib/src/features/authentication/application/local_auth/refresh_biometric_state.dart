import 'package:flutter/material.dart';
import 'package:purus_lern_app/src/features/authentication/application/local_auth/check_biometric_availability.dart';
import 'package:purus_lern_app/src/features/authentication/application/local_auth/local_auth_service.dart';
import 'package:purus_lern_app/src/features/authentication/data/login_conditions.dart';
// import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/biometrics_sharedpref.dart';
import 'package:purus_lern_app/src/widgets/my_snack_bar.dart';

Future<void> refreshBiometricState(
    BuildContext context, bool isMounted, bool showSnack) async {
  try {
    isDeviceSupportedForBiometric.value =
        await LocalAuthService().isDeviceSupported();
    await checkBiometricAvailability();
    availableBiometricsString =
        await LocalAuthService().getAvailableBiometricsInString();

    if (isMounted && showSnack) {
      mySnackbar(
          // ignore: use_build_context_synchronously
          context,
          "Verfügbarkeit biometrischer Anmeldung wurde geprüft.");
    }
  } catch (e) {
    debugPrint("Fehler: ${e.toString()}");
    if (isMounted && showSnack) {
      mySnackbar(
          // ignore: use_build_context_synchronously
          context,
          "Fehler: ${e.toString()}");
    }
  }
}
