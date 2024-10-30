import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/log_errors.dart';
import 'package:purus_lern_app/src/core/moodle/moodle_config.dart';
import 'dart:convert';
import 'package:purus_lern_app/src/core/moodle/moodle_tokens.dart';
import 'package:purus_lern_app/src/features/authentication/domain/user.dart';

String _endpoint = "/webservice/rest/server.php";

Future<User?> refreshUserinfoFromId(String userId) async {
  try {
    final response = await http.get(
      Uri.parse(
        '$moodleUrl$_endpoint?wsfunction=core_user_get_users&moodlewsrestformat=json&wstoken=$puruslernappToken&criteria[0][key]=id&criteria[0][value]=$userId',
      ),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);

      if (data != null &&
          data.containsKey('users') &&
          data['users'] != null &&
          data['users'].isNotEmpty) {
        final user = data['users'][0];
        // debugPrint('Statuscode: ${response.statusCode}');
        debugPrint(
            '------------- Refreshed Userid: ${user["id"]}, Username: ${user["username"]}, firstname: ${user["firstname"]}, lastname: ${user["lastname"]}, Email: ${user["email"]}');
        return User.fromJson(
          user,
        );
      } else {
        debugPrint("-------------");
        debugPrint('Statuscode: ${response.statusCode}');
        debugPrint('Antwort: ${response.body}');
        debugPrint('Nutzer nicht gefunden.');
        debugPrint("-------------");
        logErrors(response.statusCode.toString() + response.body);
        return null;
      }
    } else {
      debugPrint("-------------");
      debugPrint('Fehler beim Abrufen der Daten: ${response.statusCode}');
      debugPrint('Antwort: ${response.body}');
      debugPrint("-------------");
      logErrors(response.statusCode.toString() + response.body);
    }
    return null;
  } catch (e) {
    debugPrint("-------------");
    debugPrint('Catch Error: Fehler beim Abrufen der Daten: ${e.toString()}');
    debugPrint("-------------");
    logErrors(e.toString());
    return null;
  }
}
