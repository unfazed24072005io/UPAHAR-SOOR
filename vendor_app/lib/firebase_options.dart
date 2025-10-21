// File: customer_app/lib/firebase_options.dart
// File: vendor_app/lib/firebase_options.dart

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

    // ANDROID CONFIGURATION
    const android = FirebaseOptions(
      apiKey: 'AIzaSyAyeLCH83Xj2A2w28N2A4_4HWaePCuLTAg', // Your API Key
      appId: '1:123456789:android:abcdef123456', // You'll get this from Firebase
      messagingSenderId: '123456789', // You'll get this from Firebase
      projectId: 'upahar-xxxxx', // Your Project ID
      storageBucket: 'upahar-xxxxx.appspot.com', // Your Storage Bucket
    );

    // iOS configuration would go here (optional for now)

    return android;
  }
}
