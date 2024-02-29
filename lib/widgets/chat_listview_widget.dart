import 'package:flutter/material.dart';
import 'package:flutter_location_sharing/utils/firebase_service_util.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatListViewWidget extends StatefulWidget {
  const ChatListViewWidget({Key? key, required this.firebaseService, required this.scrollController})
      : super(key: key);

  // Firebase服務的構造函數
  final FirebaseService firebaseService;

  
  final ScrollController scrollController;

  //高

  @override
  // 創建ChatListViewWidget的狀態
  _ChatListViewWidgetState createState() => _ChatListViewWidgetState();
}

class _ChatListViewWidgetState extends State<ChatListViewWidget> {
  // 用於保存聊天消息的列表
  List<Map> lists = [];

  Widget textWithStyle({required String text}){
    return Text(
      text,
      overflow: TextOverflow.fade,
      style:  GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
      ),
    );
  }
  // 主要的UI視圖
  Widget _mainView() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        border: Border.all(color: Colors.black),
      ),
      child: StreamBuilder(
        stream: widget.firebaseService.chat.onValue,
        builder: (context, snapshot) {
          
          if (mounted && snapshot.hasData) {
            print(snapshot.data);
            // 從快照中提取數據
            
            Map data = (snapshot.data!.snapshot.value??{}) as Map;
        
            // 將數據添加到列表中
            lists.clear();
            data.forEach((key, values) {
              lists.add(values);
            });
        
            // 根據時間戳排序列表
            lists.sort(((a, b) {
              DateTime dt1 =
                  DateTime.fromMillisecondsSinceEpoch(a['timestamp'] * 1000);
              DateTime dt2 =
                  DateTime.fromMillisecondsSinceEpoch(b['timestamp'] * 1000);
              return dt2.compareTo(dt1);
            }));
        
            // 構建聊天消息的ListView
            return ListView.builder(
              keyboardDismissBehavior:ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(3, 5, 0, 3),
              reverse: true,
              itemCount: lists.length,
              itemBuilder: (BuildContext context, int index) {
                var dtTmp = lists[index]['timestamp'];
                DateTime dt =
                    DateTime.fromMillisecondsSinceEpoch(dtTmp * 1000);
                dt = dt.add(const Duration(hours: 8));
        
                // 構建每個聊天消息的UI
                return Container(
                  margin: const EdgeInsets.only(top: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWithStyle(text: "[${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}] ${lists[index]['senderName']} : "),
                      Expanded(
                        child: textWithStyle(text: "${lists[index]['content']}",
                          ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text("無數據");
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }

  @override
  void initState() {
    super.initState();
  }
}
