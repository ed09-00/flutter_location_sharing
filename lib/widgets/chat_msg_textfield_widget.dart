import 'package:flutter/material.dart';
import 'package:flutter_location_sharing/utils/index.dart';

class ChatMsgTextfieldWidget extends StatelessWidget {
  ChatMsgTextfieldWidget({Key? key, this.borderColor, this.iconButtonOnPress, required this.firebaseService, required this.senderName, required this.msgTextFieldController, this.height, required this.scrollController})
      : super(key: key){
      }
  //取得使用者名字
  final String senderName;

  //初始化firebaseService服務
  final FirebaseService firebaseService;

  //邊框顏色
  final Color? borderColor;

  //輸入文字控制器
  final TextEditingController msgTextFieldController;

  //送出按鈕點擊事件
  final void Function()? iconButtonOnPress;

  //滑動視窗控制器
  
  final ScrollController scrollController;

  //高
  final double? height;
  Widget _mainView() {

    //輸入框的邊、圓角
    return Container(
      
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
        color: borderColor ?? Colors.black,
      ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
      //輸入框內的textfield做margin
      child: Container(
        height: 30,
        margin: const EdgeInsets.only(left: 5),
        child: TextField(

          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              //send事件
              onPressed: () {         
                sendMessage();
              },
            ),
          ),
          controller: msgTextFieldController,
          
        ),
      ),
    );
  }
  sendMessage(){
    if (msgTextFieldController.text.isEmpty){
      return;
    }
    else{
      //取得現在時間
      DateTime now = DateTime.now();
      int timestamp = now.millisecondsSinceEpoch ~/ 1000;

      //將message相關資料存到資料庫
      firebaseService.chat.push().set({
        'senderName':senderName,
        'content':msgTextFieldController.text,
        'timestamp':timestamp,
      });

      // 清空输入框
      msgTextFieldController.clear();
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return _mainView();
  }
}
