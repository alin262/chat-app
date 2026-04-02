import 'package:chat_app/features/chat/models/message_model.dart';
import 'package:chat_app/features/home/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/features/chat/providers/chat_provider.dart';

class ChatScreen extends ConsumerWidget {
  final ChatUser receiver;
  const ChatScreen({required this.receiver});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final conversationId = getConversationId(currentUser.uid, receiver.uid);
    final messageAsync = ref.watch(messagesProvider(conversationId));
    final TextEditingController messageController = TextEditingController();
    return Scaffold(
      backgroundColor: Color(0xFF3E2C23),
      appBar: AppBar(
        backgroundColor: Color(0xFF3E2C23),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFF5E9D8)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: receiver.photoURL.isNotEmpty
                  ? NetworkImage(receiver.photoURL)
                  : null,
              child: receiver.photoURL.isEmpty
                  ? Text(receiver.name[0].toUpperCase())
                  : null,
            ),
            SizedBox(width: 10),
            Text(receiver.name, style: TextStyle(color: Color(0xFFF5E9D8))),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messageAsync.when(
              data: (messages) {
                return messages.isEmpty
                    ? Center(child: Text('No messages Yet! \nSay hello'))
                    : ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId == currentUser.uid;
                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: ConstrainedBox(constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.7),
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? Color(0xFF2FA4D7)
                                      : Color(0xFF5C4033),
                                    borderRadius: BorderRadius.circular(14)
                                ),
                                child: Text(message.text),
                              ),
                            ),
                          );
                        },
                      );
              },
              error: (error, stackTrace) =>
                  Center(child: Text("Errorrr: $error")),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),
          Container(
            padding: EdgeInsets.all(23),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      maxLines: null,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,

                      controller: messageController,
                      style: TextStyle(color: Color(0xFFF5E9D8)),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Color.fromARGB(255, 77, 53, 42),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  child: IconButton(
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        ref
                            .read(chatProvider.notifier)
                            .sendMessage(
                              conversationId: conversationId,
                              text: messageController.text,
                              receiverId: receiver.uid,
                            );
                        messageController.clear();
                      }
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
                SizedBox(width: 19),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
