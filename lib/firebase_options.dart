import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Platform non supportée');
    }
  }

  // --- CONFIGURATION WEB ---
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAH-xvXdHGGzAZn6_X4qeGgJ2VT4D8rUv4',
    appId: '1:209779260546:web:658c42a275f1234567890', // ⚠️ Vérifie bien cet ID dans la console Firebase Web
    messagingSenderId: '209779260546',
    projectId: 'akasuts-app',
    authDomain: 'akasuts-app.firebaseapp.com',
    storageBucket: 'akasuts-app.appspot.com',
  );

  // --- CONFIGURATION ANDROID ---
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAH-xvXdHGGzAZn6_X4qeGgJ2VT4D8rUv4',
    appId: '1:209779260546:android:820a9dd3e001d06f2c489b',
    messagingSenderId: '209779260546',
    projectId: 'akasuts-app',
    storageBucket: 'akasuts-app.appspot.com',
  );
}