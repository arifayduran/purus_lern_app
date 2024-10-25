import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:purus_lern_app/src/core/firebase/firebase_analytics/log_errors.dart";
import "package:purus_lern_app/src/core/moodle/moodle_config.dart";
import "dart:convert";
import "package:purus_lern_app/src/core/moodle/moodle_tokens.dart";
import "dart:async";
import "package:purus_lern_app/src/features/authentication/data/current_user.dart";

String _endpoint = "/webservice/rest/server.php";

Future<int> getDailyPrompts() async {
  try {
    final response = await http.get(
      Uri.parse(
          "$moodleUrl$_endpoint?wsfunction=core_user_get_users&moodlewsrestformat=json&wstoken=$puruslernappToken&criteria[0][key]=username&criteria[0][value]=${currentUser!.username}"),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);

      return int.parse(data["users"][0]["customfields"][0]["value"] ?? "0");
    } else {
      debugPrint("Fehler beim Abrufen der Prompts: ${response.statusCode}");
      debugPrint("Antwort: ${response.body}");
      logErrors(response.statusCode.toString() + response.body);
      return 0;
    }
  } catch (e) {
    debugPrint("Fehler beim Abrufen der Prompts: ${e.toString()}");
    logErrors(e.toString());
    return 0;
  }
}

Future<void> decrementDailyPrompt() async {
  int currentPromt = await getDailyPrompts();
  try {
    final response = await http.post(
      Uri.parse(
          "$moodleUrl$_endpoint?wsfunction=core_user_update_users&moodlewsrestformat=json&wstoken=$puruslernappToken"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "users": [
          {
            "id": currentUser!.id,
            "customfields": [
              {
                "type": "text",
                "value": "${currentPromt - 1}",
                "name": "daily_prompts",
                "shortname": "daily_prompts"
              }
            ]
          }
        ]
      }),
    );
    currentPromt = await getDailyPrompts();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint(
          "Prompt -1, Aktuell: ${currentPromt}, ${response.statusCode} ");
    } else {
      debugPrint("Fehler beim Verringern des Prompts: ${response.statusCode}");
      debugPrint("Antwort: ${response.body}");
      logErrors(response.statusCode.toString() + response.body);
    }
  } catch (e) {
    debugPrint("Fehler beim Verringern des Prompts: ${e.toString()}");
    logErrors(e.toString());
  }
}


// -1 olamasin?
// habe es jetzt erfolgreich implementiert aber in der datenbank die value geändert, ui hat sich nicht verändert bevor ich neu laden habe. ausserdem möchte ich jetzt nach jedem promot -1 im system und im ui. bei 0 darf keine prompte mehr ausgeführt werden (snackbar!). 100 token pro promt.