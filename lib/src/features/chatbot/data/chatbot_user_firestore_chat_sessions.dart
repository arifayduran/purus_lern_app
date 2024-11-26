import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

// (in deleted)
// Soll nach dem schliessen der chatbot seite gespeichert werden, und zwar in Firestone als stream. Es soll noch eine liste von allen chatverläufen geben. In Firestone soll auch die Benutzer id ${currentUser!.id} gespeichert werden und dann je nach chat thema(das soll chat gpt abi zum Schluss sagen, um welche Thema es handelte als überschrift String)

class ChatbotUserFirestoreChatSessions {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Speichert eine Nachricht und aktualisiert automatisch die Chat-Sitzung.
  /// Wenn die Sitzung nicht existiert, wird sie erstellt.
  Future<void> saveMessage({
    required String userId,
    required types.Message message,
    String? chatTheme,
  }) async {
    final userChatRef = _firestore.collection('chat_sessions').doc(userId);

    // Prüfe, ob die Chat-Sitzung bereits existiert
    final sessionSnapshot = await userChatRef.get();

    if (!sessionSnapshot.exists) {
      // Erstelle die Sitzung mit einem Standard-Theme
      await userChatRef.set({
        'theme': chatTheme ?? "Unbekanntes Thema",
        'createdAt': FieldValue.serverTimestamp(),
        'messages': [],
      });
    }

    // Nachricht serialisieren
    final messageData = _serializeMessage(message);

    // Nachricht zur `messages`-Liste hinzufügen
    await userChatRef.update({
      'messages': FieldValue.arrayUnion([messageData]),
    });
  }

  /// Serialisiert eine `types.Message` in ein Map-Format für Firestore.
  Map<String, dynamic> _serializeMessage(types.Message message) {
    if (message is types.TextMessage) {
      return {
        'id': message.id,
        'authorId': message.author.id,
        'text': message.text,
        'createdAt': message.createdAt,
        'type': 'text',
      };
    }
    throw UnimplementedError('Message type not supported');
  }

  /// Lädt alle Nachrichten für eine bestimmte Chat-Sitzung.
  Future<List<types.Message>> getChatMessages(String userId) async {
    final userChatRef = _firestore.collection('chat_sessions').doc(userId);
    final sessionSnapshot = await userChatRef.get();

    if (!sessionSnapshot.exists) return [];

    final messages =
        sessionSnapshot.data()?['messages'] as List<dynamic>? ?? [];
    return messages
        .map((data) => _deserializeMessage(data as Map<String, dynamic>))
        .toList();
  }

  /// Aktualisiert das Thema der Chat-Sitzung.
  Future<void> updateChatTheme(String userId, String theme) async {
    await _firestore.collection('chat_sessions').doc(userId).update({
      'theme': theme,
    });
  }

  /// Löscht eine Chat-Sitzung.
  Future<void> deleteChatSession(String userId) async {
    await _firestore.collection('chat_sessions').doc(userId).delete();
  }

  /// Deserialisiert ein JSON-Objekt zu einem `types.Message`.
  types.Message _deserializeMessage(Map<String, dynamic> data) {
    final author = types.User(id: data['authorId'] as String);

    if (data['type'] == 'text') {
      return types.TextMessage(
        id: data['id'] as String,
        author: author,
        text: data['text'] as String,
        createdAt: data['createdAt'] as int?,
      );
    }
    throw UnimplementedError('Unsupported message type');
  }
}
