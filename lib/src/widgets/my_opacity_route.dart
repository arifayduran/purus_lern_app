import 'package:flutter/material.dart';

Route myOpacityRoute(Widget page,
    {Duration duration = const Duration(milliseconds: 500)}) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: duration,
  );
}


// Navigator.of(context).push(myOpacityRoute(
//  ChatbotScreen(firstRequest: chatbotCurrentMessage),
//   duration: Duration(seconds: 1),
// ));
