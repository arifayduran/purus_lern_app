import 'dart:async';

import 'package:flutter/material.dart';
import 'package:purus_lern_app/main.dart';
import 'package:purus_lern_app/src/core/main_initialize.dart';
import 'package:purus_lern_app/src/core/presentation/loading_blur_states.dart';
import 'package:purus_lern_app/src/features/authentication/data/current_user.dart';
import 'package:purus_lern_app/src/features/authentication/data/login_conditions.dart';
import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/biometrics_sharedpref.dart';
import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/stay_logged_in_sharedpref.dart';

void logout(BuildContext context) async {
  await StayLoggedInSharedpref().sharedLogout();
  await updateBiometrics(false);
  isAutoLoggedIn = false;
  currentUser = null;
  userToken = null;
  configuredAutoLoginDate = null;
  remainingAutoLoggedInAsDays = null;
  await initializeApp();

  Timer(Duration(seconds: 2), () {
    loadingValueNotifierBlur.value = false;
    loadingValueNotifierBlurOpacity.value = 0.3;
    loadingValueNotifierAnimation.value = false;
    loadingValueNotifierText.value = "";

    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => const PurusMain()),
      (Route<dynamic> route) => false,
    );
  });
}
