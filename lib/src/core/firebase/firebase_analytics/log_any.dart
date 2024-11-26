import 'package:purus_lern_app/src/data/app_info.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/analytics_instance.dart';

Future<void> logAny(String description, String text) async {
  if (currentPlatform != "Windows" && currentPlatform != "Unknown") {
    await analytics.logEvent(
      name: "log_any",
      parameters: {
        description: text,
      },
    );
  }
}
