import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

// (in deleted)
// Soll nach dem schliessen der chatbot seite gespeichert werden, und zwar in Firestone als stream. Es soll noch eine liste von allen chatverläufen geben. In Firestone soll auch die Benutzer id ${currentUser!.id} gespeichert werden und dann je nach chat thema(das soll chat gpt abi zum Schluss sagen, um welche Thema es handelte als überschrift String)

class ChatbotUserFirestoreMessages {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Erstellt eine neue Chat-Sitzung und gibt die Sitzungs-ID zurück.
  Future<String> createChatSession(String userId) async {
    final chatDoc = await _firestore.collection('chat_sessions').add({
      'userId': userId,
      'theme': null, // Thema wird später gesetzt
      'createdAt': FieldValue.serverTimestamp(),
    });
    return chatDoc.id;
  }

  /// Speichert eine Nachricht als `types.Message` in einer bestimmten Chat-Sitzung.
  Future<void> saveMessage({
    required String chatId,
    required types.Message message,
  }) async {
    final messageData = _serializeMessage(message);
    await _firestore
        .collection('chat_sessions')
        .doc(chatId)
        .collection('messages')
        .add(messageData);
  }

  /// Ruft die Nachrichten einer bestimmten Chat-Sitzung ab und deserialisiert sie zu `types.Message`.
  Future<List<types.Message>> getChatMessages(String chatId) async {
    final snapshot = await _firestore
        .collection('chat_sessions')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .get();

    return snapshot.docs.map((doc) => _deserializeMessage(doc.data())).toList();
  }

  /// Aktualisiert das Thema der Chat-Sitzung.
  Future<void> updateChatTheme(String chatId, String theme) async {
    await _firestore.collection('chat_sessions').doc(chatId).update({
      'theme': theme,
    });
  }

  /// Löscht alle Nachrichten und die Sitzung.
  Future<void> deleteChatSession(String chatId) async {
    final messagesRef = _firestore
        .collection('chat_sessions')
        .doc(chatId)
        .collection('messages');

    // Lösche alle Nachrichten
    final messagesSnapshot = await messagesRef.get();
    for (var doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }

    // Lösche die Chat-Sitzung
    await _firestore.collection('chat_sessions').doc(chatId).delete();
  }

  /// Serialisiert eine `types.Message` in ein JSON-fähiges Map-Objekt.
  Map<String, dynamic> _serializeMessage(types.Message message) {
    if (message is types.TextMessage) {
      return {
        'id': message.id,
        'authorId': message.author.id,
        'authorFirstName': message.author.firstName,
        'text': message.text,
        'type': 'text',
        'timestamp': message.createdAt,
      };
    }
    // Weitere Nachrichtentypen hier behandeln (z. B. ImageMessage, FileMessage)
    throw UnimplementedError('Unsupported message type');
  }

  /// Deserialisiert ein JSON-Objekt zu einem `types.Message`.
  types.Message _deserializeMessage(Map<String, dynamic> data) {
    final author = types.User(
      id: data['authorId'] as String,
      firstName: data['authorFirstName'] as String?,
    );

    if (data['type'] == 'text') {
      return types.TextMessage(
        id: data['id'] as String,
        author: author,
        text: data['text'] as String,
        createdAt: data['timestamp'] as int?,
      );
    }
    // Weitere Nachrichtentypen hier behandeln (z. B. ImageMessage, FileMessage)
    throw UnimplementedError('Unsupported message type');
  }
}
