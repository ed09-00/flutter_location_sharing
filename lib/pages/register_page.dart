import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_location_sharing/pages/connect_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController _emailTextFieldController =
      TextEditingController();

  final TextEditingController _passwordTextFieldController =
      TextEditingController();

  bool _isObsure = true;
  
  Widget _buildTextField({labelText, controller, obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      style: TextStyle(),
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText ?? '輸入框',
      ),
    );
  }

  Widget _mainView() {
    return Center(
      child: SizedBox(
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            //帳號輸入框
            SizedBox(
              height: 50,
              child: _buildTextField(
                labelText: '信箱',
                controller: _emailTextFieldController,
              ),
            ),

            
            const SizedBox(
              height: 10,
            ),

            //密碼輸入框
            SizedBox(
              height: 50,
              child: TextField(
                obscureText: _isObsure,
                controller: _passwordTextFieldController,
                style: const TextStyle(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '密碼',
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObsure = !_isObsure;
                        });
                      },
                      icon: _isObsure
                          ? const Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            )
                          : const Icon(Icons.visibility, color: Colors.black),
                    )),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            //登入按鈕
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                    createAccountWithEmailAndPassword(
                      email: _emailTextFieldController.text,
                      password: _passwordTextFieldController.text,
                    );
                },
                child: const Text('註冊'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('註冊頁面'),
        ),
        body: _mainView());
  }

  @override
  void initState() {
    super.initState();
    authStateListener();
  }

  @override
  void dispose() {
    super.dispose();
    _emailTextFieldController.dispose();
    _passwordTextFieldController.dispose();
  }

  //使用email 與 password在firebase中創建一組帳號密碼，成功的話導向connectPage
  Future<void> createAccountWithEmailAndPassword({email, password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential.user!.uid);
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ConnectPage()));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {}
    } catch (e) {
      print(e);
    }
  }

  //監聽帳號登入 or 登出狀態
  void authStateListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        print(user.uid);
      } else {
        print('no user');
      }
    });
    setState(() {});
  }
}
