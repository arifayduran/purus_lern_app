import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:purus_lern_app/src/config/palette.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/log_errors.dart';
import 'package:purus_lern_app/src/features/authentication/data/reset_password_temp_account_name.dart';
import 'package:purus_lern_app/src/widgets/my_button.dart';
import 'package:purus_lern_app/src/widgets/my_snack_bar.dart';
import 'package:purus_lern_app/src/widgets/my_textfield.dart';

class ResetPasswordPlace extends StatefulWidget {
  const ResetPasswordPlace({
    super.key,
    required this.transitionToRoute,
    // required this.usernameOrEmail
  });

  final void Function(String route) transitionToRoute;
  // final String usernameOrEmail;

  @override
  State<ResetPasswordPlace> createState() => _ResetPasswordPlaceState();
}

class _ResetPasswordPlaceState extends State<ResetPasswordPlace> {
  final FocusNode _resettedPasswordNode = FocusNode();
  final FocusNode _newPasswordNode = FocusNode();
  final FocusNode _newPasswordConfirmNode = FocusNode();

  bool _obscureTextOne = true;
  bool _obscureTextTwo = true;
  bool _obscureTextThree = true;

  // final _formKey = GlobalKey<FormState>();
  final TextEditingController _resettedPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmController =
      TextEditingController();

  bool _isResettedPasswordValid = false;
  bool _isNewPasswordValid = false;

  String _alertText =
      "Bitte geben Sie ihr zurückgesetztes Passwort, dann das neue Passwort zwei mal ein.";
  Color _alertTextColor = Colors.white;
  Color _myTextfieldResettedPasswordStrokeColor = purusGrey;
  Color _myTextfieldNewPasswordStrokeColor = purusGrey;
  Color _myTextfieldNewPasswordConfirmStrokeColor = purusGrey;

  bool _showSecondAnimation = false;
  bool _showThirdAnimation = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _showSecondAnimation = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _showThirdAnimation = true;
      });
    });
  }

  void _validation() {
    if (resetPasswordTempAccountName == "admin" &&
        _resettedPasswordController.text == "admin") {
      _isResettedPasswordValid = true;
    }

    _alertTextAndTextfieldStrokeUpdate();

    if (_isNewPasswordValid) {
      resetPasswordTempAccountName = "";

      // Datenbank änderung

      mySnackbar(context,
          "Passwort erfolgreich geändert. Sie können sich jetzt einloggen.");
      widget.transitionToRoute('Login');
    }
    // if (_formKey.currentState!.validate()) {
    // } else {
    // }
  }

  void _alertTextAndTextfieldStrokeUpdate() {
    if (_resettedPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _newPasswordConfirmController.text.isEmpty) {
      setState(() {
        _alertText = "Fehlende Eingaben";
        _alertTextColor = purusRed;
        if (_resettedPasswordController.text.isEmpty) {
          _myTextfieldResettedPasswordStrokeColor = purusRed;
        } else {
          _myTextfieldResettedPasswordStrokeColor = purusGrey;
        }
        if (_newPasswordConfirmController.text.isEmpty) {
          _myTextfieldNewPasswordStrokeColor = purusRed;
        } else {
          _myTextfieldNewPasswordStrokeColor = purusGrey;
        }
        if (_newPasswordConfirmController.text.isEmpty) {
          _myTextfieldNewPasswordConfirmStrokeColor = purusRed;
        } else {
          _myTextfieldNewPasswordConfirmStrokeColor = purusGrey;
        }
      });
      logErrors(_alertText);
    } else {
      if (!_isResettedPasswordValid) {
        setState(() {
          _alertText = "Zurückgeseztes Passwort ist nicht korrekt.";
          _alertTextColor = purusRed;
          _myTextfieldResettedPasswordStrokeColor = purusRed;
        });
        logErrors(_alertText);
      } else {
        if (_newPasswordController.text.length < 8) {
          setState(() {
            _alertText = 'Das Passwort muss mindestens 8 Zeichen lang sein.';
            _alertTextColor = purusRed;
            _myTextfieldNewPasswordStrokeColor = purusRed;
          });
          logErrors(_alertText);
        } else if (!RegExp(r'(?=.*[A-Z])')
            .hasMatch(_newPasswordController.text)) {
          setState(() {
            _alertText =
                'Das Passwort muss mindestens einen Großbuchstaben enthalten.';
            _alertTextColor = purusRed;
            _myTextfieldNewPasswordStrokeColor = purusRed;
          });
          logErrors(_alertText);
        } else if (!RegExp(r'(?=.*\d)').hasMatch(_newPasswordController.text)) {
          setState(() {
            _alertText = 'Das Passwort muss mindestens eine Zahl enthalten.';
            _alertTextColor = purusRed;
            _myTextfieldNewPasswordStrokeColor = purusRed;
          });
          logErrors(_alertText);
        } else if (!RegExp(r'(?=.*[\W_])')
            .hasMatch(_newPasswordController.text)) {
          setState(() {
            _alertText =
                'Das Passwort muss mindestens ein Sonderzeichen enthalten.';
            _alertTextColor = purusRed;
            _myTextfieldNewPasswordStrokeColor = purusRed;
          });
          logErrors(_alertText);
        } else {
          if (_newPasswordController.text !=
              _newPasswordConfirmController.text) {
            setState(() {
              _alertText = "Passwort Bestätigung stimmt nicht überein.";
              _alertTextColor = purusRed;
              _myTextfieldNewPasswordConfirmStrokeColor = purusRed;
            });
            logErrors(_alertText);
          } else {
            setState(() {
              _isNewPasswordValid = true;
              _alertText = "Passwort erfolgreich geändert.";
              _alertTextColor = Colors.white;
              _myTextfieldResettedPasswordStrokeColor = purusGrey;
              _myTextfieldNewPasswordStrokeColor = purusGrey;
              _myTextfieldNewPasswordConfirmStrokeColor = purusGrey;
            });
          }
        }
      }
    }
  }

  // IconData _showHideIcon(bool obscureText) {
  //   return obscureText ? SFIcons.sf_eye_fill : SFIcons.sf_eye_slash_fill;
  // }

  @override
  void dispose() {
    _resettedPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmController.dispose();
    _resettedPasswordNode.dispose();
    _newPasswordConfirmNode.dispose();
    _newPasswordConfirmNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SizedBox(
        width: 340,
        // child:
        // Form(
        //   key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27.0),
            child: Column(
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
                const SizedBox(
                  height: 15,
                ),
                MyTextfield(
                  controller: _resettedPasswordController,
                  hintText: "Zurückgesetztes Passwort",
                  focusNode: _resettedPasswordNode,
                  obscureText: _obscureTextOne,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  strokeColor: _myTextfieldResettedPasswordStrokeColor,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
                  suffix: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureTextOne = !_obscureTextOne;
                        // _showHideIcon(_obscureTextOne);
                      });
                    },
                    // onTapDown: (_) {
                    //   setState(() {
                    //     _obscureTextOne = false;
                    //   //  _showHideIcon(_obscureTextOne);
                    //   });
                    // },
                    // onTapUp: (_) {
                    //   setState(() {
                    //     _obscureTextOne = true;
                    //   //  _showHideIcon(_obscureTextOne);
                    //   });
                    // },
                    child: SFIcon(
                      // _showHideIcon(_obscureTextOne),
                      _obscureTextOne
                          ? SFIcons.sf_eye_fill
                          : SFIcons.sf_eye_slash_fill,
                      color: purusGrey,
                      fontSize: 16,
                    ),
                  ),
                  onSubmitted: (p0) {
                    FocusScope.of(context).requestFocus(_newPasswordNode);
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                AnimatedOpacity(
                  opacity: _showSecondAnimation ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    children: [
                      const Text(
                        "(Das Neue Passwort muss mindestens 8 Zeichen,\neinen Großbuchstaben, ein Sonderzeichen und eine Zahl beinhalten!)",
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      MyTextfield(
                        controller: _newPasswordController,
                        hintText: "Neues Passwort",
                        focusNode: _newPasswordNode,
                        obscureText: _obscureTextTwo,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        strokeColor: _myTextfieldNewPasswordStrokeColor,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureTextTwo = !_obscureTextTwo;
                              //  _showHideIcon(_obscureTextTwo);
                            });
                          },
                          // onTapDown: (_) {
                          //   setState(() {
                          //     _obscureTextTwo = false;
                          //   //  _showHideIcon(_obscureTextTwo);
                          //   });
                          // },
                          // onTapUp: (_) {
                          //   setState(() {
                          //     _obscureTextTwo = true;
                          //   //  _showHideIcon(_obscureTextTwo);
                          //   });
                          // },
                          child: SFIcon(
                            // _showHideIcon(_obscureTextTwo),
                            _obscureTextTwo
                                ? SFIcons.sf_eye_fill
                                : SFIcons.sf_eye_slash_fill,
                            color: purusGrey,
                            fontSize: 16,
                          ),
                        ),
                        onSubmitted: (p0) {
                          FocusScope.of(context)
                              .requestFocus(_newPasswordConfirmNode);
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      MyTextfield(
                        controller: _newPasswordConfirmController,
                        hintText: "Neues Passwort Bestätigen",
                        focusNode: _newPasswordConfirmNode,
                        obscureText: _obscureTextThree,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        ],
                        strokeColor: _myTextfieldNewPasswordConfirmStrokeColor,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        suffix: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureTextThree = !_obscureTextThree;
                              //  _showHideIcon(_obscureTextThree);
                            });
                          },
                          // onTapDown: (_) {
                          //   setState(() {
                          //     _obscureTextThree = false;
                          //   //  _showHideIcon(_obscureTextThree);
                          //   });
                          // },
                          // onTapUp: (_) {
                          //   setState(() {
                          //     _obscureTextThree = true;
                          //    // _showHideIcon(_obscureTextThree);
                          //   });
                          // },
                          child: SFIcon(
                            // _showHideIcon(_obscureTextThree),
                            _obscureTextThree
                                ? SFIcons.sf_eye_fill
                                : SFIcons.sf_eye_slash_fill,
                            color: purusGrey,
                            fontSize: 16,
                          ),
                        ),
                        onSubmitted: (p0) {
                          _validation();
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: _showThirdAnimation ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    children: [
                      MyButton(
                        fontSize: 19,
                        onTap: () {
                          _validation();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        text: "Passwort Ändern",
                      ),
                      const SizedBox(
                        height: 10,
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
                      const SizedBox(
                        height: 10,
                      ),
                      MyButton(
                        onTap: () {
                          resetPasswordTempAccountName = "";
                          widget.transitionToRoute('Login');
                          mySnackbar(context,
                              "Sie können Ihr Passwort jederzeit unter den Einstellungen ändern");
                        },
                        text: "Später Ändern",
                        bgColor: Colors.white,
                        textColor: purusGreen,
                        strokeColor: borderStrokeGrey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 80,
                            child: Center(
                              child: Text(
                                "Keine E-Mail erhalten? ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              resetPasswordTempAccountName = "";
                              widget.transitionToRoute("ForgotPassword");
                            },
                            child: const SizedBox(
                              height: 80,
                              child: Center(
                                child: Text(
                                  "Hier erneut zurücksetzen.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }
}
