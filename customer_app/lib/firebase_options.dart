import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }

    // CORRECT ANDROID CONFIGURATION FOR CUSTOMER APP
    const android = FirebaseOptions(
      apiKey: 'AIzaSyAyeLCH83Xj2A2w28N2A4_4HWaePCuLTAg',
      appId: '1:531294896795:android:fe14acb401f0581b2afc3e',
      messagingSenderId: '531294896795',
      projectId: 'upahar-bacb3', // ← CORRECT PROJECT ID
      storageBucket: 'upahar-bacb3.firebasestorage.app', // ← CORRECT BUCKET
    );

    return android;
  }
}
