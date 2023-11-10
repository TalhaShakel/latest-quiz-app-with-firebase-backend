import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quiz_app/pages/custom_notification_details.dart';
import 'package:quiz_app/utils/next_screen.dart';

import '../constants/constant.dart';
import '../models/notification_model.dart';
import '../utils/notification_dialog.dart';

class NotificationService {


  final FirebaseMessaging _fcm = FirebaseMessaging.instance;


  Future _handleNotificationPermissaion () async {
    NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        debugPrint('User granted provisional permission');
      } else {
        debugPrint('User declined or has not accepted permission');
      }
  }





  Future initFirebasePushNotification(context) async {
    await _handleNotificationPermissaion();
    String? token = await _fcm.getToken();
    debugPrint('User FCM Token : $token}');

    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    debugPrint('inittal message : $initialMessage');
    if (initialMessage != null) {
      await _saveNotificationData(initialMessage).then((value) => _navigateToDetailsScreen(context, initialMessage));
    }
    

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint('onMessage: ${message.data}');
      await _saveNotificationData(message).then((value) => _handleOpenNotificationDialog(context, message));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint('onMessageOppn: ${message.data}');
      await _saveNotificationData(message).then((value) => _navigateToDetailsScreen(context, message));
    });
  }



  Future _handleOpenNotificationDialog(context, RemoteMessage message) async {
    NotificationModel notificationModel = NotificationModel(
      id: message.messageId,
      date: DateTime.now(),
      body: message.data['description'] ?? '',
      title: message.notification!.title,
    );
    debugPrint(message.sentTime.toString());
    openNotificationDialog(context, notificationModel);
  }


  Future _navigateToDetailsScreen(context, RemoteMessage message) async {
    NotificationModel notificationModel = NotificationModel(
        id: message.messageId,
        date: DateTime.now(),
        title: message.notification!.title,
        body: message.data['description'] ?? '',
    );
    NextScreen.nextScreenNormal(context, CustomNotificationDeatils(notificationModel: notificationModel,));
  }



  Future _saveNotificationData(RemoteMessage message) async {
    final list = Hive.box(Constants.notificationTag);
    Map<String, dynamic> notificationData = {
      'id': message.messageId,
      'date': DateTime.now(),
      'title': message.notification!.title,
      'body': message.data['description'] ?? '',
    };

    await list.put(message.messageId, notificationData);
  }



  Future deleteNotificationData(key) async {
    final notificationList = Hive.box(Constants.notificationTag);
    await notificationList.delete(key);
  }



  Future deleteAllNotificationData() async {
    final notificationList = Hive.box(Constants.notificationTag);
    await notificationList.clear();
  }

  Future<bool?> checkingPermisson ()async{
    bool? accepted;
    await _fcm.getNotificationSettings().then((NotificationSettings settings)async{
      if(settings.authorizationStatus == AuthorizationStatus.authorized || settings.authorizationStatus == AuthorizationStatus.provisional){
        accepted = true;
      }else{
        accepted = false;
      }
    });
    return accepted;
  }

  Future subscribe ()async{
    await _fcm.subscribeToTopic(Constants.fcmSubcriptionTopticforAll);
  }

  Future unsubscribe ()async{
    await _fcm.unsubscribeFromTopic(Constants.fcmSubcriptionTopticforAll);
  }


}