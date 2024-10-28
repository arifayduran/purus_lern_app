import 'package:flutter/material.dart';

void mySnackbar(BuildContext context, String text) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (ScaffoldMessenger.of(context).mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: const Color.fromARGB(176, 0, 56, 38),
            content: Text(text)),
      );
    }
  });
}
