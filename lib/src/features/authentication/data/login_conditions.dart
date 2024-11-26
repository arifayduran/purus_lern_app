import 'package:flutter/material.dart';

// Route bedingt
bool isAutoLoggedIn = false;
bool isOnboardingNotComplete = true;
bool isBiometricsConfigured = false;

bool biometricAskedBeforeAndNo = false;

// UI bedingt
ValueNotifier<bool> isBiometricsAvailable = ValueNotifier<bool>(false);
ValueNotifier<bool> isDeviceSupportedForBiometric = ValueNotifier<bool>(false);
late String availableBiometricsString;
