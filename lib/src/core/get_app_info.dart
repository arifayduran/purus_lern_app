import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:purus_lern_app/src/data/app_info.dart';

Future<void> getAppInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  appName = packageInfo.appName;
  packageName = packageInfo.packageName;
  appVersion = packageInfo.version;
  buildNumber = packageInfo.buildNumber;
  buildSignature = packageInfo.buildSignature;
  installerStore = packageInfo.installerStore ?? "Unknown";

  debugPrint('App Name: $appName');
  debugPrint('Package Name: $packageName');
  debugPrint('App Version: $appVersion');
  debugPrint('Build Number: $buildNumber');
  debugPrint('Build Signature: $buildSignature');
  debugPrint('Installer Store: $installerStore');
}
