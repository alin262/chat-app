import 'package:chat_app/features/auth/providers/auth_provider.dart';
import 'package:chat_app/features/home/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final searchQueryProvider = StateProvider<String>((ref) => "");

class _SearchSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .7,
      builder: (context, scrollController) {
        final searchQuery = ref.watch(searchQueryProvider);
        final userAsync = ref.watch(usersProvider);
        return Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFFF5E9D8),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                textAlign: TextAlign.center,
                autofocus: true,
                style: TextStyle(color: Color(0xFFF5E9D8)),
                decoration: InputDecoration(
                  hintText: "Search by name",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (value) =>
                    ref.read(searchQueryProvider.notifier).state = value
                        .toLowerCase(),
              ),
            ),
            Expanded(
              child: userAsync.when(
                error: (error, stackTrace) => Text("error showing $error"),
                loading: () => const Center(child: CircularProgressIndicator()),
                data: (users) {
                  final filtered = searchQuery.isEmpty
                      ? users
                      : users
                            .where(
                              (user) =>
                                  user.name.toLowerCase().contains(searchQuery),
                            )
                            .toList();
                  if (filtered.isEmpty) {
                    return Center(child: Text("No user found!"));
                  }
                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = filtered[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user.photoURL.isNotEmpty
                              ? NetworkImage(user.photoURL)
                              : null,
                          child: user.photoURL.isEmpty
                              ? Text(user.name[0].toUpperCase())
                              : null,
                        ),
                        title: Text(
                          user.name,
                          style: TextStyle(color: Colors.white70),
                        ),
                        subtitle: Text(
                          user.email,
                          style: TextStyle(color: Colors.white60),
                        ),
                        onTap: () => Navigator.pop(context),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  void _showSearchSheet(BuildContext context, WidgetRef ref) {
    ref.read(searchQueryProvider.notifier).state = "";
    showModalBottomSheet(
      backgroundColor: Color(0xFF3E2C23),
      isScrollControlled: true,
      context: context,
      builder: (context) => ProviderScope(child: _SearchSheet()),
    );
  }

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
            onPressed: () {
              _showSearchSheet(context, ref);
            },
            icon: Icon(Icons.search, color: Color(0xFFF5E9D8)),
          ),
          IconButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).signOut();
            },
            icon: Icon(Icons.logout, color: Color(0xFFF5E9D8)),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "No conversations yet!\nTap 🔍 to find someone to chat with.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFFF5E9D8)),
        ),
      ),
    );
  }
}
