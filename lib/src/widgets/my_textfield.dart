import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purus_lern_app/src/config/palette.dart';
import 'package:purus_lern_app/src/config/theme.dart';

class MyTextfield extends StatelessWidget {
  const MyTextfield({
    super.key,
    this.bgColor = Colors.white,
    // this.height = 53.0,
    // this.width = 340.0,
    this.controller,
    this.hintText,
    this.textColor = purusDarkGrey,
    this.hintColor = purusGrey,
    this.strokeColor = purusGrey,
    this.borderRadius = 11,
    this.focusNode,
    this.validator,
    this.onSubmitted,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autocorrect = false,
    this.capitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.cursorColor = purusGreen,
    this.maxLines = 1,
    this.maxLength,
    this.prefix,
    this.suffix,
    this.icon,
    this.label,
    this.labelText,
    this.labelStyle,
    this.helper,
    this.helperText,
    this.autofocus = false,
    this.isDence = false,
    this.showCursor = true,
    this.inputFormatters,
    this.autofillHints,
  });

  final Color bgColor;
  // final double height;
  // final double width;
  final TextEditingController? controller;
  final String? hintText;
  final Color textColor;
  final Color hintColor;
  final Color strokeColor;
  final double borderRadius;
  final FocusNode? focusNode;
  final String Function(String?)? validator;
  final void Function(String)? onSubmitted;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autocorrect;
  final TextCapitalization capitalization;
  final TextAlign textAlign;
  final Color cursorColor;
  final int maxLines;
  final int? maxLength;
  final Widget? prefix;
  final Widget? suffix;
  final Icon? icon;
  final Widget? label;
  final String? labelText;
  final TextStyle? labelStyle;
  final Widget? helper;
  final String? helperText;
  final bool autofocus;
  final bool isDence;
  final bool showCursor;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: height,
      // width: width,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.5,
            strokeAlign: BorderSide.strokeAlignInside,
            color: strokeColor,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        shadows: [myBoxshadowOutside()],
      ),
      child: TextFormField(
        controller: controller,
        autovalidateMode: AutovalidateMode.always,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        focusNode: focusNode,
        onFieldSubmitted: onSubmitted,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        showCursor: showCursor,
        autocorrect: autocorrect,
        textCapitalization: capitalization,
        textAlign: textAlign,
        cursorColor: cursorColor,
        autofillHints: autofillHints,
        decoration: InputDecoration(
          prefix: prefix,
          suffix: suffix,
          isDense: isDence,
          icon: icon,
          focusColor: Colors.black,
          prefixIconColor: purusGrey,
          iconColor: purusGrey,
          suffixIconColor: purusGrey,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          hintText: hintText,
          label: label,

          labelText: labelText,
          labelStyle: labelStyle,
          helper: helper,
          helperText: helperText,
          filled: true,
          fillColor: bgColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 27, vertical: 14),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: purusRed,
              width: 1,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: strokeColor,
              width: 0.5,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          // border: OutlineInputBorder(
          //   borderSide: const BorderSide(
          //     color: Colors.red,
          //   ),
          //   borderRadius: BorderRadius.circular(borderRadius),
          // ),
        ),
        maxLines: maxLines,
        maxLength: maxLength,
        validator: validator,
        obscureText: obscureText,
        autofocus: autofocus,
      ),
    );
  }
}
