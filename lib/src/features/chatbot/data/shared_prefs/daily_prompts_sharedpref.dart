import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyPromptsSharedPrefs {
  static const String _dailyPromptsKey = 'daily_prompts';
  static const int _defaultDailyPrompts = 50;
  static const String _lastResetKey = 'last_reset';

  Future<int> getDailyPrompts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_dailyPromptsKey) ?? _defaultDailyPrompts;
  }

  Future<void> decrementDailyPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    int currentPrompts = await getDailyPrompts();

    await prefs.setInt(_dailyPromptsKey, currentPrompts - 1);
  }

  Future<void> resetDailyPrompts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyPromptsKey, _defaultDailyPrompts);
  }

  Future<void> checkAndResetDailyPrompts() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString(_lastResetKey);
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');

    if (lastReset == null || formatter.format(now) != lastReset) {
      await resetDailyPrompts();
      await prefs.setString(_lastResetKey, formatter.format(now));
    }
  }
}
