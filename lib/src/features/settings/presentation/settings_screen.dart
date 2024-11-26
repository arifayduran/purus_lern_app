import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purus_lern_app/src/config/const_stay_logged_in_days.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/log_any.dart';
import 'package:purus_lern_app/src/core/get_app_info.dart';
import 'package:purus_lern_app/src/core/presentation/loading_blur_states.dart';
import 'package:purus_lern_app/src/data/app_info.dart';
import 'package:purus_lern_app/src/core/image_picker_with_source_choose.dart';
import 'package:purus_lern_app/src/data/home_screen_index_state.dart';
import 'package:purus_lern_app/src/features/authentication/application/moodle/profile_image_uploader.dart';
import 'package:purus_lern_app/src/features/authentication/application/moodle/refresh_user_info_from_id.dart';
import 'package:purus_lern_app/src/features/authentication/application/moodle/get_user_info_from_login.dart';
import 'package:purus_lern_app/src/features/authentication/application/print_new_autologgin.dart';
import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/biometrics_dont_ask_me_again_sharedpred.dart';
import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/biometrics_sharedpref.dart';
import 'package:purus_lern_app/src/features/authentication/application/go_to_biometric_settings.dart';
import 'package:purus_lern_app/src/features/authentication/application/local_auth/check_biometric_availability.dart';
import 'package:purus_lern_app/src/features/authentication/application/local_auth/local_auth_service.dart';
import 'package:purus_lern_app/src/features/authentication/application/local_auth/refresh_biometric_state.dart';
import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/onboarding_status_sharedpref.dart';
import 'package:purus_lern_app/src/features/authentication/data/login_conditions.dart';
import 'package:purus_lern_app/src/features/authentication/data/current_user.dart';
import 'package:purus_lern_app/src/features/authentication/data/shared_prefs/stay_logged_in_sharedpref.dart';
import 'package:purus_lern_app/src/features/chatbot/data/shared_prefs/daily_prompts_sharedpref.dart';
import 'package:purus_lern_app/src/widgets/my_cupertino_dialog.dart';
import 'package:purus_lern_app/src/widgets/my_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _tempPrintUserInfoController =
      TextEditingController();

  final LocalAuthService _localAuthService = LocalAuthService();

  Timer? _timer;

  @override
  void initState() {
    _tempPrintUserInfoController.text = currentUser!.username;
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      refreshUserInfo();
      _refreshBiometricState();
    });
    super.initState();
  }

  void refreshUserInfo() async {
    currentUser = await refreshUserinfoFromId(currentUser!.id);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _refreshBiometricState() async {
    await refreshBiometricState(context, false, false);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _checkBiometrics() async {
    try {
      loadingValueNotifierBlur.value = true;
      bool authenticated = await _localAuthService.authenticateUser();
      loadingValueNotifierBlur.value = false;
      if (authenticated) {
        if (mounted) {
          await updateBiometrics(true);
          setState(() {});
          if (mounted) {
            mySnackbar(context,
                "Biometrisches Anmeldeverfahren erfolgreich eingerichtet.");
          }
        }
      } else {
        await updateBiometrics(false);

        setState(() {});
        await checkBiometricAvailability();
        if (!isBiometricsAvailable.value) {
          setState(() {});
          if (mounted) {
            mySnackbar(context,
                "Erlaubnis für biometrisches Anmeldeverfahren fehlt. Sie können es jederzeit nach Erlaubniserteilung in den Einstellungen einrichten.");
          }
        } else {
          if (mounted) {
            mySnackbar(context,
                "Fehler bei der Einrichtung. Sie können es jederzeit in den Einstellungen einrichten.");
          }
        }
      }
    } catch (e) {
      await updateBiometrics(false);
      debugPrint(e.toString());
      if (mounted) {
        mySnackbar(context,
            "Fehler bei der Einrichtung. Sie können es jederzeit in den Einstellungen einrichten.");
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                loadingValueNotifierBlur.value = true;
                loadingValueNotifierBlurOpacity.value = 0.0;
                File? image =
                    await ImagePickerWithSourceChoose().pickImage(context);
                if (mounted) {
                  if (image != null) {
                    loadingValueNotifierBlurOpacity.value = 0.5;
                    loadingValueNotifierAnimation.value = true;
                    loadingValueNotifierText.value = "Wird Hochgeladen...";
                    // ignore: use_build_context_synchronously
                    await profileImageUploader(image, context, mounted);
                  } else {
                    // ignore: use_build_context_synchronously
                    mySnackbar(context, "Kein Bild ausgewählt.");
                  }
                }

                loadingValueNotifierBlur.value = false;
                loadingValueNotifierBlurOpacity.value = 0.3;
                loadingValueNotifierAnimation.value = false;
                loadingValueNotifierText.value = "";
              },
              child: SizedBox(
                height: 100,
                child: Image.network(
                  currentUser!.profileImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                getAppInfo();
              },
              child: Text("get app info"),
            ),
            Column(
              children: [
                Text("User-ID: ${currentUser!.id}"),
                Text("Username: ${currentUser!.username}"),
                Text("E-Mail: ${currentUser!.email}"),
                Text(
                    "Fullname: ${currentUser!.firstname} ${currentUser!.lastname}"),
              ],
            ),
            TextButton(
                onPressed: () {
                  goToBiometricSettings(context);
                },
                child: Text("erlaubnis für biometrische anmeldung")),
            TextButton(
                onPressed: () {
                  _refreshBiometricState();
                },
                child: Text(
                    "Refresh biometric state auto wie loginplace / App Neustarten hinweisen?")),
            TextButton(
                onPressed: () {
                  loadingValueNotifierBlur.value = true;
                  myCupertinoDialog(
                    context,
                    "Ausloggen",
                    "Möchten Sie sich ausloggen?",
                    null,
                    null,
                    "Abbrechen",
                    "Ja",
                    () {
                      loadingValueNotifierBlur.value = false;
                    },
                    () {
                      // loadingValueNotifierBlur.value = false;
                      loadingValueNotifierBlur.value = true;
                      loadingValueNotifierBlurOpacity.value = 0.6;
                      loadingValueNotifierAnimation.value = true;
                      loadingValueNotifierText.value =
                          "Sie werden Abgemeldet...";

                      _timer!.cancel();
                      homeScreenIndexState.value = 4;
                      // logout(context);
                    },
                    CupertinoColors.activeBlue,
                    CupertinoColors.destructiveRed,
                  );
                },
                child: const Text("Logout")),
            isAutoLoggedIn
                ? Text(remainingAutoLoggedInAsDays == 0
                    ? "Letzter Tag für Auto-Login"
                    : "Auto-Login $remainingAutoLoggedInAsDays Tage übrig")
                : TextButton(
                    onPressed: () async {
                      logAny("isAutoLoggedIn_inSettings", "true");
                      await StayLoggedInSharedpref()
                          .setLoginStatus(true, currentUser!, userToken!);
                      isAutoLoggedIn =
                          await StayLoggedInSharedpref().checkLoginStatus();
                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        mySnackbar(context,
                            "Automatische Anmeldung für $constStayLoggedInDays Tage eingerichtet.");
                      }

                      setState(() {});
                      printNewAutologgin();
                    },
                    child: const Text("Auto-Login aktivieren"),
                  ),
            TextButton(onPressed: () {}, child: const Text("Show Onboarding")),
            TextButton(
                onPressed: () async {
                  isOnboardingNotComplete = true;
                  await OnboardingStatusSharedpref()
                      .setOnboardingStatusSharedpref(true);
                  debugPrint("-------------");
                  debugPrint("isOnboardingNotComplete: true");
                  debugPrint("-------------");
                },
                child: const Text("Reset Onboarding")),
            TextButton(
                onPressed: () {
                  DailyPromptsSharedPrefs().resetDailyPrompts();
                },
                child: const Text("reset daily prompt 50")),
            TextButton(
                onPressed: () async {
                  biometricAskedBeforeAndNo = false;
                  await BiometricsDontAskMeAgainSharedpref()
                      .setDontAskAgainPreference(false);
                },
                child: const Text("Reset Biometric Dont ask me again")),
            Text("Software Version: $appVersion"),
            Text("Entwickler: Arif Ayduran"),
            SizedBox(
              height: 110,
              width: 200,
              child: ValueListenableBuilder<bool>(
                valueListenable: isBiometricsAvailable,
                builder: (context1, value, child) {
                  if (value) {
                    if (isBiometricsConfigured) {
                      return TextButton(
                          onPressed: () async {
                            loadingValueNotifierBlur.value = true;
                            myCupertinoDialog(
                              context,
                              "Bestätigen",
                              "Möchten Sie das biometrische Anmeldeverfahren ausschalten?",
                              null,
                              null,
                              "Nein",
                              "Ja",
                              () {
                                loadingValueNotifierBlur.value = false;
                              },
                              () async {
                                await updateBiometrics(false);
                                setState(() {});
                                loadingValueNotifierBlur.value = false;
                                if (mounted) {
                                  // ignore: use_build_context_synchronously
                                  mySnackbar(context,
                                      "Biometrisches Anmeldeverfahren erfolgreich ausgeschaltet.");
                                }
                              },
                              CupertinoColors.activeBlue,
                              CupertinoColors.destructiveRed,
                            );
                          },
                          child: const Text(
                              "Biometrisches Anmeldeverfahren ausschalten"));
                    } else {
                      return TextButton(
                          onPressed: () {
                            loadingValueNotifierBlur.value = true;
                            if (!isAutoLoggedIn) {
                              myCupertinoDialog(
                                context,
                                "Auto-Login Aus",
                                "Möchten Sie automatisches Anmelden einschalten, um Biometrics zu benutzen?",
                                null,
                                null,
                                "Nein",
                                "Ja",
                                () {
                                  logAny("isAutoLoggedIn", "false");
                                  loadingValueNotifierBlur.value = false;
                                },
                                () async {
                                  logAny("isAutoLoggedIn", "true");
                                  loadingValueNotifierBlur.value = false;

                                  await StayLoggedInSharedpref().setLoginStatus(
                                      true, currentUser!, userToken!);
                                  isAutoLoggedIn =
                                      await StayLoggedInSharedpref()
                                          .checkLoginStatus();
                                  if (mounted) {
                                    // ignore: use_build_context_synchronously
                                    mySnackbar(context,
                                        "Automatische Anmeldung für $constStayLoggedInDays Tage eingerichtet.");
                                  }

                                  setState(() {});
                                  _checkBiometrics();
                                  printNewAutologgin();
                                },
                                CupertinoColors.destructiveRed,
                                CupertinoColors.activeBlue,
                              );
                            } else {
                              _checkBiometrics();
                            }
                          },
                          child: const Text(
                              "Biometrisches Anmeldeverfahren einrichten"));
                    }
                  } else {
                    return ValueListenableBuilder<bool>(
                        valueListenable: isDeviceSupportedForBiometric,
                        builder: (context, value, child) {
                          if (value) {
                            return TextButton(
                                onPressed: () {
                                  goToBiometricSettings(
                                    context,
                                  );
                                },
                                child: const Text(
                                    "Erlaubnis für biometrisches Anmeldeverfahren erteilen"));
                          } else {
                            return Column(
                              children: [
                                Text(
                                    "Ihr Gerät oder die Platform ist für biometrische Anmeldeverfahren nicht geeignet oder ausgeschaltet."),
                                TextButton(
                                    onPressed: () {
                                      goToBiometricSettings(context);
                                    },
                                    child: const Text("Zu den Einstellungen"))
                              ],
                            );
                          }
                        });
                  }
                },
              ),
            ),
            Row(
              children: [
                SizedBox(
                    height: 20,
                    width: 110,
                    child: TextField(
                      controller: _tempPrintUserInfoController,
                    )),
                ElevatedButton(
                    onPressed: () async {
                      loadingValueNotifierBlur.value = true;
                      loadingValueNotifierBlurOpacity.value = 0.3;
                      loadingValueNotifierAnimation.value = true;
                      loadingValueNotifierText.value =
                          'Ladet Userdaten von "${_tempPrintUserInfoController.text}"...';
                      await getUserinfoFromLogin(
                          _tempPrintUserInfoController.text);
                      loadingValueNotifierBlur.value = false;
                      loadingValueNotifierBlurOpacity.value = 0.3;
                      loadingValueNotifierAnimation.value = false;
                      loadingValueNotifierText.value = "";
                    },
                    child: Text("Print user info from logininput")),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool("isFirstUsage", true);
                },
                child: Text("Reset isFirstUsage")),
          ],
        ),
      ),
    );
  }
}
