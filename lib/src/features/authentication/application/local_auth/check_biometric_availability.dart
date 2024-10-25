import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/biometric_sharedpref.dart';
import 'package:purus_lern_app/src/features/authentication/application/local_auth/local_auth_service.dart';
import 'package:purus_lern_app/src/features/authentication/data/login_conditions.dart';

Future<void> checkBiometricAvailability() async {
  isBiometricAvailable.value = await LocalAuthService().isBiometricAvailable();
  if (!isBiometricAvailable.value) {
    isBiometricConfigured = false;
    BiometricsSharedpref().setBiometricsAvailability(false);
  }
}
