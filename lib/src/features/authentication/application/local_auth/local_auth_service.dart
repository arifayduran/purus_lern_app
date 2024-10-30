import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:local_auth/local_auth.dart";
import "package:purus_lern_app/src/data/app_info.dart";

class LocalAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isDeviceSupported() async {
    if (currentPlatform != "Web" && currentPlatform != "Unknown") {
      return await _auth.isDeviceSupported();
    } else {
      return false;
    }
  }

  Future<bool> isBiometricAvailable() async {
    if (currentPlatform != "Web" && currentPlatform != "Unknown") {
      try {
        return await _auth.canCheckBiometrics &&
            await _auth.isDeviceSupported();
      } catch (e) {
        debugPrint("-------------");
        debugPrint(e.toString());
        debugPrint("-------------");
        return false;
      }
    } else {
      return false;
    }
  }

  // Future<List<BiometricType>> getAvailableBiometrics() async {
  //   try {
  //     return await _auth.getAvailableBiometrics();
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return <BiometricType>[];
  //   }
  // }

  Future<String> getAvailableBiometricsInString() async {
    if (currentPlatform != "Web" && currentPlatform != "Unknown") {
      try {
        List<BiometricType> availableBiometrics =
            await _auth.getAvailableBiometrics();

        if (currentPlatform == "IOS") {
          if (availableBiometrics.contains(BiometricType.face)) {
            return "Face ID";
          } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
            return "Touch ID";
          }
        } else if (currentPlatform == "Android") {
          if (availableBiometrics.contains(BiometricType.strong) ||
              availableBiometrics.contains(BiometricType.weak)) {
            return "Android Biometrics";
          }
          // if (availableBiometrics.contains(BiometricType.fingerprint)) {
          //   return "Android Fingerprint";
          // } else if (availableBiometrics.contains(BiometricType.face) ||
          //     availableBiometrics.contains(BiometricType.weak)) {
          //   return "Android Face Recognition";
          // }
        } else if (currentPlatform == "MacOS") {
          if (availableBiometrics.contains(BiometricType.fingerprint)) {
            return "macOS Touch ID";
          }
        } else if (currentPlatform == "Windows") {
          if (availableBiometrics.contains(BiometricType.fingerprint)) {
            return "Windows Fingerprint";
          }
        }

        return "Biometrics sind nicht aktiv";
      } on PlatformException catch (e) {
        debugPrint("-------------");
        debugPrint("Error: $e");
        debugPrint("-------------");
        return "Biometrics sind nicht aktiv";
      }
    } else {
      return "Biometrics sind nicht aktiv";
    }
  }

  Future<bool> authenticateUser() async {
    try {
      bool isAuthenticated = await _auth.authenticate(
        localizedReason: "Please authenticate to continue",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      return isAuthenticated;
    } catch (e) {
      debugPrint("-------------");
      debugPrint("Error during authentication: $e");
      debugPrint("-------------");
      return false;
    }
  }
}
