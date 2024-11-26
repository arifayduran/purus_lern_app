import 'package:purus_lern_app/src/data/app_info.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/analytics_instance.dart';

Future<void> logTriedSkippingSplash() async {
  if (currentPlatform != "Windows" && currentPlatform != "Unknown") {
    await analytics.logEvent(
      name: 'tried_skipping_splash',
      parameters: {
        'description': 'Splash tried to be skipped',
      },
    );
  }
}
