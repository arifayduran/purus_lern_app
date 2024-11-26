import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:purus_lern_app/firebase_options.dart';
import 'package:purus_lern_app/src/data/app_info.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/analytics_instance.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (currentPlatform != "Windows" && currentPlatform != "Unknown") {
    analytics = FirebaseAnalytics.instance;
  }

  if (currentPlatform != "Web" && currentPlatform != "Windows" && currentPlatform != "Unknown") {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
