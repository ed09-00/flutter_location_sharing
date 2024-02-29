import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_location_sharing/config/index.dart';
import 'package:flutter_location_sharing/pages/map_page.dart';
import 'package:flutter_location_sharing/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';


class ConnectPage extends StatefulWidget {
  const ConnectPage({Key? key}) : super(key: key);

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {

  SharedPreferences? prefs;

  //房號文字輸入框控制器
  final TextEditingController _textEditingController = TextEditingController();

  //user目前身分取得
  late FirebaseAuth auth;

  void joinRoom(String createdRoomId) async {

    //將房號存到local storage
    prefs?.setString("roomId", createdRoomId);
    
    //將自己的權限改為client
    prefs?.setInt('idendity', 1); //0為host 1為client

    //1.取得自己的uid、display name
    final User? user = auth.currentUser;
    final uid = user?.uid;
    final name = user?.displayName;
    
    //2.將自己的使用者id在firebase房內創建一位使用者,標記為client
    FirebaseDatabase.instance
        .ref()
        .child('rooms')
        .child(createdRoomId)
        .child('users')
        .child(user!.uid)
        .set(
      {
        'uid':uid??'none',
        'name': name??'none',
        'state': 'client', //host or client
        'latitude': 10,
        'longitude': 20,
      },
    ).then((value) {
       Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const MapPage()),
          );
    });
  }

  String hostRoom() {

    var uuid = Uuid();

    //取得uuid
    String createdRoomId = uuid.v4();

    //將uuid存到local storage
    prefs?.setString("roomId", createdRoomId);

    //將自己的權限改為host
    prefs?.setInt('idendity', 0); //0為host 1為client

    //1.取得使用者的id
    final User? user = auth.currentUser;
    final uid = user?.uid;
    final name = user?.displayName??"name";

    //2.將自己的使用者id在firebase房內創建一位使用者,標記為host
    FirebaseDatabase.instance
        .ref()
        .child('rooms')
        .child(createdRoomId)
        .child('users')
        .child(user!.uid)
        .set(
      {
        'uid':uid,
        'name': name,
        'state': 'host', //host or client
        'latitude': '10',
        'longitude': '20',
      },
    );
    return createdRoomId;
  }

  Widget _mainView() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          //創建房間按鍵
          SizedBox(
            height: 50,
            width: 250,
            child: ElevatedButton(
              onPressed: () {

                //創建房間
                String createdRoomId = hostRoom();

                //出彈跳視窗顯示成功或失敗 成功:顯示房號&複製按鈕&&確定按鈕(確定後跳轉)  失敗:對話框顯示失敗
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('創建成功! \n 房間ID為 $createdRoomId'),
                    actions: [
                      FloatingActionButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: createdRoomId));
                        },
                        child: const Text('複製'),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapPage(
                     
                                ),
                              ),
                              (route) => false);
                        },
                        child: const Text('確定'),
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                '創建房間',
                style: TextStyle(fontSize: connectPageButtonFontSize),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          //加入按鍵
          SizedBox(
            height: 50,
            width: 250,
            child: ElevatedButton(
              onPressed: () {
                //彈窗
                showDialog(
                  context: (context),
                  builder: (_) => AlertDialog(
                    title: const Text('輸入房號'),
                    content: TextField(
                      controller: _textEditingController,
                      decoration: const InputDecoration(
                        hintText: '房號',
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          final clipboardData =
                              await Clipboard.getData(Clipboard.kTextPlain);
                          _textEditingController.text =
                              clipboardData.toString();
                        },
                        child: const Text('貼上'),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            //房號驗證
                            joinValid().then((value) {
                              if (value == true){
                                 joinRoom(_textEditingController.text);
                              }
                            },);
                          },
                          child: const Text('加入'))
                    ],
                  ),
                );
              },
              child: Text(
                '加入房間',
                style: TextStyle(fontSize: connectPageButtonFontSize),
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),
          //---測試--- 登出按鍵
          SizedBox(
            height: 50,
            width: 250,
            child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then(
                        (value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginPage()),
                            (route) => false),
                      );
                },
                child: Text(
                  '登出',
                  style: TextStyle(fontSize: connectPageButtonFontSize),
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('創建或加入房間'),
      ),
      body: _mainView(),
    );
  }

  @override
  void initState() {
    super.initState();
    initLocalStorage();
    //取得firebase auth使用者資料
    auth = FirebaseAuth.instance;
    //initFirebase();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  //本地儲存空間初始化
  Future<void> initLocalStorage() async {
    prefs = await SharedPreferences.getInstance();
  }

  //初始化firebase
  void initFirebase() {
    Firebase.initializeApp();
  }

  //檢查房號是否存在
  Future<bool> joinValid()  async{
    bool isExist=await FirebaseDatabase.instance
        .ref()
        .child('rooms')
        .child(_textEditingController.text)
        .get()
        .then(
      (snapshot) {
        if (snapshot.value != null) {
          print('找到房間');
          return true;
        }
        else{
          return false;
        }
      },
    );
    print(isExist);
    return isExist;
  }
}
