import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_location_sharing/model/message_model.dart';

class FirebaseService {
  //get ref
  late DatabaseReference ref;
  late DatabaseReference chat;
  FirebaseService(String roomId) {
    try {
      ref = FirebaseDatabase.instance
          .ref()
          .child('rooms')
          .child(roomId)
          .child('users');
      chat = FirebaseDatabase.instance
          .ref()
          .child('rooms')
          .child(roomId)
          .child('messages');
    } catch (e) {
      print('Firebase連接錯誤: $e');
    }
  }
  /*-----CREATE------*/
  //增加測試使用者
  ///required uid,required name,required state,required latitude,required longitude:
  void addUser(Map info) {
    ref.push().set(info);
  }

  /*-----READ-----*/
  //讀取聊天室資料庫
  List<Message> loadChatDate() {

    //全部訊息陣列
    List<Message> msgs = [];

    //取得某房間全部資料
    chat.get().then((snapshot) {      
      Map msg = snapshot.value as Map;
      msg.forEach((key, value) {
        msgs.add(Message(
            messageId: value['messageId'].toString(),
            senderId: value['senderId'].toString(),
            senderName: value['senderName'].toString(),
            content: value['content'].toString(),
            timestamp: DateTime(value['timestamp']),
            isRead: value['messageId']!=false,),);
      });      
    });

    return msgs;
  }

  //DELETE

  /*-----UPDATE-----*/
  //更新位置
  void updatePosition(String uid, double latitude, double longitude) {
    ref.child(uid).update({
      'latitude': latitude,
      'longitude': longitude,
    });
  }
}
