import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:purus_lern_app/src/config/palette.dart';
import 'package:purus_lern_app/src/config/theme.dart';

class MyButton extends StatefulWidget {
  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    this.buttonHeight = 53.0,
    this.buttonWidth = 340.0,
    this.fontSize = 21,
    this.textColor = Colors.white,
    this.bgColor = purusDarkerGreen,
    this.strokeColor = purusGreen,
    this.borderRadius = 43.0,
    this.icon,
  });
  final VoidCallback onTap;
  final String text;
  final double buttonWidth;
  final double buttonHeight;
  final double fontSize;
  final Color textColor;
  final Color bgColor;
  final Color strokeColor;
  final double borderRadius;
  final Widget? icon;

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool isPressed = false;

  void _handleTap() {
    widget.onTap();
    _onPress();
    Future.delayed(const Duration(milliseconds: 100), _onRelease);
  }

  void _onPress() {
    setState(() {
      isPressed = true;
    });
  }

  void _onRelease() {
    setState(() {
      isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onTapDown: (_) => _onPress(),
      onTapUp: (_) => _onRelease(),
      onTapCancel: () => _onRelease(),
      child: CustomPaint(
        painter: _ButtonPainter(
          isPressed: isPressed,
          bgColor: widget.bgColor,
          strokeColor: widget.strokeColor,
          borderRadius: widget.borderRadius,
        ),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: widget.bgColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 0.0,
                strokeAlign: BorderSide.strokeAlignInside,
                color: widget.strokeColor,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            shadows: [
              myBoxshadowOutside(),
            ],
          ),
          child: InnerShadow(
            shadows: [
              if (isPressed)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(2, 10),
                )
              else
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(2, 10),
                ),
            ],
            child: Container(
              clipBehavior: Clip.antiAlias,
              width: widget.buttonWidth,
              height: widget.buttonHeight,
              decoration: ShapeDecoration(
                color: widget.bgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000), // nicht das!
                    blurRadius: 14,
                    offset: Offset(7, 7),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: widget.fontSize,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                            color: widget.textColor.withValues(alpha: 0.5),
                            blurRadius: 10,
                            offset: const Offset(1, 1))
                      ],
                      height: 0,
                    ),
                  ),
                  widget.icon != null
                      ? const SizedBox(
                          width: 10,
                        )
                      : const SizedBox(),
                  widget.icon ?? const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonPainter extends CustomPainter {
  final bool isPressed;
  final Color bgColor;
  final Color strokeColor;
  final double borderRadius;

  _ButtonPainter({
    required this.isPressed,
    required this.bgColor,
    required this.strokeColor,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final paint = Paint()..color = bgColor;
    canvas.drawRRect(rrect, paint);

    if (isPressed) {
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 10);
      canvas.drawRRect(rrect, shadowPaint);
    } else {
      final shadowPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 10);
      canvas.drawRRect(rrect, shadowPaint);
    }

    final borderPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(_ButtonPainter oldDelegate) {
    return isPressed != oldDelegate.isPressed ||
        bgColor != oldDelegate.bgColor ||
        strokeColor != oldDelegate.strokeColor ||
        borderRadius != oldDelegate.borderRadius;
  }
}
