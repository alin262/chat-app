import 'package:chat_app/features/chat/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

String getConversationId(String uid1, String uid2) {
  final ids = [uid1, uid2]..sort();
  return ids.join('');
}

final messagesProvider = StreamProvider.family<List<Message>, String>((
  ref,
  conversationId,
) {
  return FirebaseFirestore.instance
      .collection('conversations')
      .doc(conversationId)
      .collection("messages")
      .orderBy("timeStamp")
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList(),
      );
});

class chatNotifier extends StateNotifier<AsyncValue<void>> {
  chatNotifier() : super(const AsyncValue.data(null));

  Future<void> sendMessage({
    required String conversationId,
    required String text,
    required String receiverId,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      final message = Message(
        senderId: currentUser.uid,
        text: text,
        timeStamp: DateTime.now(),
      );
      await FirebaseFirestore.instance
          .collection("conversations")
          .doc(conversationId)
          .collection("messages")
          .add(message.toMap());
      await FirebaseFirestore.instance
          .collection("conversations")
          .doc(conversationId)
          .set({
            "members": [currentUser.uid, receiverId],
            "lastMessage": text,
            "lastMessageTime": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final chatProvider = StateNotifierProvider<chatNotifier, AsyncValue<void>>((
  ref,
) {
  return chatNotifier();
});
