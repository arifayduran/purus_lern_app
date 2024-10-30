import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/log_any.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/log_errors.dart';
import 'package:purus_lern_app/src/core/moodle/moodle_config.dart';
import 'package:purus_lern_app/src/features/authentication/data/current_user.dart';
import 'package:purus_lern_app/src/widgets/my_snack_bar.dart';

Future<void> profileImageUploader(
  File imageFile,
  BuildContext context,
  bool isMounted,
) async {
  String uploadUrl = "${moodleUrl}webservice/upload.php";

  try {
    var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
    request.files
        .add(await http.MultipartFile.fromPath('file', imageFile.path));

    request.fields['token'] = userToken!;
    request.fields['userid'] = currentUser!.id;

    var responseUpload = await request.send();
    var responseUploadBody = await responseUpload.stream.bytesToString();

    if (responseUpload.statusCode >= 200 && responseUpload.statusCode < 300) {
      debugPrint("-------------");
      debugPrint(
          "Bild erfolgreich hochgeladen! Status Code: ${responseUpload.statusCode}, Body: $responseUpload");
      debugPrint("-------------");

      var draftItemId = extractDraftItemId(responseUploadBody);

      if (draftItemId != null) {
        String setPictureUrl = "${moodleUrl}webservice/rest/server.php";

        var responseUpdate = await http.post(
          Uri.parse(setPictureUrl),
          body: {
            'wstoken': userToken,
            'wsfunction': 'core_user_update_picture',
            'moodlewsrestformat': 'json',
            'userid': currentUser!.id,
            'draftitemid': draftItemId,
          },
        );

        if (responseUpdate.statusCode >= 200 &&
            responseUpdate.statusCode < 300) {
          debugPrint("-------------");
          debugPrint(
              "Profilbild erfolgreich aktualisiert! Status Code: ${responseUpdate.statusCode}, Body: ${responseUpdate.body}");
          debugPrint("-------------");
          if (isMounted) {
            // ignore: use_build_context_synchronously
            mySnackbar(context, "Profilbild erfolgreich aktualisiert!");
            logAny("updated_profile_image", "success");
          }
        } else {
          debugPrint("-------------");
          debugPrint(
              "Fehler beim Aktualisieren des Profilbildes. Status Code: ${responseUpdate.statusCode}, Body: ${responseUpdate.body}");
          debugPrint("-------------");
          logErrors(
              "Fehler beim Aktualisieren des Profilbildes. Status Code: ${responseUpdate.statusCode}, Body: ${responseUpdate.body}");
          if (isMounted) {
            // ignore: use_build_context_synchronously
            mySnackbar(context, "Fehler beim Aktualisieren des Profilbildes.");
          }
        }
      } else {
        debugPrint("-------------");
        debugPrint(
            "Fehler beim Hochladen des Bildes. Keine draftItemId gefunden. Status Code: ${responseUpload.statusCode}, Body: $responseUpload");
        debugPrint("-------------");
        logErrors(
            "Fehler beim Hochladen des Bildes. Keine draftItemId gefunden. Status Code: ${responseUpload.statusCode}, Body: $responseUpload");
        if (isMounted) {
          // ignore: use_build_context_synchronously
          mySnackbar(context, "Fehler beim Aktualisieren des Profilbildes.");
        }
      }
    } else {
      debugPrint("-------------");
      debugPrint(
          "Fehler beim Hochladen des Bildes. Status Code: ${responseUpload.statusCode}, Body: $responseUpload");
      debugPrint("-------------");
      logErrors(
          "Fehler beim Hochladen des Bildes. Status Code: ${responseUpload.statusCode}, Body: $responseUpload");
      if (isMounted) {
        // ignore: use_build_context_synchronously
        mySnackbar(context, "Fehler beim Aktualisieren des Profilbildes.");
      }
    }
  } catch (e) {
    logErrors(e.toString());
    debugPrint("-------------");
    debugPrint("Catch Error: ${e.toString()}");
    debugPrint("-------------");
    if (isMounted) {
      // ignore: use_build_context_synchronously
      mySnackbar(context, "Fehler beim Aktualisieren des Profilbildes.");
    }
  }
}

String? extractDraftItemId(String responseBody) {
  try {
    var jsonResponse = json.decode(responseBody);

    if (jsonResponse is List && jsonResponse.isNotEmpty) {
      return jsonResponse[0]['itemid'].toString();
    }
  } catch (e) {
    debugPrint("Fehler beim Parsen der Antwort: $e");
  }
  return null;
}
