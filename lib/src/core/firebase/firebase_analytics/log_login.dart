import 'package:purus_lern_app/src/data/app_info.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/analytics_instance.dart';

Future<void> logLogin(String loginMethod, bool isStayLogged) async {
  if (currentPlatform != "Windows" && currentPlatform != "Unknown") {
    await analytics.logLogin(
      loginMethod: loginMethod,
      parameters: {
        "isStayLogged": isStayLogged.toString(),
      },
    );
  }
}
