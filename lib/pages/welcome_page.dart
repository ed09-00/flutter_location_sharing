import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_location_sharing/pages/connect_page.dart';
import 'package:flutter_location_sharing/pages/map_page.dart';
import 'package:flutter_location_sharing/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String? text;
  Widget _mainView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ElevatedButton(
          //     onPressed: () {
          //       loadData();
          //     },
          //     child: Text('按鈕')),
          // Text("$text"),

          Container(
            child: Icon(
              Icons.emergency_share_outlined,
              size: 60,
            ),
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _mainView(),
    );
  }

  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(seconds: 3)).then(
      (value) {
        var user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
              (route) => false);
        } else {
          loadData().then(
          (roomId) {
            print('id:' + roomId);
            if (roomId.isNotEmpty) {
              FirebaseDatabase.instance
                  .ref()
                  .child('rooms')
                  .child(roomId)
                  .get()
                  .then(
                (snapshot) {
                  if (snapshot.value != null) {
                    print(snapshot.value);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPage(),
                      ),
                      (route) => false,
                    );
                  }
                },
              );
            } else {
              //找不到先前登入過的紀錄
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConnectPage(),
                  ),
                  (route) => false);
            }
          },
        );
        }        
      },
    );
  }

  void initFirebase() {
    Firebase.initializeApp();
  }

  Future<void> clearAllLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<String> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    String str = prefs.getString("roomId") ?? "";
    return str;
  }
}
