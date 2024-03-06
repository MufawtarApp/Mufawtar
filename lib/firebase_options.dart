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
    apiKey: 'AIzaSyCxRjs8ubd2oXvxUG7rJMmOQHxDIGWE3UI',
    appId: '1:385583311727:web:32b2ec9496b3d3fe22169a',
    messagingSenderId: '385583311727',
    projectId: 'kkkk-94b3f',
    authDomain: 'kkkk-94b3f.firebaseapp.com',
    storageBucket: 'kkkk-94b3f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgYKXqayvt_jb5iR0njKNNCzgB7iHSzlc',
    appId: '1:385583311727:android:89a8c03c23b9d74f22169a',
    messagingSenderId: '385583311727',
    projectId: 'kkkk-94b3f',
    storageBucket: 'kkkk-94b3f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDbPVH9vsiP4aRHm9duKmcOgg0_a5cuRnw',
    appId: '1:385583311727:ios:966cea70f6cbf6c822169a',
    messagingSenderId: '385583311727',
    projectId: 'kkkk-94b3f',
    storageBucket: 'kkkk-94b3f.appspot.com',
    iosBundleId: 'com.example.mufawtar',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDbPVH9vsiP4aRHm9duKmcOgg0_a5cuRnw',
    appId: '1:385583311727:ios:6ee0313535e323dd22169a',
    messagingSenderId: '385583311727',
    projectId: 'kkkk-94b3f',
    storageBucket: 'kkkk-94b3f.appspot.com',
    iosBundleId: 'com.example.mufawtar.RunnerTests',
  );
}
