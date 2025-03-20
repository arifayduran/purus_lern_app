import 'package:flutter/material.dart';
import 'package:purus_lern_app/src/data/app_info.dart';
import 'package:purus_lern_app/src/core/main_initialize.dart';
import 'package:purus_lern_app/src/features/authentication/presentation/splash_gradient_animation.dart';
// import 'package:scaled_app/scaled_app.dart';

void main() async {
  // ScaledWidgetsFlutterBinding.ensureInitialized(
  //   scaleFactor: (deviceSize) {
  //     const double widthOfDesign = 393;
  //     return deviceSize.width / widthOfDesign;
  //   },
  // );

  WidgetsFlutterBinding.ensureInitialized();

  try {
    await initializeApp();
  } catch (e) {
    debugPrint('Error during app initialization: $e');
    return;
  }

  runApp(const PurusMain());
}

class PurusMain extends StatelessWidget {
  const PurusMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      home: const SplashGradientAnimation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
