import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:purus_lern_app/src/core/moodle/moodle_config.dart";
import "package:purus_lern_app/src/core/moodle/moodle_tokens.dart";

Future<void> requestActivationCode(String identifier) async {
  final response = await http.post(
    Uri.parse('$moodleUrl/webservice/custom_generate_code.php'),
    body: {
      'identifier': identifier,
    },
  );

  if (response.statusCode >= 200 && response.statusCode < 300) {
    debugPrint('Aktivierungscode erfolgreich gesendet.');
  } else {
    debugPrint('Fehler beim Senden des Codes: ${response.body}');
    debugPrint("Fehler beim Senden des Codes  ${response.statusCode}");
  }
}

Future<void> resetPasswordWithCode(
    String identifier, String code, String newPassword) async {
  final response = await http.post(
    Uri.parse('$moodleUrl/webservice/custom_reset_password.php'),
    body: {
      'identifier': identifier,
      'code': code,
      'newPassword': newPassword,
    },
  );

  if (response.statusCode >= 200 && response.statusCode < 300) {
    debugPrint('Passwort erfolgreich zurückgesetzt.');
  } else {
    debugPrint('Fehler beim Zurücksetzen des Passworts: ${response.body}');
  }
}

Future<void> requestPasswordResetCode(String emailOrUsername) async {
  try {
    final response = await http.post(
      Uri.parse('$moodleUrl/webservice/rest/server.php'),
      body: {
        'wstoken': puruslernappToken, // Webservice-Token
        'wsfunction':
            'core_auth_request_password_reset', // Passwort-Zurücksetzungsfunktion
        'moodlewsrestformat': 'json', // Antwort im JSON-Format
        'username': emailOrUsername, // E-Mail des Nutzers
      },
    );

    // final response = await http.post(
    //   Uri.parse("$moodleUrl/webservice/rest/server.php"),
    //   body: {
    //     "emailOrUsername": emailOrUsername,
    //   },
    // );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint("Bestätigungscode gesendet ${response.statusCode}");
      debugPrint('Server Antwort: ${response.body}');
    } else {
      debugPrint("Fehler beim Senden des Codes  ${response.statusCode}");
      debugPrint('Server Antwort: ${response.body}');
    }
  } catch (e) {
    debugPrint('Exception: $e');
  }
}
