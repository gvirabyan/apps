import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:deliveryboy_multivendor/Helper/constant.dart';
import 'package:deliveryboy_multivendor/Helper/firebase_notification.dart';
import 'package:deliveryboy_multivendor/Provider/SettingsProvider.dart';
import 'package:deliveryboy_multivendor/Widget/api.dart';
import 'package:deliveryboy_multivendor/Widget/parameterString.dart';
import 'package:deliveryboy_multivendor/Widget/security.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class PushNotificationService {
  static const String generalNotificationChannel = 'general_channel';
  static const String chatNotificationChannel = 'chat_channel';
  static const String imageNotificationChannel = 'image_channel';
  PushNotificationService();
  static late BuildContext context;

  static bool initialized = false;

  static final List<NotificationPermission> _requiredPermissionGroup = [
    NotificationPermission.Alert,
    NotificationPermission.Sound,
    NotificationPermission.Badge,
    NotificationPermission.Vibration,
    NotificationPermission.Light
  ];

  static final FirebaseNotificationManager _firebaseNotificationManager =
      FirebaseNotificationManager(
    foregroundMessageHandler: foregroundNotification,
  );
  static final AwesomeNotifications notification = AwesomeNotifications();

  static void _registerToken(String? token) async {
    log('[PUSH] _registerToken token=$token', name: 'PushNotification');
    if (token == null) return;
    final settingsProvider =
        Provider.of<SettingProvider>(context, listen: false);
    if (settingsProvider.fcmId?.trim() != token) {
      log('[PUSH] token changed, sending to updateFcmApi...',
          name: 'PushNotification');
      try {
        var parameter = {
          FCM_ID: token,
          'device_type': Platform.isAndroid ? 'android' : 'ios'
        };

        Response response =
            await post(updateFcmApi, body: parameter, headers: headers)
                .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        log('[PUSH] updateFcmApi response: ${response.statusCode} -> ${response.body}',
            name: 'PushNotification');
        if (getdata['error'] == false) {
          await settingsProvider.setFcmId(token);
          log('[PUSH] fcmId saved locally', name: 'PushNotification');
        }
      } catch (e, st) {
        log('[PUSH] _registerToken ERROR: $e',
            name: 'PushNotification', error: e, stackTrace: st);
      }
    } else {
      log('[PUSH] token unchanged, skip register', name: 'PushNotification');
    }
  }

  static Future<void> setDeviceToken(
      {bool clearSessionToken = false,
      SettingProvider? settingProvider}) async {
    if (clearSessionToken) {
      settingProvider ??= Provider.of<SettingProvider>(context, listen: false);
      settingProvider.setPrefrence(FCMTOKEN, '');
    }
    final token = await FirebaseMessaging.instance.getToken().catchError((e) {
      log('[PUSH] getToken ERROR: $e', name: 'PushNotification');
      return null;
    });
    log('[PUSH] FCM TOKEN: $token', name: 'PushNotification');
    if (token != null) {
      _registerToken(token);
    } else {
      log('[PUSH] token is NULL - cannot register',
          name: 'PushNotification');
    }
    // FirebaseMessaging.instance.getToken().then((token) async {
    //   _registerToken(token);
    // });
  }

  static void init() async {
    log('[PUSH] init() START', name: 'PushNotification');
    try {
      await _firebaseNotificationManager.init();
      log('[PUSH] firebaseNotificationManager.init() done',
          name: 'PushNotification');
      await requestPermission();
      log('[PUSH] requestPermission() done', name: 'PushNotification');
      _initializeNotificationChannels();
      log('[PUSH] notification channels initialized',
          name: 'PushNotification');
      notification.setListeners(
          onActionReceivedMethod: _awesomeNotificationTapListener);
      log('[PUSH] listeners set', name: 'PushNotification');

      // FirebaseMessaging.onMessage.listen(foregroundNotification);
      // FirebaseMessaging.onBackgroundMessage(backgroundNotification);

      // FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      //   onMessageOpenedAppListener(remoteMessage);
      // });
      initialized = true;
      setDeviceToken();
      log('[PUSH] init() END (initialized=$initialized)',
          name: 'PushNotification');
    } catch (e, st) {
      log('[PUSH] init() ERROR: $e',
          name: 'PushNotification', error: e, stackTrace: st);
    }
  }

  static void _initializeNotificationChannels() {
    notification.initialize('resource://mipmap/ic_launcher', [
      NotificationChannel(
          channelKey: generalNotificationChannel,
          channelName: 'General notifications',
          channelDescription: 'General channel to display notifications',
          importance: NotificationImportance.Max,
          playSound: true),
      NotificationChannel(
          channelKey: chatNotificationChannel,
          channelName: 'Chat Notifications',
          channelDescription: 'To display chat notification',
          importance: NotificationImportance.Max,
          playSound: true),
      NotificationChannel(
        channelKey: imageNotificationChannel,
        channelName: 'Image Notifications',
        channelDescription: 'To display images as notifications',
        importance: NotificationImportance.Max,
        playSound: true,
      )
    ]);
  }

  @pragma("vm:entry-point")
  static Future<void> _awesomeNotificationTapListener(
      ReceivedAction action) async {
    log('Action is a ${action}');
  }

  static Future<void> requestPermission() async {
    final NotificationSettings settings =
        await FirebaseMessaging.instance.getNotificationSettings();
    log('[PUSH] current authorizationStatus=${settings.authorizationStatus}',
        name: 'PushNotification');

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      log('[PUSH] requesting notification permissions...',
          name: 'PushNotification');
      await notification.requestPermissionToSendNotifications(
          channelKey: generalNotificationChannel,
          permissions: _requiredPermissionGroup);
      await notification.requestPermissionToSendNotifications(
          channelKey: chatNotificationChannel,
          permissions: _requiredPermissionGroup);
      await notification.requestPermissionToSendNotifications(
          channelKey: imageNotificationChannel,
          permissions: _requiredPermissionGroup);
      final allowed = await notification.isNotificationAllowed();
      log('[PUSH] after request, isNotificationAllowed=$allowed',
          name: 'PushNotification');
    } else {
      log('[PUSH] already authorized, skip request',
          name: 'PushNotification');
    }
  }

  static Future<void> createGeneralNotification(
      {String? title, String? body, Map<String, String>? payload}) async {
    log('[PUSH] createGeneralNotification (isIOS=${Platform.isIOS}) title=$title',
        name: 'PushNotification');
    if (!Platform.isIOS) {
      await notification.createNotification(
          content: NotificationContent(
              id: 0,
              channelKey: generalNotificationChannel,
              title: title,
              body: body,
              payload: payload ?? {},
              wakeUpScreen: true));
    }
  }

  static Future<void> createImageNotification({
    String? title,
    String? body,
    Map<String, String>? payload,
  }) async {
    if (!Platform.isIOS) {
      await notification.createNotification(
        content: NotificationContent(
            id: 0,
            channelKey: imageNotificationChannel,
            title: title,
            body: body,
            wakeUpScreen: true,
            largeIcon: payload?['image'],
            hideLargeIconOnExpand: true,
            notificationLayout: NotificationLayout.BigPicture,
            bigPicture: payload?['image'],
            payload: payload),
      );
    }
  }

  static Future<void> createChatNotification({
    String? title,
    String? body,
    Map<String, String>? payload,
  }) async {
    if (!Platform.isIOS) {
      await notification.createNotification(
        content: NotificationContent(
            id: 0,
            channelKey: chatNotificationChannel,
            title: title,
            body: body,
            wakeUpScreen: true,
            largeIcon: payload?['image'],
            hideLargeIconOnExpand: true,
            notificationLayout: NotificationLayout.BigPicture,
            bigPicture: payload?['image'],
            payload: payload),
      );
    }
  }

  static Future<void> foregroundNotification(RemoteMessage notification) async {
    log('[PUSH] >>> FOREGROUND message received', name: 'PushNotification');
    handleNotification(notification);
  }

  @pragma("vm:entry-point")
  static Future<void> backgroundNotification(RemoteMessage notification) async {
    log('[PUSH] >>> BACKGROUND message received', name: 'PushNotification');
    // await Firebase.initializeApp();
    // handleNotification(notification);
    handleBackgroundMessage(notification);
  }

  static Future<void> handleNotification(RemoteMessage notification) async {
    log('[PUSH] handleNotification', name: 'PushNotification');
    handleBackgroundMessage(notification);
  }

  static void handleBackgroundMessage(RemoteMessage notification) {
    log('[PUSH] message data: ${notification.data}', name: 'PushNotification');
    log('[PUSH] message notification: title=${notification.notification?.title}, body=${notification.notification?.body}',
        name: 'PushNotification');
    var image = notification.data['image'] ?? '';
    if (image != null && image != 'null' && image != '') {
      createImageNotification(
          body: notification.data['body'],
          title: notification.data['title'],
          payload: Map<String, String>.from(notification.data));
    } else {
      createGeneralNotification(
        title: notification.data['title'],
        body: notification.data['body'],
      );
    }
  }
}
