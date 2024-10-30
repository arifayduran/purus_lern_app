import 'package:flutter/material.dart';
import 'package:purus_lern_app/src/config/palette.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.textColor,
  });

  final VoidCallback onPressed;
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: const ButtonStyle(
        overlayColor: WidgetStatePropertyAll(purusGreen),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: fontSize,
            fontWeight: fontWeight),
      ),
    );
  }
}
