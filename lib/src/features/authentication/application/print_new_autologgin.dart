import 'package:flutter/material.dart';
import 'package:purus_lern_app/src/features/authentication/data/current_user.dart';
import 'package:purus_lern_app/src/features/authentication/data/login_conditions.dart';

void printNewAutologgin() {
  debugPrint("-------------");
  debugPrint("isAutoLoggedIn: $isAutoLoggedIn");
  debugPrint(
      "currentUser: ${currentUser == null ? currentUser : "Userid: ${currentUser!.id}, Username: ${currentUser!.username}, firstname: ${currentUser!.firstname}, lastname: ${currentUser!.lastname}, Email: ${currentUser!.email}"}");
  debugPrint("userToken: $userToken");
  debugPrint("configuredAutoLoginDate: $configuredAutoLoginDate");
  debugPrint("remainingAutoLoggedInAsDays: $remainingAutoLoggedInAsDays");
  debugPrint("-------------");
}
