import 'package:flutter/material.dart';

// Route bedingt
bool isLoggedIn = false;
bool isOnboardingNotComplete = true;
bool isBiometricsConfigured = false;

bool biometricAskedBeforeAndNo = false;

// UI bedingt
ValueNotifier<bool> isBiometricAvailable = ValueNotifier<bool>(false);
ValueNotifier<bool> isDeviceSupportedForBiometric = ValueNotifier<bool>(false);
late String availableBiometricsString;
