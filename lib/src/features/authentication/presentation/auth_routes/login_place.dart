import "dart:async";
import "dart:ui";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_sficon/flutter_sficon.dart";
import "package:flutter_svg/svg.dart";
import "package:purus_lern_app/src/config/palette.dart";
import "package:purus_lern_app/src/core/firebase/firebase_analytics/log_errors.dart";
import "package:purus_lern_app/src/core/firebase/firebase_analytics/log_login.dart";
import "package:purus_lern_app/src/core/moodle/get_user_info_from_login.dart";
import "package:purus_lern_app/src/core/presentation/home_screen.dart";
import "package:purus_lern_app/src/features/authentication/application/local_auth/refresh_biometric_state.dart";
import "package:purus_lern_app/src/core/moodle/login_req.dart";
import "package:purus_lern_app/src/features/authentication/data/local_auth_assets.dart";
import "package:purus_lern_app/src/features/authentication/data/shared_pref/biometric_dont_ask_me_again_sharedpred.dart";
import "package:purus_lern_app/src/features/authentication/data/shared_pref/biometric_sharedpref.dart";
import "package:purus_lern_app/src/features/authentication/application/local_auth/check_biometric_availability.dart";
import "package:purus_lern_app/src/features/authentication/application/local_auth/local_auth_service.dart";
import "package:purus_lern_app/src/features/authentication/data/shared_pref/stay_logged_in_sharedpref.dart";
import "package:purus_lern_app/src/features/authentication/data/login_conditions.dart";
import "package:purus_lern_app/src/features/authentication/data/current_user.dart";
import "package:purus_lern_app/src/widgets/my_animated_checkmark.dart";
import "package:purus_lern_app/src/widgets/my_button.dart";
import "package:purus_lern_app/src/widgets/my_rotating_svg.dart";
import "package:purus_lern_app/src/widgets/my_snack_bar.dart";
import "package:purus_lern_app/src/widgets/my_textfield.dart";
// import "package:scaled_app/scaled_app.dart";

// angemeldet bleiben händeln
// direkt faceid alowment ayarla? apple? (beschreiben yap?)
// platformbedingt
// Bio ikiye böl: bir system compatible(testen et biriyle?) + erlaubt
// faceid ve angemeldet bleiben olursa firebase auth kalici olsun: anmeldedaten in sharedpref fln!
// facid nutzen yapinca angemeldet bleiben olmasin?/faceid sadece angemeldet bleiben yerine gecsin???
// log ekle + handgi platofrm ve facid fln?

class LoginPlace extends StatefulWidget {
  const LoginPlace({super.key, required this.transitionToRoute});
  final void Function(String route) transitionToRoute;

  @override
  State<LoginPlace> createState() => _LoginPlaceState();
}

class _LoginPlaceState extends State<LoginPlace> with TickerProviderStateMixin {
  final double _columnSpacing = 20;

  final FocusNode _usernameNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();

  // final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;

  bool _stayLoggedBox = false;

  bool _isUsernameValid = false;
  bool _isPasswordCorrect = false;

  String _alertText = "Bitte melden Sie sich an.";
  Color _alertTextColor = Colors.white;
  Color _myTextfieldUsernameStrokeColor = purusGrey;
  Color _myTextfieldPassswordStrokeColor = purusGrey;

  late AnimationController _routeAnimationController;
  late Animation<double> _fadeAnimation;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _showSecondAnimation = false;

  final LocalAuthService _localAuthService = LocalAuthService();
  bool _isAuthenticating = false;
  bool _isConfigBiometricDone = false;
  bool _dontAskMeAgain = false;

  Timer? _updateAvailableBioStringTimer;

  @override
  void initState() {
    super.initState();
    _updateAvailableBioStringTimer =
        Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _refreshBiometricState();
    });

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

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _showSecondAnimation = true;
      });
    });
  }

  // IconData _showHideIcon() {
  //   return _obscureText ? SFIcons.sf_eye_fill : SFIcons.sf_eye_slash_fill;
  // }

  void _validation() async {
    loginReq(_usernameController.text, _passwordController.text);

    if (_usernameController.text == "arifayduran") {
      _isUsernameValid = true;
      if (_passwordController.text == "Novum#125me") {
        _isPasswordCorrect = true;
      }
    }

    _alertTextAndTextfieldStrokeUpdate();

    if (_isUsernameValid && _isPasswordCorrect) {
      logLogin(_usernameController.text.contains("@") ? "email" : "username",
          _stayLoggedBox);

      TextInput.finishAutofillContext();

      currentUser = await getUserinfoFromLogin(_usernameController.text);

      if (_stayLoggedBox) {
        isLoggedIn = true;
        StayLoggedInSharedpref().setLoginStatus(_stayLoggedBox, currentUser!);
      }

      if (isBiometricAvailable.value &&
          !isBiometricConfigured &&
          !_isConfigBiometricDone &&
          !biometricAskedBeforeAndNo) {
        _askConfigBiometricAfterLogin();
      } else if (isBiometricAvailable.value && _isConfigBiometricDone) {
        updateBiometrics(true);
        _routeToHomeScreen();
      } else {
        _routeToHomeScreen();
      }
    }
    // if (_formKey.currentState!.validate()) {
    // } else {
    // }
  }

  void _alertTextAndTextfieldStrokeUpdate() {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _alertText = "Fehlende Eingaben";
        _alertTextColor = purusRed;
        if (_usernameController.text.isEmpty) {
          _myTextfieldUsernameStrokeColor = purusRed;
        } else {
          _myTextfieldUsernameStrokeColor = purusGrey;
        }
        if (_passwordController.text.isEmpty) {
          _myTextfieldPassswordStrokeColor = purusRed;
        } else {
          _myTextfieldPassswordStrokeColor = purusGrey;
        }
      });
      logErrors(_alertText);
    } else {
      if (!_isUsernameValid) {
        setState(() {
          _alertText = "Benutzername oder E-Mail nicht gefunden.";
          _alertTextColor = purusRed;
          _myTextfieldUsernameStrokeColor = purusRed;
          _myTextfieldPassswordStrokeColor = purusGrey;
        });
        logErrors(_alertText);
      } else if (_isUsernameValid && !_isPasswordCorrect) {
        setState(() {
          _alertText =
              "Falsches Passwort. Probieren Sie es erneut, oder setzen Sie Ihr Passwort zurück.";
          _alertTextColor = purusRed;
          _myTextfieldUsernameStrokeColor = purusGrey;
          _myTextfieldPassswordStrokeColor = purusRed;
        });
        logErrors(_alertText);
      } else if (_isUsernameValid && _isPasswordCorrect) {
        setState(() {
          _alertText = "Erfolgreich Angemeldet.";
          _alertTextColor = Colors.white;
          _myTextfieldUsernameStrokeColor = purusGrey;
          _myTextfieldPassswordStrokeColor = purusGrey;
        });
      }
    }
  }

  void _askConfigBiometricAfterLogin() {
    setState(() {
      _isAuthenticating = true;
    });
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return CupertinoAlertDialog(
              title: const Text("Erfolgreich Angemeldet"),
              content: Column(
                children: [
                  const Text(
                    "Möchten Sie biometrisches Anmeldeverfahren einrichten?",
                  ),
                  const SizedBox(height: 10),
                  Material(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: purusGreen,
                          value: _dontAskMeAgain,
                          onChanged: (bool? value) {
                            setDialogState(() {
                              _dontAskMeAgain = value ?? false;
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              _dontAskMeAgain = !_dontAskMeAgain;
                            });
                          },
                          child: const Text(
                            "Nicht erneut fragen",
                            style:
                                TextStyle(fontFamily: "SF Pro", fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    setState(() {
                      _isAuthenticating = false;
                    });
                    Navigator.pop(context);
                    _routeToHomeScreen();
                    updateBiometrics(false);

                    if (_dontAskMeAgain) {
                      BiometricDontAskMeAgainSharedpref()
                          .setDontAskAgainPreference(true);
                    }

                    if (mounted) {
                      mySnackbar(context,
                          "Sie können biometrisches Anmeldeverfahren jederzeit in den Einstellungen einrichten.");
                    }
                  },
                  child: const Text(
                    "Nein",
                    style: TextStyle(color: CupertinoColors.destructiveRed),
                  ),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                    _checkBiometricsAfterLogin();

                    if (_dontAskMeAgain) {
                      BiometricDontAskMeAgainSharedpref()
                          .setDontAskAgainPreference(true);
                    }
                  },
                  child: const Text(
                    "Ja",
                    style: TextStyle(color: CupertinoColors.activeBlue),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _checkBiometricsAfterLogin() async {
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
        updateBiometrics(true);
        if (mounted) {
          mySnackbar(context,
              "Biometrisches Anmeldeverfahren erfolgreich eingerichtet.");
        }
      } else {
        _routeToHomeScreen();
        updateBiometrics(false);
        await checkBiometricAvailability();
        if (!isBiometricAvailable.value) {
          setState(() {});
          if (mounted) {
            mySnackbar(context,
                "Erlaubnis für biometrisches Anmeldeverfahren fehlt. Sie können es jederzeit nach Erlaubniserteilung in den Einstellungen einrichten.");
          } else {
            if (mounted) {
              mySnackbar(context,
                  "Fehler bei der Einrichtung. Sie können es jederzeit in den Einstellungen einrichten.");
            }
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        mySnackbar(context,
            "Fehler bei der Einrichtung. Sie können es jederzeit in den Einstellungen einrichten.");
      }
    }
  }

  void _askConfigBiometric(
    BuildContext context,
  ) {
    setState(() {
      _isAuthenticating = true;
    });
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: const Text(
              "Möchten Sie biometrisches Anmeldeverfahren einrichten?"),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                setState(() {
                  _isAuthenticating = false;
                  _isConfigBiometricDone = false;
                });
                Navigator.pop(context);
                if (mounted) {
                  mySnackbar(context,
                      "Sie können biometrisches Anmeldeverfahren jederzeit in den Einstellungen einrichten.");
                }
              },
              child: const Text(
                "Nein",
                style: TextStyle(color: CupertinoColors.destructiveRed),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                _checkBiometricsToConfig();
              },
              child: const Text(
                "Ja",
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkBiometricsToConfig() async {
    try {
      setState(() {
        _isAuthenticating = true;
      });

      bool authenticated = await _localAuthService.authenticateUser();

      setState(() {
        _isAuthenticating = false;
        _isConfigBiometricDone = authenticated;
      });

      if (authenticated) {
        if (mounted) {
          mySnackbar(
            context,
            "Nach erfolgreicher Anmeldung ist das Biometrische Anmeldeverfahren automatisch eingerichtet.",
          );
        }
      } else {
        await checkBiometricAvailability();

        if (!isBiometricAvailable.value && mounted) {
          mySnackbar(
            context,
            "Erlaubnis für biometrisches Anmeldeverfahren fehlt. Sie können es jederzeit nach Erlaubniserteilung in den Einstellungen einrichten.",
          );
        } else if (mounted) {
          mySnackbar(
            context,
            "Fehler bei der Einrichtung. Sie können es jederzeit in den Einstellungen einrichten.",
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        mySnackbar(context,
            "Fehler bei der Einrichtung. Sie können es jederzeit in den Einstellungen einrichten.");
      }
    }
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

  Future<void> _refreshBiometricState() async {
    await refreshBiometricState(context, false, false);
    if (availableBiometricsString == "Biometrics sind nicht aktiv") {
      _isConfigBiometricDone = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _usernameNode.dispose();
    _passwordNode.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    _routeAnimationController.dispose();
    _updateAvailableBioStringTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0.0;

    return SizedBox.expand(
      // child:
      //   MediaQuery(
      // data: MediaQuery.of(context).scale(),
      child: Center(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 393,
                child:
                    // Form(
                    //   key: _formKey,
                    //   child:
                    SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27.0),
                    child: AutofillGroup(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 45,
                            child: Center(
                              child: Text(
                                _alertText,
                                overflow: TextOverflow.fade,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _alertTextColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: _columnSpacing,
                          ),
                          SizedBox(
                            width: 393 - 27 - 27,
                            child: MyTextfield(
                              autofillHints: [
                                AutofillHints.username,
                                AutofillHints.email
                              ],
                              controller: _usernameController,
                              hintText: "Benutzername oder E-Mail",
                              focusNode: _usernameNode,
                              strokeColor: _myTextfieldUsernameStrokeColor,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              // icon: const Icon(Icons.email, color: purusGreen),
                              onSubmitted: (p0) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordNode);
                              },
                            ),
                          ),
                          SizedBox(
                            height: _columnSpacing,
                          ),
                          SizedBox(
                            width: 393 - 27 - 27,
                            child: MyTextfield(
                              autofillHints: [AutofillHints.password],
                              controller: _passwordController,
                              hintText: "Passwort",
                              focusNode: _passwordNode,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              obscureText: _obscureText,
                              strokeColor: _myTextfieldPassswordStrokeColor,
                              keyboardType: TextInputType.visiblePassword,
                              suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                    // _showHideIcon();
                                  });
                                },
                                // onTapDown: (_) {
                                //   setState(() {
                                //     _obscureText = false;
                                //   //  _showHideIcon();
                                //   });
                                // },
                                // onTapUp: (_) {
                                //   setState(() {
                                //     _obscureText = true;
                                //  //   _showHideIcon();
                                //   });
                                // },
                                child: SFIcon(
                                  _obscureText
                                      ? SFIcons.sf_eye_fill
                                      : SFIcons.sf_eye_slash_fill,
                                  color: purusGrey,
                                  fontSize: 16,
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                              // maxLength: 20,
                              onSubmitted: (p0) {
                                _validation();
                                // FocusManager.instance.primaryFocus?.unfocus();
                              },
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return "Please enter some text";
                              //   }
                              //   return "jkdejd";
                              // },
                            ),
                          ),
                          // SizedBox(
                          //   height: _columnSpacing,
                          // ),
                          Row(
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  setState(() {
                                    _stayLoggedBox = !_stayLoggedBox;
                                  });
                                },
                                child: SizedBox(
                                  height: 19 + _columnSpacing * 2,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      _stayLoggedBox
                                          ? const SFIcon(
                                              SFIcons.sf_checkmark_square_fill,
                                              color: Colors.white,
                                              fontSize: 19,
                                            )
                                          : const SFIcon(
                                              SFIcons.sf_square,
                                              color: Colors.white,
                                              fontSize: 19,
                                            ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      const Text(
                                        "Angemeldet bleiben",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  setState(() {
                                    widget.transitionToRoute("ForgotPassword");
                                  });
                                },
                                child: SizedBox(
                                  height: 19 + _columnSpacing * 2,
                                  child: Center(
                                    child: const Text(
                                      "Passwort vergessen?",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   height: _columnSpacing,
                          // ),
                          AnimatedOpacity(
                            opacity: _showSecondAnimation ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 500),
                            child: Column(
                              children: [
                                MyButton(
                                  onTap: () {
                                    _validation();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  text: "Anmelden",
                                ),
                                SizedBox(
                                  height: _columnSpacing,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          child: const Divider(
                                            color: Colors.white,
                                            thickness: 0.7,
                                          )),
                                    ),
                                    const Text("oder",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        )),
                                    Expanded(
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 20.0, right: 20),
                                          child: const Divider(
                                            color: Colors.white,
                                            thickness: 0.7,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: _columnSpacing,
                                ),
                                MyButton(
                                  onTap: () {
                                    widget.transitionToRoute("Registration");
                                  },
                                  text: "Registrieren",
                                  bgColor: Colors.white,
                                  textColor: purusGreen,
                                  strokeColor: borderStrokeGrey,
                                ),
                                SizedBox(
                                  height: _columnSpacing,
                                ),
                                // if (!isKeyboardVisible)
                                ValueListenableBuilder<bool>(
                                  valueListenable: isBiometricAvailable,
                                  builder: (context, value, child) {
                                    if (value) {
                                      return GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          if (isBiometricConfigured) {
                                            _checkBiometrics();
                                          } else {
                                            _askConfigBiometric(context);
                                          }
                                        },
                                        child: SizedBox(
                                          height: 90,
                                          width: 150,
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Positioned(
                                                top: 0,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: SizedBox(
                                                    height: 50,
                                                    width: 150,
                                                    child: ScaleTransition(
                                                      scale: _scaleAnimation,
                                                      child: availableBiometricsString !=
                                                              "Biometrics sind nicht aktiv"
                                                          ? SvgPicture.asset(
                                                              localAuthAssets[
                                                                  availableBiometricsString]!,
                                                              color:
                                                                  Colors.white,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              height: 50,
                                                            )
                                                          : MyRotatingSvg(
                                                              assetPath:
                                                                  localAuthAssets[
                                                                      availableBiometricsString]!,
                                                              height: 50,
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              _isConfigBiometricDone
                                                  ? const Positioned(
                                                      top: -12,
                                                      right: 28,
                                                      child:
                                                          MyAnimatedCheckmark())
                                                  : const SizedBox(),
                                              Positioned(
                                                bottom: 10,
                                                left: 0,
                                                width: 150,
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    availableBiometricsString !=
                                                            "Biometrics sind nicht aktiv"
                                                        ? "${isBiometricConfigured ? "Mit " : ""}$availableBiometricsString ${isBiometricConfigured ? "Anmelden" : _isConfigBiometricDone ? "ist eingerichtet" : "einrichten"}"
                                                        : "Biometrics sind nicht aktiv",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return SizedBox(
                                        height: 50,
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
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
      ),
    );
    //     ),
    // );
  }
}
