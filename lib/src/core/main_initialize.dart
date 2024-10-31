import 'package:flutter/material.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/log_any.dart';
import 'package:purus_lern_app/src/data/app_info.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/log_app_start_event.dart';
import 'package:purus_lern_app/src/core/firebase/initialize_firebase.dart';
import 'package:purus_lern_app/src/core/get_app_info.dart';
import 'package:purus_lern_app/src/core/get_platform_as_string.dart';
import 'package:purus_lern_app/src/core/presentation/rive_manager.dart';
import 'package:purus_lern_app/src/data/main_conditions.dart';
import 'package:purus_lern_app/src/data/shared_prefs/check_first_usage_sharedpref.dart';
import 'package:purus_lern_app/src/features/authentication/application/print_new_autologgin.dart';
import 'package:purus_lern_app/src/features/authentication/data/current_user.dart';
import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/biometrics_dont_ask_me_again_sharedpred.dart';
import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/biometrics_sharedpref.dart';
import 'package:purus_lern_app/src/features/authentication/application/local_auth/check_biometric_availability.dart';
import 'package:purus_lern_app/src/features/authentication/application/local_auth/local_auth_service.dart';
import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/get_and_refresh_current_user_sharedpref.dart';
import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/onboarding_status_sharedpref.dart';
import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/stay_logged_in_sharedpref.dart';
import 'package:purus_lern_app/src/features/authentication/data/login_conditions.dart';

Future<void> initializeApp() async {
  isFirstUsage = await checkFirstUsageSharedpref();

  currentPlatform = getPlatformAsString();

  await initializeFirebase();

  await RiveManager().initialize();

  // Auth
  isAutoLoggedIn = await StayLoggedInSharedpref().checkLoginStatus();
  currentUser = await getAndRefreshCurrentUserSharedpref();
  isOnboardingNotComplete =
      await OnboardingStatusSharedpref().isOnboardingDone();
  isBiometricsConfigured =
      await BiometricsSharedpref().getBiometricsConfigured();
  biometricAskedBeforeAndNo =
      await BiometricsDontAskMeAgainSharedpref().getDontAskAgainPreference();
  isDeviceSupportedForBiometric.value =
      await LocalAuthService().isDeviceSupported();
  await checkBiometricAvailability();
  availableBiometricsString =
      await LocalAuthService().getAvailableBiometricsInString();

  await getAppInfo();

  printNewAutologgin();

  debugPrint("isFirstUsage: $isFirstUsage");
  debugPrint("isOnboardingNotComplete: $isOnboardingNotComplete");
  debugPrint("biometricAskedBeforeAndNo: $biometricAskedBeforeAndNo");
  debugPrint("isBiometricsConfigured: $isBiometricsConfigured");
  debugPrint("isBiometricsAvailable: $isBiometricsAvailable");
  debugPrint("isDeviceSupportedForBiometric: $isDeviceSupportedForBiometric");
  debugPrint("availableBiometricsString: $availableBiometricsString");
  debugPrint("-------------");

  logAppStartEvent();
  logAny("isAutoLoggedIn", isAutoLoggedIn.toString());
}
