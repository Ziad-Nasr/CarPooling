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
    apiKey: 'AIzaSyAEXyUohZT4Aowp3QpL768S4Dfk8BtfFGI',
    appId: '1:9403965209:web:f26bcf31e94eeb5972ef88',
    messagingSenderId: '9403965209',
    projectId: 'login-carpool',
    authDomain: 'login-carpool.firebaseapp.com',
    storageBucket: 'login-carpool.appspot.com',
    measurementId: 'G-7EPBDMD7DY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCd7MRQzoIF23o2VKPmykc_euMoPwAgw20',
    appId: '1:9403965209:android:4b9bc0cecf7d901f72ef88',
    messagingSenderId: '9403965209',
    projectId: 'login-carpool',
    storageBucket: 'login-carpool.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCKZXWHIVoy6hfW277UN2LptjKxUTevyls',
    appId: '1:9403965209:ios:ee45765c7ec7eae172ef88',
    messagingSenderId: '9403965209',
    projectId: 'login-carpool',
    storageBucket: 'login-carpool.appspot.com',
    iosBundleId: 'com.example.project',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCKZXWHIVoy6hfW277UN2LptjKxUTevyls',
    appId: '1:9403965209:ios:ae88f0bfbfbae8b672ef88',
    messagingSenderId: '9403965209',
    projectId: 'login-carpool',
    storageBucket: 'login-carpool.appspot.com',
    iosBundleId: 'com.example.project.RunnerTests',
  );
}
