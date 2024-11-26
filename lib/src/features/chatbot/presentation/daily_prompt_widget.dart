import "dart:async";

import "package:flutter/material.dart";
import "package:purus_lern_app/src/features/chatbot/data/shared_prefs/daily_prompts_sharedpref.dart";

class DailyPromptWidget extends StatefulWidget {
  const DailyPromptWidget({super.key});

  @override
  State<DailyPromptWidget> createState() => _DailyPromptWidgetState();
}

class _DailyPromptWidgetState extends State<DailyPromptWidget> {
  final DailyPromptsSharedPrefs _dailyPromptsManager =
      DailyPromptsSharedPrefs();
  Timer? _timer;
  int currentDailyPrompt = 0;

  @override
  void initState() {
    _getDailyPrompts();
    _checkAndResetDailyPrompts();
    _startMidnightCheck();
    // _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
    //   refreshDailyPrompts();
    // });
    super.initState();
  }

  void _startMidnightCheck() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      _getDailyPrompts();
      final now = DateTime.now();
      if (now.hour == 0 && now.minute == 0) {
        await _checkAndResetDailyPrompts();
      }
    });
  }

  void _getDailyPrompts() async {
    currentDailyPrompt = await _dailyPromptsManager.getDailyPrompts();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _checkAndResetDailyPrompts() async {
    await _dailyPromptsManager.checkAndResetDailyPrompts();
  }

  // void refreshDailyPrompts() async {
  //   // currentDailyPrompt = await getDailyPrompts();
  //   if (!mounted) return;
  //   setState(() {});
  // }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getStringOfPrompts(currentDailyPrompt),
      style: TextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w500,
        color: const Color.fromARGB(255, 227, 227, 227),
      ),
    );
  }
}

String getStringOfPrompts(int currentDailyPrompt) {
  switch (currentDailyPrompt) {
    case 0:
      return "Keine Fragen mehr übrig";
    case 1:
      return "Letzte übrige Frage";
    default:
      return "$currentDailyPrompt Fragen übrig";
  }
}
