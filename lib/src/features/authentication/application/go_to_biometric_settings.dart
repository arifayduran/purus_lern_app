import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';
import 'package:purus_lern_app/src/data/app_info.dart';
import 'package:purus_lern_app/src/widgets/my_snack_bar.dart';

void goToBiometricSettings(BuildContext context) {
  if (currentPlatform == "Android") {
    AppSettings.openAppSettings(type: AppSettingsType.security);
  } else if (currentPlatform == "IOS") {
    AppSettings.openAppSettings(type: AppSettingsType.settings);
  } else {
    mySnackbar(context,
        "Leider kann auf dieser Plattform nicht zu den Einstellungen navigiert werden.");
  }
}
