class Message{
  Message({required this.messageId,required this.senderId,required this.senderName,required this.content,required this.timestamp, required this.isRead});

  String messageId;
  String senderId;
  String senderName;
  String content;
  DateTime timestamp;
  bool isRead;  
}

