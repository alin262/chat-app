import 'package:flutter/widgets.dart';

class Message {
  final String senderId;
  final String text;
  final DateTime timeStamp;

  Message({
    required this.senderId,
    required this.text,
    required this.timeStamp,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map["senderId"],
      text: map["text"],
      timeStamp: (map['timeStamp'] as dynamic)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId, 
      "text": text, 
      "timeStamp": timeStamp
      };
  }
}
