import 'package:flutter/cupertino.dart';
import 'package:purus_lern_app/src/features/authentication/application/logout.dart';

class LogoutEmptyScreen extends StatelessWidget {
  const LogoutEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    logout(context);
    return const SizedBox();
  }
}
