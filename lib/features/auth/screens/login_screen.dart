import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      backgroundColor: Color(0xFF3E2C23),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_rounded,
              size: 90,
              color: const Color(0xFF2FA4D7),
            ),
          const  SizedBox(height: 20),
            Text(
              "Chat App",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF5E9D8),
              ),
            ),
         const   SizedBox(height: 5),
            Text(
              "Let's connect with world",
              style: TextStyle(color: const Color(0xFFF5E9D8)),
            ),
         const   SizedBox(height: 20),
            authState.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: () {
                      ref
                          .read(authNotifierProvider.notifier)
                          .signInWithGoogle();
                    },
                    label: Text("Sign in With Google"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA98B76),
                      foregroundColor: const Color(0xFF41431B),
                      padding: EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 16,
                      ),
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            if (authState.hasError)
              Padding(
                padding:const EdgeInsets.all(16),
                child: Text(
                  'Error:${authState.error}',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
