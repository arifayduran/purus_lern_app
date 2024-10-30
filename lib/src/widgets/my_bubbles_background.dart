import 'dart:math';
import 'package:flutter/material.dart';
// import 'package:purus_lern_app/src/config/palette.dart';

class MyBubblesBackground extends StatefulWidget {
  const MyBubblesBackground({super.key});

  @override
  State<MyBubblesBackground> createState() => _MyBubblesBackgroundState();
}

class _MyBubblesBackgroundState extends State<MyBubblesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Bubble> _bubbles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat(reverse: true);
    _bubbles = List.generate(8, (index) => Bubble(index));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: BubblesPainter(_bubbles, _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class Bubble {
  final Random _random = Random();
  late double x;
  late double y;
  late double radius;
  late double speedX;
  late double speedY;
  double opacity = 0.0;
  bool appearing = true;
  final int index;

  Bubble(this.index) {
    _initializeBubble();
  }

  void _initializeBubble() {
    x = _random.nextDouble();
    y = _random.nextDouble();
    radius = 20.0 + _random.nextDouble() * 60.0;
    speedX = (0.5 - _random.nextDouble()) * 0.001;
    speedY = (0.5 - _random.nextDouble()) * 0.001;
    opacity = 0.0;
    appearing = true;
  }

  void update(double value) {
    final appearDelay = (index * 0.1).clamp(0.0, 1.0);

    if (value > appearDelay) {
      if (appearing) {
        opacity += 0.02;
        if (opacity >= 1.0) {
          opacity = 1.0;
          appearing = false;
        }
      } else {
        x += speedX;
        y += speedY;
        if (x > 1.0 || x < 0.0 || y > 1.0 || y < 0.0) {
          opacity -= 0.02;
          if (opacity <= 0.0) {
            _initializeBubble();
          }
        }
      }
    } else {
      opacity = 0.0;
    }
  }
}

class BubblesPainter extends CustomPainter {
  final List<Bubble> bubbles;
  final double animationValue;

  BubblesPainter(this.bubbles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
      bubble.update(animationValue);
      final paint = Paint()
        ..color =
            const Color.fromARGB(255, 19, 164, 118).withOpacity(bubble.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40.0);
      final x = bubble.x * size.width;
      final y = bubble.y * size.height;
      canvas.drawCircle(Offset(x, y), bubble.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
