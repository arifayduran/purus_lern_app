import 'package:flutter/material.dart';
import 'package:purus_lern_app/src/config/gradients.dart';
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

const Map<String, Widget> mainScreens = {
  "Hauptmenü": MainmenuScreen(),
  "Lernmenü": EducationScreen(),
  "Lexikon": LexiconScreen(),
  "Einstellungen": SettingsScreen(),
};

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (isFirstUsage) {
      chatbotCurrentMessage =
          "Hallo ${currentUser!.firstname}! Ich bin Purutus, dein Lern-Coach für Pflege. Frag mich doch gerne etwas! 💬";
    } else {
      chatbotCurrentMessage = getRandomChatbotMessage();
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: MyBackgroundGradient().myBackgroundGradient(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const MyAnimatedTopBarWidget(),
        body: mainScreens.values.toList()[_currentIndex],
        bottomNavigationBar: MyAnimatedBottomAppBarWidget(
          currentIndex: _currentIndex,
          onTabSelected: _onTabSelected,
        ),
      ),
    );
  }
}
