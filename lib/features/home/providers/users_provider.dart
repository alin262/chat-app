import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final usersProvider = FutureProvider<List<ChatUser>>((ref) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  final snapshot = await FirebaseFirestore.instance.collection("users").get();
  return snapshot.docs
      .map((doc) => ChatUser.fromMap(doc.data()))
      .where((user) => user.uid != currentUser?.uid)
      .toList();
});
