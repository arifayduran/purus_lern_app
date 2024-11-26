import 'package:purus_lern_app/src/data/app_info.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/analytics_instance.dart';

Future<void> logErrors(String e) async {
  if (currentPlatform != "Windows" && currentPlatform != "Unknown") {
    await analytics.logEvent(
      name: 'error_occurred',
      parameters: {
        'error_message': e,
      },
    );
  }
}
