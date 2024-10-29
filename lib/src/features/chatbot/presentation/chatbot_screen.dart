import 'package:flutter/material.dart';
import 'package:purus_lern_app/src/features/chatbot/application/chatbot_service.dart';
import 'package:purus_lern_app/src/features/chatbot/data/shared_prefs/daily_prompts_sharedpref.dart';
import 'package:purus_lern_app/src/features/chatbot/presentation/daily_prompt_widget.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key, required this.firstRequest});
  final String firstRequest;

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ChatbotService _chatbotService = ChatbotService();
  final TextEditingController _userMessageController = TextEditingController();
  String _response = '';

  @override
  void initState() {
    super.initState();
    _sendMessage(context,
        "Begrüße den Nutzer lustig und motivierend, nehme Bezug auf deinen vorigem Sprachbubble: ${widget.firstRequest}");
  }

  void _sendMessage(BuildContext context, String userMessage) async {
    String botResponse =
        await _chatbotService.getResponse(context, mounted, userMessage);
    setState(() {
      _response = botResponse;
    });
    _userMessageController.clear();
  }

  void _promptValidation(BuildContext context) async {
    int prompts = await DailyPromptsSharedPrefs().getDailyPrompts();
    if (prompts > 0 && mounted) {
      // ignore: use_build_context_synchronousl
      _sendMessage(context, _userMessageController.text);
      await DailyPromptsSharedPrefs().decrementDailyPrompt();
    } else if (prompts <= 0 && mounted) {
      // ignore: use_build_context_synchronously
      _sendMessage(context,
          "Ich bin der Entwickler, der User hat keine prompt guthaben meht übrig. 00:00 Uhr reset. Bitte ihm um entschuldigung.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purutus Chatbot'),
      ),
      body: Column(
        children: [
          DailyPromptWidget(),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Text(_response),
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _userMessageController,
                    decoration: InputDecoration(
                        labelText: 'Schreibe eine Nachricht an Purutus...'),
                    onSubmitted: (_) {
                      _promptValidation(context);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _promptValidation(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
