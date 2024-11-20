import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:purus_lern_app/src/config/gradients.dart';
import 'package:purus_lern_app/src/core/presentation/loading_blur_states.dart';
import 'package:purus_lern_app/src/core/presentation/logout_empty_screen.dart';
import 'package:purus_lern_app/src/data/home_screen_index_state.dart';
import 'package:purus_lern_app/src/data/main_conditions.dart';
import 'package:purus_lern_app/src/features/authentication/data/current_user.dart';
import 'package:purus_lern_app/src/features/chatbot/application/chatbot_random_message.dart';
import 'package:purus_lern_app/src/features/chatbot/data/chatbot_current_message.dart';
import 'package:purus_lern_app/src/widgets/my_animated_bottom_bar_widget.dart';
import 'package:purus_lern_app/src/widgets/my_animated_top_bar_widget.dart';
import 'package:purus_lern_app/src/features/mainmenu/presentation/main_menu_screen.dart';
import 'package:purus_lern_app/src/features/education_portal/education_screen.dart';
import 'package:purus_lern_app/src/features/lexicon/presentation/lexicon_screen.dart';
import 'package:purus_lern_app/src/features/settings/presentation/settings_screen.dart';
// import 'package:purus_lern_app/src/widgets/my_bubbles_background.dart';

// Positioned(
//   top: 0,
//   child: SizedBox(
//       height: MediaQuery.of(context).size.height * 0.6,
//       width: MediaQuery.of(context).size.width,
//       child: const MyBubblesBackground()),
// ),

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, Widget> mainScreens = {
    "Hauptmenü": MainmenuScreen(),
    "Lernmenü": EducationScreen(),
    "Lexikon": LexiconScreen(),
    "Einstellungen": SettingsScreen(),
    "Logout Empty Screen": LogoutEmptyScreen(),
  };

  @override
  void initState() {
    super.initState();
    homeScreenIndexState.value = 0;

    // if (isAutoLoggedIn &&
    //     !isBiometricsConfigured &&
    //     isBiometricsAvailable.value) {
    //   _askConfigBiometricsAfterLogin(context);
    // }

    if (isFirstUsage) {
      chatbotCurrentMessage =
          "Hallo ${currentUser!.firstname}! Ich bin Purutus, dein Lern-Coach für Pflege. Frag mich doch gerne etwas! 💬";
    } else {
      chatbotCurrentMessage = getRandomChatbotMessage();
    }

    loadingValueNotifierBlur.value = true;
    loadingValueNotifierBlurOpacity.value = 0.6;
    loadingValueNotifierAnimation.value = true;
    loadingValueNotifierText.value = "Wird geladen...";

    Timer(Duration(seconds: 2), () {
      loadingValueNotifierBlur.value = false;
      loadingValueNotifierBlurOpacity.value = 0.3;
      loadingValueNotifierAnimation.value = false;
      loadingValueNotifierText.value = "";
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      homeScreenIndexState.value = index;
    });
  }

  // void _askConfigBiometricsAfterLogin(
  //   BuildContext context,
  // ) {
  //   loadingValueNotifierBlur.value = true;

  //   showCupertinoDialog(
  //     context: context,
  //     builder: (BuildContext context1) {
  //       return StatefulBuilder(
  //         builder: (context2, setDialogState) {
  //           return CupertinoAlertDialog(
  //             title: const Text("Erfolgreich Angemeldet"),
  //             content: Column(
  //               children: [
  //                 const Text(
  //                   "Möchten Sie biometrisches Anmeldeverfahren einrichten?",
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Material(
  //                   color: Colors.transparent,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Checkbox(
  //                         checkColor: Colors.white,
  //                         activeColor: purusGreen,
  //                         value: _dontAskMeAgain,
  //                         onChanged: (bool? value) {
  //                           setDialogState(() {
  //                             _dontAskMeAgain = value ?? false;
  //                           });
  //                         },
  //                       ),
  //                       GestureDetector(
  //                         onTap: () {
  //                           setDialogState(() {
  //                             _dontAskMeAgain = !_dontAskMeAgain;
  //                           });
  //                         },
  //                         child: const Text(
  //                           "Nicht erneut fragen",
  //                           style:
  //                               TextStyle(fontFamily: "SF Pro", fontSize: 12),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             actions: [
  //               CupertinoDialogAction(
  //                 onPressed: () async {
  //                   setState(() {
  //                     _isBlurEffect = false;
  //                   });

  //                   await updateBiometrics(false);

  //                   if (_dontAskMeAgain) {
  //                     await BiometricsDontAskMeAgainSharedpref()
  //                         .setDontAskAgainPreference(true);
  //                   }

  //                   if (mounted) {
  //                     // ignore: use_build_context_synchronously
  //                     Navigator.pop(context1);

  //                     mySnackbar(
  //                       // ignore: use_build_context_synchronously
  //                       context,
  //                       "Sie können biometrisches Anmeldeverfahren jederzeit in den Einstellungen einrichten.",
  //                     );
  //                   }

  //                   _routeToHomeScreen();
  //                 },
  //                 child: const Text(
  //                   "Nein",
  //                   style: TextStyle(color: CupertinoColors.destructiveRed),
  //                 ),
  //               ),
  //               CupertinoDialogAction(
  //                 onPressed: () async {
  //                   if (_dontAskMeAgain) {
  //                     await BiometricsDontAskMeAgainSharedpref()
  //                         .setDontAskAgainPreference(true);
  //                   }
  //                   if (_stayLoggedBox) {
  //                     if (mounted) {
  //                       // ignore: use_build_context_synchronously
  //                       Navigator.pop(context1);
  //                     }
  //                     _checkBiometricsAfterLogin();
  //                   } else {
  //                     if (mounted) {
  //                       // ignore: use_build_context_synchronously
  //                       Navigator.pop(context1);
  //                     }
  //                     if (mounted) {
  //                       // ignore: use_build_context_synchronously
  //                       _askStayLoggedInAfterLogin(context);
  //                     }
  //                   }
  //                 },
  //                 child: const Text(
  //                   "Ja",
  //                   style: TextStyle(color: CupertinoColors.activeBlue),
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  // Future<void> _checkBiometricsAfterLogin() async {
  //   try {
  //     setState(() {
  //       _isBlurEffect = true;
  //     });
  //     bool authenticated = await _localAuthService.authenticateUser();
  //     setState(() {
  //       _isBlurEffect = false;
  //     });
  //     if (authenticated) {
  //       await updateBiometrics(true);
  //       if (mounted) {
  //         mySnackbar(context,
  //             "Biometrisches Anmeldeverfahren erfolgreich eingerichtet.");
  //       }
  //       _routeToHomeScreen();
  //     } else {
  //       await updateBiometrics(false);
  //       await checkBiometricAvailability();
  //       if (!isBiometricsAvailable.value) {
  //         setState(() {});
  //         if (mounted) {
  //           mySnackbar(context,
  //               "Erlaubnis für biometrisches Anmeldeverfahren fehlt. Sie können es jederzeit nach Erlaubniserteilung in den Einstellungen einrichten.");
  //         } else {
  //           if (mounted) {
  //             mySnackbar(context,
  //                 "Fehler bei der Einrichtung. Sie können es jederzeit in den Einstellungen einrichten.");
  //           }
  //         }
  //       }
  //       _routeToHomeScreen();
  //     }
  //   } catch (e) {
  //     debugPrint("-------------");
  //     debugPrint(e.toString());
  //     debugPrint("-------------");
  //     if (mounted) {
  //       mySnackbar(context,
  //           "Fehler bei der Einrichtung. Sie können es jederzeit in den Einstellungen einrichten.");
  //     }
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MyBackgroundGradient().myBackgroundGradient(),
      child: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: homeScreenIndexState,
            builder: (context, value, child) => Scaffold(
              backgroundColor: Colors.transparent,
              appBar: const MyAnimatedTopBarWidget(),
              body: mainScreens.values.toList()[value],
              bottomNavigationBar: MyAnimatedBottomAppBarWidget(
                currentIndex: value,
                onTabSelected: _onTabSelected,
              ),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: loadingValueNotifierBlur,
              builder: (context1, value, child) {
                if (value) {
                  return Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: ValueListenableBuilder(
                        valueListenable: loadingValueNotifierBlurOpacity,
                        builder: (context, value, child) =>
                            Container(color: Colors.black.withOpacity(value)),
                      ),
                    ),
                  );
                } else {
                  return Positioned(top: 0, child: SizedBox());
                }
              }),
          ValueListenableBuilder(
              valueListenable: loadingValueNotifierAnimation,
              builder: (context1, value, child) {
                if (value) {
                  return ValueListenableBuilder(
                    valueListenable: loadingValueNotifierText,
                    builder: (context1, value, child) {
                      if (value.isNotEmpty) {
                        return Center(
                          child: LottieBuilder.asset(
                            "assets/animations/loading_heartbeat_freq_white.json",
                            width: 300,
                          ),
                        );
                      } else {
                        return Positioned(top: 0, child: SizedBox());
                      }
                    },
                  );
                } else {
                  return Positioned(top: 0, child: SizedBox());
                }
              }),
          ValueListenableBuilder(
              valueListenable: loadingValueNotifierBlur,
              builder: (context1, value, child) {
                if (value) {
                  return ValueListenableBuilder(
                    valueListenable: loadingValueNotifierText,
                    builder: (context1, value, child) {
                      if (value.isNotEmpty) {
                        return Positioned(
                            bottom: MediaQuery.of(context).size.height * 0.20,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                loadingValueNotifierText.value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                    letterSpacing: 0.5,
                                    decoration: TextDecoration.none),
                              ),
                            ));
                      } else {
                        return Positioned(top: 0, child: SizedBox());
                      }
                    },
                  );
                } else {
                  return Positioned(top: 0, child: SizedBox());
                }
              }),
        ],
      ),
    );
  }
}
