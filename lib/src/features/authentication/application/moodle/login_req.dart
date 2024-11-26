import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:purus_lern_app/src/core/firebase/firebase_analytics/log_any.dart";
import "package:purus_lern_app/src/core/firebase/firebase_analytics/log_errors.dart";
import "dart:convert";
import "package:purus_lern_app/src/core/moodle/moodle_config.dart";
import "package:purus_lern_app/src/features/authentication/data/current_user.dart";
import "package:purus_lern_app/src/widgets/my_snack_bar.dart";

const String _endpoint = "login/token.php";

Future<String> loginReq(BuildContext context, bool isMounted, String username,
    String password) async {
  try {
    final url = Uri.parse("$moodleUrl$_endpoint");

    final response = await http.post(
      url,
      body: {
        "username": username,
        "password": password,
        "service": "moodle_mobile_app",
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseData = json.decode(response.body);

      if (responseData.containsKey("token")) {
        final token = responseData["token"];
        debugPrint("-------------");
        debugPrint(
            "Login erfolgreich. Statuscode: ${response.statusCode}, Token: $token");
        debugPrint("-------------");
        userToken = token;
        logAny("user_login", "success");
        return "valid";
      } else {
        logErrors(response.statusCode.toString() + response.body);
        debugPrint("-------------");
        debugPrint(
            "Login fehlgeschlagen. Statuscode: ${response.statusCode}, Fehler: ${responseData["error"] ?? "Unbekannter Fehler"}, ${response.body}");
        debugPrint("-------------");
        return "invalid";
      }
    } else {
      logErrors(response.statusCode.toString() + response.body);
      debugPrint("-------------");
      debugPrint(
          "Fehler bei der Anfrage. Statuscode: ${response.statusCode}, Fehler: ${response.body}");
      debugPrint("-------------");
      if (isMounted) {
        // ignore: use_build_context_synchronously
        mySnackbar(context,
            "Fehler bei der Anfrage. Statuscode: ${response.statusCode}, Fehler: ${response.body}");
      }
      return "error";
    }
  } catch (e) {
    logErrors(e.toString());
    debugPrint("-------------");
    debugPrint("Catch Error: ${e.toString()}");
    debugPrint("-------------");
    if (isMounted) {
      // ignore: use_build_context_synchronously
      mySnackbar(context, "Fehler bei der Verbindung zum Server.");
    }
    return "error";
  }
}
