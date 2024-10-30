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
