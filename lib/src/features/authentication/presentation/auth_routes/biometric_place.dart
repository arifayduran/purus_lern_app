import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:purus_lern_app/src/core/presentation/home_screen.dart';
import 'package:purus_lern_app/src/features/authentication/application/local_auth/local_auth_service.dart';
import 'package:purus_lern_app/src/config/local_auth_assets.dart';
import 'package:purus_lern_app/src/features/authentication/data/login_conditions.dart';
import 'package:purus_lern_app/src/widgets/my_snack_bar.dart';
import 'package:purus_lern_app/src/widgets/my_text_button.dart';

class BiometricPlace extends StatefulWidget {
  const BiometricPlace({super.key, required this.transitionToRoute});
  final void Function(String route) transitionToRoute;

  @override
  State<BiometricPlace> createState() => _BiometricPlaceState();
}

class _BiometricPlaceState extends State<BiometricPlace>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  late AnimationController _routeAnimationController;
  late Animation<double> _fadeAnimation;

  final LocalAuthService _localAuthService = LocalAuthService();
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();

    _checkBiometrics();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _routeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_routeAnimationController);
  }

  Future<void> _checkBiometrics() async {
    try {
      setState(() {
        _isAuthenticating = true;
      });
      bool authenticated = await _localAuthService.authenticateUser();
      setState(() {
        _isAuthenticating = false;
      });
      if (authenticated) {
        _routeToHomeScreen();
      } else {
        if (mounted) {
          mySnackbar(context, "Fehler beim biometrischen Anmeldeverfahren.");
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        mySnackbar(context, "Fehler beim biometrischen Anmeldeverfahren.");
      }
    }
  }

  void _routeToHomeScreen() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      _routeAnimationController.forward();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: const HomeScreen(),
            );
          },
          transitionDuration: const Duration(milliseconds: 1200),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    _checkBiometrics();
                  },
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: SizedBox(
                      height: 300,
                      child: SvgPicture.asset(
                        localAuthAssets[availableBiometricsString]!,
                        color: Colors.white,
                        alignment: Alignment.center,
                        height: 80,
                      ),
                    ),
                  ),
                ),
                MyTextButton(
                  text: "Zum klassischen Login",
                  onPressed: () {
                    widget.transitionToRoute("Login");
                  },
                ),
                SizedBox(
                  height: 0,
                ),
              ],
            ),
          ),
          if (_isAuthenticating)
            Positioned(
              top: 0,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
