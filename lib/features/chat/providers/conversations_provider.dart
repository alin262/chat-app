import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/models/chat_user.dart';

class Conversation {
  final String conversationId;
  final ChatUser otherUser;
  final String lastMessage;
  final DateTime? lastMessageTime;

  Conversation({
    required this.conversationId,
    required this.otherUser,
    required this.lastMessage,
    this.lastMessageTime,
  });
}

final conversationsProvider = StreamProvider<List<Conversation>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('conversations')
      .where('members', arrayContains: currentUser.uid)
      .orderBy('lastMessageTime', descending: true)
      .snapshots()
      .asyncMap((snapshot) async {
        List<Conversation> conversations = [];

        for (final doc in snapshot.docs) {
          final data = doc.data();
          final members = List<String>.from(data['members'] ?? []);
          final otherUserId = members.firstWhere(
            (id) => id != currentUser.uid,
            orElse: () => '',
          );

          if (otherUserId.isEmpty) continue;

          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(otherUserId)
              .get();

          if (!userDoc.exists) continue;

          final otherUser = ChatUser.fromMap(userDoc.data()!);
          final timestamp = data['lastMessageTime'] as dynamic;

          conversations.add(Conversation(
            conversationId: doc.id,
            otherUser: otherUser,
            lastMessage: data['lastMessage'] ?? '',
            lastMessageTime: timestamp?.toDate(),
          ));
        }

        return conversations;
      });
});