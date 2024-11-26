import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purus_lern_app/src/config/palette.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/log_errors.dart';
import 'package:purus_lern_app/src/features/authentication/application/moodle/request_password_reset_code.dart';
import 'package:purus_lern_app/src/features/authentication/data/reset_password_temp_account_name.dart';
import 'package:purus_lern_app/src/widgets/my_button.dart';
import 'package:purus_lern_app/src/widgets/my_snack_bar.dart';
import 'package:purus_lern_app/src/widgets/my_textfield.dart';

class ForgotPasswordPlace extends StatefulWidget {
  const ForgotPasswordPlace({
    super.key,
    required this.transitionToRoute,
  });

  final void Function(String route) transitionToRoute;

  @override
  State<ForgotPasswordPlace> createState() => _ForgotPasswordPlaceState();
}

class _ForgotPasswordPlaceState extends State<ForgotPasswordPlace> {
  final FocusNode _usernameNode = FocusNode();

  // final _formKey = GlobalKey<FormState>();
  final TextEditingController _resetPasswordController =
      TextEditingController();

  final double _columnSpacing = 25;

  bool _isUsernameValid = false;

  String _alertText =
      "Benutzernamen oder E-Mail Adresse eingeben, um ihr Passwort zurückzusetzen.";
  Color _alertTextColor = Colors.white;
  Color _myTextfieldResetPasswordStrokeColor = purusGrey;

  void _validation() {
    // requestPasswordResetCode(_resetPasswordController.text);
    requestActivationCode(_resetPasswordController.text);

    if (_resetPasswordController.text == "admin") {
      _isUsernameValid = true;
    }

    _alertTextAndTextfieldStrokeUpdate();

    if (_isUsernameValid) {
      resetPasswordTempAccountName = _resetPasswordController.text;

      // logLogin(
      //     _resetPasswordController.text.contains("@") ? "email" : "username", false);
      mySnackbar(context,
          "Passwort erfolgreich Zurückgesetzt. Kontrollieren Sie Ihre E-Mail's.");
      widget.transitionToRoute("ResetPassword");
    }
    // if (_formKey.currentState!.validate()) {
    // } else {
    // }
  }

  void _alertTextAndTextfieldStrokeUpdate() {
    if (_resetPasswordController.text.isEmpty) {
      setState(() {
        _alertText = "Fehlende Eingabe";
        _alertTextColor = purusRed;
        _myTextfieldResetPasswordStrokeColor = purusRed;
      });
      logErrors(_alertText);
    } else {
      if (!_isUsernameValid) {
        setState(() {
          _alertText = "Benutzername oder E-Mail nicht gefunden.";
          _alertTextColor = purusRed;
          _myTextfieldResetPasswordStrokeColor = purusRed;
        });
        logErrors(_alertText);
      } else {
        setState(() {
          _alertText = "Passwort erfolgreich Zurückgesetzt.";
          _alertTextColor = Colors.white;
          _myTextfieldResetPasswordStrokeColor = purusGrey;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameNode.dispose();
    _resetPasswordController.dispose();
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
                const SizedBox(
                  height: 60,
                ),
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
                  height: 100,
                ),
                MyTextfield(
                  controller: _resetPasswordController,
                  hintText: "Benutzername oder E-Mail",
                  focusNode: _usernameNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  strokeColor: _myTextfieldResetPasswordStrokeColor,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  // icon: const Icon(Icons.email, color: purusGreen),
                  onSubmitted: (p0) {
                    _validation();
                  },
                ),
                SizedBox(
                  height: _columnSpacing,
                ),
                MyButton(
                  fontSize: 19,
                  onTap: () {
                    _validation();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  text: "Passwort Zurücksetzen",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 80,
                      child: Center(
                        child: Text(
                          "Haben Sie keinen Account? Hier zur ",
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
                        widget.transitionToRoute('Registration');
                      },
                      child: const SizedBox(
                        height: 80,
                        child: Center(
                          child: Text(
                            "Registration",
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: Colors.white,
                    onPressed: () {
                      widget.transitionToRoute('Login');
                    },
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
