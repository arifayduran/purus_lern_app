import "dart:convert";
import "package:flutter/cupertino.dart";
import "package:http/http.dart" as http;
import "package:purus_lern_app/src/core/firebase/firebase_analytics/log_errors.dart";
import "package:purus_lern_app/src/features/authentication/data/current_user.dart";
import "package:purus_lern_app/src/features/chatbot/application/openai_apikey.dart";
// import "package:purus_lern_app/src/widgets/my_snack_bar.dart";

// 300 * 50 * 30 * 30 = 13.500.000 tokens = 20,25 USD

class ChatbotService {
  final String _apiUrl = "https://api.openai.com/v1/chat/completions";

  List<Map<String, String>> messageHistory = [
    {
      "role": "system",
      "content":
          "Du Heisst Purutus. Du bist ein Pflegehelfer-Lern-Chatbot von Purus Medical Academy GmbH in Berlin. Beantworte Fragen nur im Zusammenhang mit Pflegehelfer-Lern-Themen, wie z.B. Patientenpflege, Notfallmaßnahmen und Pflegemanagement. Du kannst nur Deutsch. Sei Nett und gerne aus Lustig. Der Nutzer heisst ${currentUser!.firstname}. Max 300 Tokens pro promt."
    }
  ];

  Future<String> getResponse(
      BuildContext context, bool isMounted, String userMessage) async {
    try {
      messageHistory.add({"role": "user", "content": userMessage});

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $openaiApikey",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messageHistory,
          "max_tokens": 300,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final botResponse = data["choices"][0]["message"]["content"].toString();

        messageHistory.add({"role": "assistant", "content": botResponse});

        return botResponse;
      } else {
        // if (isMounted) {
        //   // ignore: use_build_context_synchronously
        //   mySnackbar(context,
        //       "Status Code: ${response.statusCode}, Fehler beim Laden der Antwort: ${response.body}");
        // }
        return "Status Code: ${response.statusCode}, Fehler beim Laden der Antwort: ${response.body}";
      }
    } catch (e) {
      logErrors(e.toString());
      debugPrint("-------------");
      debugPrint("Catch Error: ${e.toString()}");
      debugPrint("-------------");
      // if (isMounted) {
      //   // ignore: use_build_context_synchronously
      //   mySnackbar(context, "Fehler bei der Verbindung zum Server: ${e.toString()}");
      // }
      return "Fehler bei der Verbindung zum Server: ${e.toString()}";
    }
  }
}
