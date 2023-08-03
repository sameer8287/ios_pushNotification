import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ios_push_notification/model/push_notification_model.dart';
import 'package:ios_push_notification/notification_badge.dart';
import 'package:overlay_support/overlay_support.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _totalNotifications;
  late final FirebaseMessaging _messaging;
  PushNotificaiton? _notificationInfo;

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    log("Handling a background message: ${message.messageId}");
  }

  void requestAndRegisterNotification() async {
    await Firebase.initializeApp();

    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true
    ); 

    if(settings.authorizationStatus ==AuthorizationStatus.authorized)
    {
      log('User granted Permission');
      String? token = await _messaging.getToken();
      log("The token is"+token!);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) { 

        PushNotificaiton notificaiton =PushNotificaiton(
          title: message.notification?.title,
          body: message.notification?.body
        ); 

        setState(() {
          _notificationInfo = notificaiton;
          _totalNotifications++;
        });      

        if(_notificationInfo != null)
        {
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.red,
            duration: Duration(seconds: 2)
          );
        }
      }
      );
    }

  }

  @override
  void initState() {
    
    _totalNotifications=0;
    requestAndRegisterNotification();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Ios_push_notification'),
      ),
    );
  }
}
