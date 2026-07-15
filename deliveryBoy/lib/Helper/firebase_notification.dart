

import 'dart:developer';

import 'package:deliveryboy_multivendor/Helper/push_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationManager {
  final Future<void> Function(RemoteMessage message)? foregroundMessageHandler;
  final void Function(Map<String, dynamic> payload)? onTapNotification;
  FirebaseNotificationManager({
    this.foregroundMessageHandler,
    this.onTapNotification,
  });

  Future<void> init() async {
    log('[PUSH] FirebaseNotificationManager.init() START',
        name: 'PushNotification');
    FirebaseMessaging.onBackgroundMessage(
        PushNotificationService.backgroundNotification);

    RemoteMessage? value = await FirebaseMessaging.instance.getInitialMessage();
    log('[PUSH] getInitialMessage = ${value?.data}', name: 'PushNotification');
    if (value != null) {
      onTapNotification?.call(value.data);
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      log('[PUSH] onMessage fired', name: 'PushNotification');
      foregroundMessageHandler?.call(event);
    });

    //This will listen onTap so we are making it external function so we can manage taps from one method of awesome and local notification
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      log('[PUSH] onMessageOpenedApp fired', name: 'PushNotification');
      onTapNotification?.call(event.data);
    });
    log('[PUSH] FirebaseNotificationManager.init() END',
        name: 'PushNotification');
  }
}
