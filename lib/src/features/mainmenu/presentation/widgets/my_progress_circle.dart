import 'package:flutter/material.dart';
import 'package:purus_lern_app/src/config/palette.dart';
import 'package:purus_lern_app/src/features/mainmenu/data/progress.dart';

class MyProgressCircle extends StatefulWidget {
  const MyProgressCircle({
    super.key,
  });

  @override
  State<MyProgressCircle> createState() => _MyProgressCircleState();
}

class _MyProgressCircleState extends State<MyProgressCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _circleAnimationController;

  @override
  void initState() {
    super.initState();
    _circleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    progressNotifier.addListener(() {
      _circleAnimationController.animateTo(progressNotifier.value,
          curve: Curves.easeInOut);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _circleAnimationController.animateTo(progressNotifier.value,
          curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _circleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: purusGreen,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: progressNotifier,
                builder: (context, value, child) {
                  return Text(
                    "${(value * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        fontSize: 16),
                  );
                },
              ),
            ),
          ),
        ),
        SizedBox.expand(
          child: AnimatedBuilder(
            animation: _circleAnimationController,
            builder: (context, child) {
              return CircularProgressIndicator(
                backgroundColor: purusLightGreen,
                color: purusGreen,
                value: _circleAnimationController.value,
                strokeWidth: 8,
                strokeCap: StrokeCap.round,
              );
            },
          ),
        ),
        TextButton(
            onPressed: () {
              progressNotifier.value += 0.05;
            },
            child: const Text("progress test +5%")),
      ],
    );
  }
}
