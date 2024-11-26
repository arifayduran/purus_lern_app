import 'package:purus_lern_app/src/features/chatbot/data/chatbot_messages.dart';
import 'dart:math';

String getRandomChatbotMessage() {
  refreshChatbotMessages();
  Random random = Random();
  return chatbotMessages[random.nextInt(chatbotMessages.length)];
}
