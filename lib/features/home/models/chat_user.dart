class ChatUser {
  final String uid;
  final String name;
  final String email;
  final String photoURL;

  ChatUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoURL,
  });

  factory ChatUser.fromMap(Map<String, dynamic> map) {
    return ChatUser(
      uid: map["uid"] ?? "",
      name: map["name"] ?? "",
      email: map["email"] ?? "",
      photoURL: map["photoURL"] ?? "",
    );
  }
}
