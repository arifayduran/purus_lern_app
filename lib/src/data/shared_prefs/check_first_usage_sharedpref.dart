import 'package:shared_preferences/shared_preferences.dart';

Future<bool> checkFirstUsageSharedpref() async {
  final prefs = await SharedPreferences.getInstance();

  final isFirstUsage = prefs.getBool('isFirstUsage') ?? true;

  if (isFirstUsage) {
    await prefs.setBool('isFirstUsage', false);
  }

  return isFirstUsage;
}
