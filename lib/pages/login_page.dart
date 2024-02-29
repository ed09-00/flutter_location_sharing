import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_location_sharing/pages/connect_page.dart';
import 'package:flutter_location_sharing/pages/register_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly',
];
GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: 'your-client_id.apps.googleusercontent.com',
  scopes: scopes,
);

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //email輸入框控制器
  final TextEditingController _emailTextFieldController =
      TextEditingController();

  //密碼輸入框控制器
  final TextEditingController _passwordTextFieldController =
      TextEditingController();
      
  //控制是否能見按鈕的布林變數
  bool _isObsure = true;

  //文字輸入框
  Widget _buildTextField({labelText, controller, obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      style: const TextStyle(),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
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
                  labelText: '帳號', controller: _emailTextFieldController),
            ),

            //密碼輸入框
            const SizedBox(
              height: 10,
            ),

            SizedBox(
                height: 50,
                child: TextField(
                  obscureText: _isObsure,
                  controller: _passwordTextFieldController,
                  style: const TextStyle(),
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
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
                )),

            //註冊按鈕
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text('註冊'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('忘記密碼?'),
                ),
              ],
            ),

            //登入按鈕
            SizedBox(
              width: 250,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  signInAccountWithEmailAndPassword(
                      email: _emailTextFieldController.text,
                      password: _passwordTextFieldController.text);
                },
                child: const Text('登入'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            //分割線
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                Text('第三方登入'),
                Expanded(
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            //第三方登入
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //google登入
                ElevatedButton(
                  onPressed: () {
                    _handleGoogleSignIn();
                  },
                  child: const Text('Google'),
                ),
                // //facebook
                // ElevatedButton(
                //   onPressed: () {
                //     //_handleGoogleSignOut();
                //   },
                //   child: const Text('facebook'),
                // ),
              ],
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
        title: const Text('登入'),
      ),
      body: _mainView(),
    );
  }

  @override
  void initState() {
    super.initState();
    firebaseAuthListener();
    
    //監聽google登入狀態
    //googleSignInListener();

    //判斷是否已經登入
  }

  @override
  void dispose() {
    super.dispose();
    _emailTextFieldController.dispose();
    _passwordTextFieldController.dispose();
  }

  Future<void> firebaseAuthListener()async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        print('user!=null');
         Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ConnectPage()));
      } else {
        print('no user');
        //如果沒有使用者就回到登入頁面
      }
    });
  }

  //使用email跟password登入
  Future<void> signInAccountWithEmailAndPassword({email, password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((userCredential) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ConnectPage()),
            (route) => false);
      });
    } on FirebaseAuthException {
      print('帳密錯誤');
    } catch (e) {
      print(e);
    }
  }

  //google的操作
  //google登入
  Future<void> _handleGoogleSignIn() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const ConnectPage()),
          (route) => false);
    });
  }

  //google登出
  Future<void> _handleGoogleSignOut() => _googleSignIn.disconnect();

  //google signin listener
  // void googleSignInListener() {

  //   _googleSignIn.onCurrentUserChanged
  //       .listen((GoogleSignInAccount? account) async {
  //     if (account!=null){

  //     _currentUser = account;
  //     _isAuthorized = true;

  //     // Now that we know that the user can access the required scopes, the app
  //     // can call the REST API.
  //     if (_isAuthorized) {
  //       print('displayName:' + _currentUser!.displayName.toString());
  //       print('email: ' + _currentUser!.email.toString());
  //       print('id: ' + _currentUser!.id.toString());
  //     }
  //     }

  //   });

  //   // In the web, _googleSignIn.signInSilently() triggers the One Tap UX.
  //   //
  //   // It is recommended by Google Identity Services to render both the One Tap UX
  //   // and the Google Sign In button together to "reduce friction and improve
  //   // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).
  //   _googleSignIn.signInSilently();
  // }
}
