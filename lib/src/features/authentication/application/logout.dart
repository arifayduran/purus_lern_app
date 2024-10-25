import 'package:flutter/material.dart';
import 'package:purus_lern_app/main.dart';
import 'package:purus_lern_app/src/core/main_initialize.dart';
import 'package:purus_lern_app/src/features/authentication/data/current_user.dart';
import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/stay_logged_in_sharedpref.dart';

void logout(BuildContext context) {
  StayLoggedInSharedpref().sharedLogout();
  currentUser = null;
  initializeApp();

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const PurusMain()),
    (Route<dynamic> route) => false,
  );
}
