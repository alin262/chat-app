import 'package:chat_app/features/auth/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(body: Center(child: Text("Home Screen")),floatingActionButton: ElevatedButton(onPressed: () {
      ref.read(authNotifierProvider.notifier).signOut();
    }, child: Text("Signout")),);
  }
}
