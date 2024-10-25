import "dart:async";

import "package:flutter/material.dart";
import "package:purus_lern_app/src/core/moodle/daily_prompt_services.dart";
import "package:purus_lern_app/src/features/authentication/data/current_user.dart";

class DailyPromptWidget extends StatefulWidget {
  const DailyPromptWidget({super.key});

  @override
  State<DailyPromptWidget> createState() => _DailyPromptWidgetState();
}

class _DailyPromptWidgetState extends State<DailyPromptWidget> {
  Timer? _timer;
  int currentDailyPrompt = 0;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      refreshDailyPrompts();
    });
    super.initState();
  }

  void refreshDailyPrompts() async {
    currentDailyPrompt = await getDailyPrompts();
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text("Prompts übrig: ${currentDailyPrompt.toString()} (Täglich 50)");
  }
}
