import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:purus_lern_app/src/config/gradients.dart';
import 'package:purus_lern_app/src/config/palette.dart';
import 'package:purus_lern_app/src/core/random_string.dart';
import 'package:purus_lern_app/src/features/authentication/data/current_user.dart';
import 'package:purus_lern_app/src/features/chatbot/application/chatbot_service.dart';
import 'package:purus_lern_app/src/features/chatbot/data/chatbot_user_firestore_messages.dart';
import 'package:purus_lern_app/src/features/chatbot/data/shared_prefs/daily_prompts_sharedpref.dart';
import 'package:purus_lern_app/src/features/chatbot/presentation/daily_prompt_widget.dart';
import 'package:purus_lern_app/src/widgets/my_blur_gradient.dart';
// import 'package:purus_lern_app/src/widgets/my_cupertino_dialog.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key, required this.firstRequest});
  final String firstRequest;

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<types.Message> _messages = [];
  final _user = types.User(id: currentUser!.id);
  final _bot = const types.User(id: "Purutus", firstName: "Purutus");
  final _admin = const types.User(id: "Admin", role: types.Role.admin);

  final ChatbotService _chatbotService = ChatbotService();
  final ChatbotUserFirestoreMessages _firestoreService =
      ChatbotUserFirestoreMessages();
  String? _currentChatId;

  bool _isWaitingResponse = false;

  @override
  void initState() {
    super.initState();

    _initializeChatSession();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isWaitingResponse = true;
      });
    });
    Future.delayed(Duration(seconds: 2), () {
      if (!mounted) return;
      _promptValidation(context, false,
          "Begrüße den Nutzer lustig und motivierend, nehme Bezug auf deinen vorigem Sprachbubble: ${widget.firstRequest}");
    });
  }

  Future<void> _promptValidation(
      BuildContext context, bool decrement, String message) async {
    final prompts = await DailyPromptsSharedPrefs().getDailyPrompts();

    if (prompts > 0) {
      if (!mounted) return;
      _sendMessage(context, message);
      if (decrement) {
        await DailyPromptsSharedPrefs().decrementDailyPrompt();
      }
    } else {
      final noPromptsMessage = types.TextMessage(
        author: _admin,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        // type: types.MessageType.system,
        id: randomString(),
        text:
            "Entschuldige bitte, ${currentUser!.firstname}. Dein Prompt-Guthaben ist aufgebraucht. Es wird heute Nacht um 00:00 Uhr automatisch zurückgesetzt. Melde dich gerne bei der Purus Medical Akademie. Vielen Dank für dein Verständnis, ich bin morgen wieder für dich da! 😊",
      );
      _addMessage(noPromptsMessage);

      // await _sendMessage(
      //   context,
      //   "Ich bin der Entwickler, der User hat keine prompt guthaben meht übrig. 00:00 Uhr reset. Erkläre kurz und bitte ihm um entschuldigung, ohne mir eine Antwort zu geben.",
      // );
    }
  }

  Future<void> _sendMessage(BuildContext context, String userMessage) async {
    if (!mounted) return;
    final botResponse = types.TextMessage(
      author: _bot,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: await _chatbotService.getResponse(context, mounted, userMessage),
    );

    if (!mounted) return;
    _addMessage(botResponse);
  }

  void _addMessage(types.Message message) {
    if (!mounted) return;
    setState(() {
      _messages.insert(0, message);
      _isWaitingResponse = false;
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );
    if (message.text.length > 100) {
      _addMessage(textMessage);
      final tooLongMessage = types.TextMessage(
        author: _admin,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        // type: types.MessageType.system,
        text:
            "Deine Nachricht ist zu Lang, versuche unter 100 Zeichen zu bleiben.",
      );
      _addMessage(tooLongMessage);
    } else {
      _addMessage(textMessage);
      await _promptValidation(context, true, message.text);
    }
  }

  Future<void> _initializeChatSession() async {
    _currentChatId = await _firestoreService.createChatSession(currentUser!.id);
  }

  Future<void> _finalizeChat() async {
    String theme;
    try {
      theme = await _chatbotService.getResponse(context, mounted,
          "Fasse das Thema des Chats in einem Satz zusammen. Wenn nicht gebe 'Unbekanntes Thema' zurück.");
    } catch (e) {
      theme = 'Unbekanntes Thema';
    }
    if (_currentChatId != null) {
      await _firestoreService.updateChatTheme(_currentChatId!, theme);
    }
  }

  Future<void> _saveChatSession() async {
    try {
      _finalizeChat();

      for (var message in _messages) {
        await _firestoreService.saveMessage(
            chatId: _currentChatId!, message: message);
      }
    } catch (e) {
      debugPrint("Fehler beim Speichern des Chats: $e");
    }
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();

    if (_messages.length >= 2) {
      _saveChatSession();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return Container(
      decoration: MyBackgroundGradient().myBackgroundGradient(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Chat(
                l10n: ChatL10nDe(
                    inputPlaceholder: "Schreibe eine Nachricht an Purutus...",
                    isTyping: "Purutus antwortet..."),
                emptyState: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isWaitingResponse
                        ? SizedBox(
                            height: 120,
                            child: LottieBuilder.asset(
                                "assets/animations/typing.json"))
                        : LottieBuilder.asset(
                            "assets/animations/no_messages.json"),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      _isWaitingResponse
                          ? "Purutus schreibt dir gerade..."
                          : "Keine Nachrichten im Chat",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                theme: DefaultChatTheme(
                  // typingIndicatorTheme: TypingIndicatorTheme(animatedCirclesColor: animatedCirclesColor, animatedCircleSize: animatedCircleSize, bubbleBorder: bubbleBorder, bubbleColor: bubbleColor, countAvatarColor: countAvatarColor, countTextColor: countTextColor, multipleUserTextStyle: multipleUserTextStyle),
                  backgroundColor: Colors.transparent,
                  errorColor: purusRed,
                  primaryColor: purusGreen,
                  secondaryColor: Colors.white,
                  dateDividerMargin: EdgeInsets.all(20),
                  messageBorderRadius: 27,
                  // systemMessageTheme: SystemMessageTheme(
                  //   margin: EdgeInsets.all(10),
                  //   textStyle: TextStyle(color: purusRed),
                  // ),
                  sentMessageBodyTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                  receivedMessageBodyTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                  dateDividerTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  inputTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  inputBackgroundColor: purusGreen,
                  inputBorderRadius: BorderRadius.circular(27),
                  inputTextColor: Colors.white,
                  inputPadding: EdgeInsets.only(top: 15, bottom: 20),
                  inputTextCursorColor: Colors.white,
                  inputContainerDecoration: ShapeDecoration(
                    gradient: keyboardVisible ? null : bottomBarGradient,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(27),
                        topLeft: Radius.circular(27),
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color.fromARGB(47, 0, 0, 0),
                        blurRadius: 15,
                        offset: Offset(0, -2),
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
                // dateHeaderThreshold: 30000,
                messages: _messages,
                onSendPressed: _handleSendPressed,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                user: _user,
                textMessageOptions: TextMessageOptions(isTextSelectable: true),
                listBottomWidget: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: DailyPromptWidget()),
                ),
                typingIndicatorOptions: TypingIndicatorOptions(
                  typingUsers: _isWaitingResponse ? [_bot] : [],
                  typingMode: TypingIndicatorMode.name,
                  customTypingIndicator: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 70,
                          child: LottieBuilder.asset(
                              "assets/animations/typing.json"),
                        ),
                        Text(
                          "Purutus antwortet...",
                          style: TextStyle(
                              color: purusLightGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: MyBlurGradient(
                startColor: Colors.transparent,
                height: 180,
                width: MediaQuery.of(context).size.width,
                blurTotal: 3,
              ),
            ),
            Positioned(
              top: 85,
              left: 5,
              height: 40,
              width: 40,
              child: IconButton(
                highlightColor: purusLightGreen,
                onPressed: () async {
                  // if (_messages.length >= 2 && _currentChatId != null) {
                  //   _saveChatSession();
                  // }

                  // if (_messages.length >= 2) {
                  //   await _firestoreService.createChatSession(currentUser!.id);
                  //   await _firestoreService.updateChatTheme(
                  //       _currentChatId!, theme);
                  Navigator.of(context).pop();
                  // } else {
                  //   Navigator.of(context).pop();
                  // }
                  // myCupertinoDialog(
                  //     context,
                  //     "Chatverlauf Löschen?",
                  //     "Der Chatverlauf wird gelöscht.",
                  //     null,
                  //     null,
                  //     "Abbrechen",
                  //     "Ja",
                  //     () {}, () {
                  //   Navigator.of(context).pop();
                  // }, null, null);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 23,
                  color: purusGreen,
                ),
              ),
            ),
            // Positioned(
            //     top: 80,
            //     left: 50,
            //     child: Text(
            //       "Purutus Chatbot",
            //       style: TextStyle(
            //           fontSize: 20,
            //           fontWeight: FontWeight.w700,
            //           color: Colors.black),
            //     )),
            Positioned(
              top: 50,
              right: 27,
              child: Lottie.asset(
                "assets/animations/chatbot.json",
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
            )
          ],
        ),
      ),
    );
  }
}



// chat hafizza
// firestore
// lööschen
// datum düzelt