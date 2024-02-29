import 'dart:math';

String generateMessageId() {
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var random = Random().nextInt(1000000); // 隨機數
    return '$timestamp$random';
  }