import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:purus_lern_app/src/config/palette.dart';
import 'package:purus_lern_app/src/features/chatbot/application/chatbot_random_message.dart';
import 'dart:async';
import 'package:purus_lern_app/src/features/chatbot/data/chatbot_current_message.dart';

class ChatbotMessagesTextWidget extends StatefulWidget {
  const ChatbotMessagesTextWidget({super.key});

  @override
  State<ChatbotMessagesTextWidget> createState() =>
      _ChatbotMessagesTextWidgetState();
}

class _ChatbotMessagesTextWidgetState extends State<ChatbotMessagesTextWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 45), (Timer timer) {
      setState(() {
        chatbotCurrentMessage = getRandomChatbotMessage();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          chatbotCurrentMessage = getRandomChatbotMessage();
        });
      },
      child: ChatBubble(
        clipper: ChatBubbleClipper8(type: BubbleType.sendBubble),
        backGroundColor: purusGreen,
        shadowColor: Colors.black,
        elevation: 5,
        alignment: Alignment.center,
        child: Text(
          // chatbotMessages[0],
          chatbotCurrentMessage,
          //   "purusLightGreypurusLightGreypurusLightGreypurusLightGreypurusLightGreypurusLightGreypurusLightGreypurusLightGreypurusLightGreypurusLightGreypurusLightGrey",
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            height: 1.2,
            letterSpacing: -0.7,
          ),
          maxLines: 4,
          softWrap: true,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
