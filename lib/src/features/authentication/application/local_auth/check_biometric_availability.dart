// import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/biometrics_sharedpref.dart';
import 'package:purus_lern_app/src/features/authentication/application/local_auth/local_auth_service.dart';
import 'package:purus_lern_app/src/features/authentication/data/login_conditions.dart';

Future<void> checkBiometricAvailability() async {
  isBiometricsAvailable.value =
      await LocalAuthService().isBiometricsAvailable();
  // if (!isBiometricsAvailable.value) {
  //   updateBiometrics(false);
  // }
}
