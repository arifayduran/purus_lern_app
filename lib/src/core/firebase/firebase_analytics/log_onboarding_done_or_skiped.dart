import 'package:purus_lern_app/src/data/app_info.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/analytics_instance.dart';

Future<void> logOnboardingDone() async {
  if (currentPlatform != "Windows" && currentPlatform != "Unknown") {
    await analytics.logEvent(
      name: 'onboarding_done',
      parameters: {
        'description': 'Onboarding has been completed',
      },
    );
  }
}

Future<void> logOnboardingSkipped() async {
  if (currentPlatform != "Windows" && currentPlatform != "Unknown") {
    await analytics.logEvent(
      name: 'onboarding_skipped',
      parameters: {
        'description': 'Onboarding has been skipped',
      },
    );
  }
}
