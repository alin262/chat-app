import 'package:chat_app/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      backgroundColor: Color(0xFF3E2C23),
      appBar: AppBar(
        backgroundColor: Color(0xFF3E2C23),
        title: Text(
          "Chats",
          style: TextStyle(
            color: Color(0xFFF5E9D8),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: Color(0xFFF5E9D8)),
          ),
          IconButton(onPressed: () {ref.read(authNotifierProvider.notifier).signOut();}, icon: Icon(Icons.logout, color: Color(0xFFF5E9D8))),
        ],
      ),
      body: Center(child: Text("No conversations yet!\nTap 🔍 to find someone to chat with.", textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFF5E9D8)))),
    );
  }
}
