// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC6ZR8AixNBVyodzlpfzrtbsx04P66UOe0',
    appId: '1:571158606725:web:af28943bb3bacc021a0aec',
    messagingSenderId: '571158606725',
    projectId: 'flutter-location-sharing-16614',
    authDomain: 'flutter-location-sharing-16614.firebaseapp.com',
    databaseURL: 'https://flutter-location-sharing-16614-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-location-sharing-16614.appspot.com',
    measurementId: 'G-BE11SNWB6J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5Dn2sj2XLe5Tv3SHEycDRCND4NiwnJYE',
    appId: '1:571158606725:android:54a5b8382f3f7a791a0aec',
    messagingSenderId: '571158606725',
    projectId: 'flutter-location-sharing-16614',
    databaseURL: 'https://flutter-location-sharing-16614-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-location-sharing-16614.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDB5Zn-bHosxqxkCsB_qPpYNZ_txuNBQSQ',
    appId: '1:571158606725:ios:a1e7744352d17e501a0aec',
    messagingSenderId: '571158606725',
    projectId: 'flutter-location-sharing-16614',
    databaseURL: 'https://flutter-location-sharing-16614-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-location-sharing-16614.appspot.com',
    androidClientId: '571158606725-3pu70g12a74dp2neq4av6s03ct8qdkrt.apps.googleusercontent.com',
    iosClientId: '571158606725-dh0hur6o606p7nkkg92ve4i8ma5vbqbp.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterLocationSharing',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDB5Zn-bHosxqxkCsB_qPpYNZ_txuNBQSQ',
    appId: '1:571158606725:ios:aba5f01fe069f0431a0aec',
    messagingSenderId: '571158606725',
    projectId: 'flutter-location-sharing-16614',
    databaseURL: 'https://flutter-location-sharing-16614-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-location-sharing-16614.appspot.com',
    androidClientId: '571158606725-3pu70g12a74dp2neq4av6s03ct8qdkrt.apps.googleusercontent.com',
    iosClientId: '571158606725-f374n5bgskere28nd3emqfh1mlp1rs5a.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterLocationSharing.RunnerTests',
  );
}
