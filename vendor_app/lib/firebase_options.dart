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

    // ANDROID CONFIGURATION FOR VENDOR APP
    const android = FirebaseOptions(
      apiKey: 'AIzaSyAyeLCH83Xj2A2w28N2A4_4HWaePCuLTAg',
      appId: '1:531294896795:android:ada2d28fe89b31942afc3e',
      messagingSenderId: '531294896795',
      projectId: 'upahar-ecommerce', // Your project ID
      storageBucket: 'upahar-ecommerce.appspot.com',
    );

    return android;
  }
}
