import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:purus_lern_app/src/config/gradients.dart';
import 'package:purus_lern_app/src/config/palette.dart';
import 'package:purus_lern_app/src/core/firebase/firebase_analytics/log_errors.dart';
import 'package:purus_lern_app/src/core/random_string.dart';
import 'package:purus_lern_app/src/features/authentication/data/current_user.dart';
import 'package:purus_lern_app/src/features/chatbot/application/chatbot_service.dart';
import 'package:purus_lern_app/src/features/chatbot/data/chatbot_user_firestore_chat_sessions.dart';
import 'package:purus_lern_app/src/features/chatbot/data/shared_prefs/daily_prompts_sharedpref.dart';
import 'package:purus_lern_app/src/features/chatbot/presentation/daily_prompt_widget.dart';
import 'package:purus_lern_app/src/widgets/my_blur_gradient.dart';
import 'package:purus_lern_app/src/widgets/my_snack_bar.dart';
// import 'package:purus_lern_app/src/widgets/my_cupertino_dialog.dart';


// SHARED KALDIK EN SON

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key, required this.firstRequest});
  final String firstRequest;

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  List<types.Message> _messages = [];
  List<types.Message> _saveMessages = [];
  final _user = types.User(id: currentUser!.id);
  final _bot = const types.User(id: "Purutus", firstName: "Purutus");
  final _admin = const types.User(id: "Admin", role: types.Role.admin);

  final ChatbotService _chatbotService = ChatbotService();
  final ChatbotUserFirestoreChatSessions _firestoreService =
      ChatbotUserFirestoreChatSessions();
  String? _currentChatId;

  bool _isWaitingResponse = false;
  bool _isSavingChat = false;

  @override
  void initState() {
    super.initState();

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
      // ignore: use_build_context_synchronously
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
      setState(() {
        _isWaitingResponse = false;
      });
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
    setState(() {
      _isWaitingResponse = false;
    });

    _addMessage(botResponse);
  }

  void _addMessage(types.Message message) {
    if (!mounted) return;
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    setState(() {
      _isWaitingResponse = true;
    });
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
      setState(() {
        _isWaitingResponse = false;
      });

      _addMessage(tooLongMessage);
    } else {
      _addMessage(textMessage);
      await _promptValidation(context, true, message.text);
    }
  }

  // Future<void> _initializeChatSession() async {
  //   try {
  //     _currentChatId =
  //         await _firestoreService.createChatSession(currentUser!.id);
  //   } catch (e) {
  //     logErrors(e.toString());
  //     debugPrint("Fehler bei der Chat ID vergabe: $e");
  //   }
  // }

  Future<void> _finalizeChat() async {
    String theme;
    try {
      theme = await _chatbotService.getResponse(context, mounted,
          "Fasse das Thema des Chats als Überschrift zusammen. Wenn nicht gebe 'Unbekanntes Thema' zurück.");
    } catch (e) {
      logErrors(e.toString());
      theme = "Unbekanntes Thema";
      debugPrint("Fehler bei der Themen vergabe: $e");
    }
    if (_currentChatId != null) {
      await _firestoreService.updateChatTheme(_currentChatId!, theme);
    }
  }

  Future<void> _saveChatSession() async {
    try {
      // await _initializeChatSession();
      await _finalizeChat();

      for (var message in _saveMessages) {
        await _firestoreService.saveMessage(
            userId: _currentChatId!, message: message);
      }
      if (mounted) {
        mySnackbar(context, "Der Chatverlauf wurde gespeichert.");
      }
    } catch (e) {
      logErrors(e.toString());
      debugPrint("Fehler beim Speichern des Chats: $e");
      if (!mounted) return;
      mySnackbar(context, "Der Chatverlauf konnte nicht gespeichert werden.");
    }
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
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
                          ? _isSavingChat
                              ? "Purutus speichert dein Chatverlauf..."
                              : "Purutus schreibt dir gerade..."
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
                  _saveMessages = _messages;
                  _messages = [];
                  if (_saveMessages.length >= 2) {
                    setState(() {
                      _isWaitingResponse = true;
                      _isSavingChat = true;
                    });
                    await _saveChatSession();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).pop();
                  }

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
