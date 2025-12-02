import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:toysell_app/MVC/controller/chat_controller.dart';

import '../firebase_options.dart';
import 'local_storage.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  late String fcmToken;
  final ChatController chatController = Get.put(ChatController());

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeFirebase() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform);
      print("Firebase initialized 🔥✅");

      // Subscribe to a topic (optional)
      // FirebaseMessaging.instance.subscribeToTopic('subscription');

      await FirebaseMessaging.instance
          .requestPermission(badge: true, sound: true, alert: true);

      // Fetch and save FCM Token and device info
      fcmToken = (await FirebaseMessaging.instance.getToken())!;
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = Platform.isAndroid
          ? await deviceInfoPlugin.androidInfo
          : await deviceInfoPlugin.iosInfo;

      if (deviceInfo is AndroidDeviceInfo) {
        print("FCM Token: $fcmToken");
        print("Device ID: ${deviceInfo.id}");
        LocalDataStorage().insertDeviceAndFCMInformation(
          FcmToken: fcmToken,
          deviceID: deviceInfo.id,
        );
      } else if (deviceInfo is IosDeviceInfo) {
        print("FCM Token: $fcmToken");
        print("Device ID: ${deviceInfo.identifierForVendor}");
        LocalDataStorage().insertDeviceAndFCMInformation(
          FcmToken: fcmToken,
          deviceID: deviceInfo.identifierForVendor,
        );
      }

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, sound: true, badge: true);

      // Setup foreground notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print("Foreground Notification: ${message.notification?.title}");
        var itemOfferId = int.parse(message.data['item_offer_id'].toString());
        chatController.fetchChatMessages(itemOfferId);
        displayNotification(message);
      });

      // Setup background notifications
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

      // Handle notifications when app is opened via a tap
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("Notification Clicked: ${message.notification?.title}");
        handleNotificationClick(message.data['key']);
      });

      // Handle initial notification when app is launched via notification
      final initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        print(
            "Notification from Terminated State: ${initialMessage.notification?.title}");
        handleNotificationClick(initialMessage.data['key']);
      }

      // Initialize local notifications
      initializeLocalNotifications();
    } catch (e) {
      print("Error initializing Firebase or Notifications: $e");
    }
  }

  Future<void> initializeLocalNotifications() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          print('Notification tapped with payload: ${response.payload}');
          handleNotificationClick(response.payload!);
        }
      },
    );

    _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> displayNotification(RemoteMessage message) async {
    try {
      final notification = message.notification;
      final android = message.notification?.android;
      final ios = message.notification?.apple;

      if (notification != null && android != null) {
        const AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
          priority: Priority.high,
        );

        const NotificationDetails platformDetails =
            NotificationDetails(android: androidDetails);

        await _localNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          platformDetails,
          payload: message.data['key'], // Route key
        );
      }

      // If iOS notification
      // if (notification != null && ios != null) {
      //   const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      //     badgeNumber: 1,
      //   );
      //
      //   const NotificationDetails platformDetails = NotificationDetails(iOS: iosDetails);
      //
      //   await _localNotificationsPlugin.show(
      //     notification.hashCode,
      //     notification.title,
      //     notification.body,
      //     platformDetails,
      //     payload: message.data['key'],
      //   );
      // }
    } catch (e) {
      print("Error displaying notification: $e");
    }
  }

  Future<void> sendPushNotification(String fcmToken, String notificationType,
      {String? userName}) async {
    try {
      final data = _buildNotificationData(fcmToken, notificationType,
          userName: userName);

      final serviceKey = await _getAccessToken();
      final projectId = 'quitting-buddies-e5c5c';

      final response = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serviceKey',
        },
        body: jsonEncode(data),
      );

      var decodedBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print("Push notification sent successfully!");
      } else {
        print(
            "Failed to send notification. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error sending push notification: $e");
    }
  }

  Map<String, dynamic> _buildNotificationData(
      String fcmToken, String notificationType,
      {String? userName}) {
    switch (notificationType) {
      case 'receiveRequest':
        return {
          'message': {
            'token': fcmToken,
            'notification': {
              'title': 'New Friend Request',
              'body': '${userName ?? "A User"} sent you a friend request',
            },
            'data': {'key': 'friendPagePendingRequest'},
          }
        };
      case 'acceptRequest':
        return {
          'message': {
            'token': fcmToken,
            'notification': {
              'title': 'New Friend Added',
              'body': '${userName ?? "A User"} accepted your friend request',
            },
            'data': {'key': 'friendPage'},
          }
        };
      case 'appraisalMessage':
        return {
          'message': {
            'token': fcmToken,
            'notification': {
              'title': 'New Appraisal 🙌',
              'body': '${userName ?? "A User"} sent you an appraisal',
            },
            'data': {'key': 'notification'},
          }
        };
      case 'test':
        return {
          'message': {
            'token': fcmToken,
            'notification': {
              'title': 'Test Message',
              'body': 'This is a test message',
            },
            'data': {'key': 'testmessage'},
          }
        };
      default:
        return {};
    }
  }

  Future<String> _getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "toy-sells-project-id",
      "private_key_id": "0e1bbfe42bb1cdcbdc4049d3ebd5c22df589ab8a",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCikl7+QMQjdGzg\nfwyjqT7famULzVXIsM6CACnaVljB22srJOVsi8nDJUdZ7Vl3VP4OZgs456sCjHv3\nbkLDrl1hLsV02yNAJmy9fEiacW3gwZlvQG1UtyVXwI6s1ifWXtFPHcUE2L3fZBbC\nCpxeaoqGBilJVHd5HSGDXtXj8dFJrPFI9rUBtd/h8GrWqbfKSn7k/cLcKhcc6RU4\ner4fhpxQOyz37XTnglk9/EQYJ2JqV1ya9XuGS9xUPEkAP4xWPgSr1wvpCGxSqyva\n7rb7qvypZKusItKzwpjquII6rF2E1ja2k9NZyJ+jrZ09n54k9ADzgpVGlZcMg31+\n6eFziqFHAgMBAAECggEADBb0fNXrgB4lW/XhcROh+v1aMawocqSWBtw6QI679QFQ\nkUR3fJX8qsgilpEXCSUcljeHzXM0/XCIZi3LReq5Q66LEpXv+NJNXd4DNtuz6ctG\nkhu+xauvrudBSkshap4Mf2SzBRmVLSqv9+glbsQKNHilfgWLs58IoftdzqC/Xp92\neAwSaQF+PohJWJYYmpgGGP/iD9+uPfIL+3Rn24aZ6dord8T0q+idjOCK0+jeDOyG\naMkdsftr89VP7sGbBUjjQrCfDqHW2yv4LsxRlMfJafYk0Kr7f3TkV8RKwxXFah4z\ny+wD8ZSHBrqwA3NrQYIs4PKJw7OaxJFRqVbDkt4fgQKBgQDPZZSAxdqpnawJhLqW\nwV81lPw+3FdZUq2n9CimcnrZtL4Aw5LHU3BultjPMkOZ5c9jBwZlnoizRiiYWmTd\naDKW5EdeDkhQ0MDS+bTArmNGIDwpnADyUEeivhG3ZnpTMxkcUb0KblYMXjRhmalE\nZF3h91LBHJ38RTLZWzH8BO7OBwKBgQDIq5a+Ai/ABtFDs48U884h6njNN6xSBhkT\n7UNDb0juaKNlSYkSR7cknfV5z9OtUc/rboZEwSGXFgeWB86CPChKRpz7Vhb2Nmzt\nvI25Gj1I8Thmh/mY0tFGOezReuOFXH3q2ataF1FqkRw4iLsCoYmm2VbjnKHWi6O6\nJhy8SaDCwQKBgEjSvkZJMvKD7riY5nuxAqFp4vifnfw7T8a9sNhhMknncSALjCp5\nXe03AoIegCY1z5BSEyjzdcSdSfvVIb2srLbXCUg5c6MM6egqzhEqKqmg//8MTDjJ\nf53hZ48iaKl2M8cB3IMhIw3Mtk/fCNR++Ygys9gjGEZQdf5kSzTW9pNZAoGAX9H/\nkw98OZeHyWouQnUA0xUhRez1rd0XkHpVChhTnPP+QdlRSJdSDnwWwWnJzBMq02Ld\nXmtSXNC6IpvrsiiDnKQHRcSgBkWK0iKdEexDo1b79YmsV5sjLwNt38FsbzvxLHlv\n5v8Hc3mDHkO7+M+l6TQS13DtnoLjVXnpcsc9qoECgYAl9uoNRnJFHgxlKQ2nkto1\n7ThAQ/sULYKTiPVGjfzNANlnDkawUcLKJKsVkRKJAatr5YDjGiDw2NL1NcfHEWy3\nk56tZCu8Lsws5mJjRR7V8p+foiOh/Kbm1cAfs0sWaxLvAMo3U+LTerIJaKElm4AH\nOOfn8hf0yNqtxoYFhwtQVA==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-ckij5@toy-sells-project-id.iam.gserviceaccount.com",
      "client_id": "106876130027940433104",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-ckij5%40toy-sells-project-id.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    final credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();
    return credentials.accessToken.data;
  }

  Future<void> updateFcmToken(String userId) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'fcmToken': fcmToken,
          'updatedAt': FieldValue.serverTimestamp(),
          // Optional: track the update time
        });
        print("FCM token updated successfully for user $userId");
      } else {
        print("FCM token is null");
      }
    } catch (e) {
      print("Error updating FCM token: $e");
    }
  }

  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print("Background Notification: ${message.notification?.title}");

    handleNotificationClick(message.data['key']);
  }

  static void handleNotificationClick(String type) {
    // var controller = Get.put(NavBarController());
    // var homeController = Get.put(HomePageController());
    // switch (type) {
    //   case 'friendPage':
    //     Get.toNamed(RoutesName.homePage);
    //     var friendController = Get.put(FriendsPageController());
    //     controller.changeTab(1);
    //     Future.wait([
    //       friendController.loadFriends(),
    //       friendController.loadFriendRequests(),
    //     ]).then((value) {
    //       friendController.selectedTabIndex = 0;
    //       friendController.update();
    //     },);
    //
    //     break;
    //   case 'friendPagePendingRequest':
    //     Get.toNamed(RoutesName.homePage);
    //     var friendController = Get.put(FriendsPageController());
    //     controller.changeTab(1);
    //     friendController.selectedTabIndex = 1;
    //     friendController.loadFriendRequests();
    //     friendController.update();
    //     break;
    //   case 'notification':
    //     Get.toNamed(RoutesName.homePage);
    //     controller.changeTab(0);
    //     FriendsPageController friendsPageController = Get.put(FriendsPageController()..loadAppraisalMessages());
    //     friendsPageController.showAppraisalSheet();
    //     break;
    //   default:
    //     print("Unknown notification type: $type");
    // }
  }
}
