import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return ios; // macOS can share the same options as iOS
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    appId: '1:700418486873:android:efb8817ebc1553d8fbf748',
    apiKey: 'AIzaSyB-wFJUv18kE1dt9CUEoH-jDX8etFlCCmU',
    projectId: 'toy-sells-project-id',
    messagingSenderId: '700418486873',
    storageBucket: 'toy-sells-project-id.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    appId: '1:700418486873:ios:8688fd372cae00b1fbf748',
    apiKey: 'AIzaSyD6WGemlwxK4QUu3pNydx5pibBqnu9c75g',
    projectId: 'toy-sells-project-id',
    messagingSenderId: '700418486873',
    storageBucket: 'toy-sells-project-id.firebasestorage.app',
    iosClientId: '700418486873-78ffljirdk8e699k8urf2n768vk7ks9m.apps.googleusercontent.com',
    iosBundleId: 'com.toysells.app',
  );
}
