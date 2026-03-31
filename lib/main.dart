import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import './features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import './features/home/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: authState.when(
        data: (data) => data != null ? HomeScreen() : LoginScreen(),
        error: (error, stackTrace) =>
            Scaffold(body: Center(child: Text("Error: $error "))),
        loading: () => Scaffold(backgroundColor: Color(0xFF3E2C23),
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_rounded,
                    size: 90,
                    color: const Color(0xFF2FA4D7),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Chat App",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF5E9D8),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Let's connect with world",
                    style: TextStyle(color: const Color(0xFFF5E9D8)),
                  ),
                  const SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
