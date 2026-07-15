import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/firebase_notification.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:sellermultivendor/Provider/pushNotificationProvider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Screen/DeshBord/dashboard.dart';
import 'package:sellermultivendor/Screen/OrderList/order_details_screen.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import 'package:sellermultivendor/Widget/sharedPreferances.dart';

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
          onTapNotification: onTapNotification);
  static final AwesomeNotifications notification = AwesomeNotifications();

  // static void setDeviceToken(
  //     {bool clearSessionToken = false, SettingProvider? settingProvider}) {
  //   if (clearSessionToken) {
  //     settingProvider ??= Provider.of<SettingProvider>(context, listen: false);
  //   }
  //   FirebaseMessaging.instance.getToken().then((token) async {
  //     print("fcmtoken----->${token}");
  //     if ((getSessionValue(FCMTOKEN) ?? '').toString().trim() != token) {
  //       var parameter = {
  //         FCMID: token,
  //         'device_type': Platform.isAndroid ? 'android' : 'ios',
  //       };
  //       apiBaseHelper.postAPICall(updateFcmApi, parameter).then(
  //         (getdata) async {
  //           if (getdata['error'] == false) {
  //             setPrefrence(FCMTOKEN, token!);
  //           }
  //         },
  //         onError: (error) {},
  //       );
  //     }
  //   });
  // }

  static void setDeviceToken(
      {bool clearSessionToken = false, SettingProvider? settingProvider}) {
    if (clearSessionToken) {
      settingProvider ??= Provider.of<SettingProvider>(context, listen: false);
      setPrefrence(FCMTOKEN, '');
    }
    FirebaseMessaging.instance.getToken().then((token) async {
      log('🔔 [PushInit] FCM token = $token');
      if (token != null) {
        log('🔔 [PushInit] registering token to backend...');
        context.read<PushNotificationProvider>().registerToken(token, context);
      } else {
        log('🔔 [PushInit] FCM token is NULL ❌');
      }
    }).catchError((e, st) {
      log('🔔 [PushInit] getToken ERROR ❌: $e\n$st');
    });
  }

  static void init() async {
    log('🔔 [PushInit] init() START | already initialized=$initialized');
    try {
      log('🔔 [PushInit] step 1: FirebaseNotificationManager.init()...');
      await _firebaseNotificationManager.init();
      log('🔔 [PushInit] step 1 DONE');

      log('🔔 [PushInit] step 2: requestPermission()...');
      await requestPermission();
      log('🔔 [PushInit] step 2 DONE');

      log('🔔 [PushInit] step 3: _initializeNotificationChannels()...');
      _initializeNotificationChannels();
      log('🔔 [PushInit] step 3 DONE');

      log('🔔 [PushInit] step 4: setListeners()...');
      notification.setListeners(
          onActionReceivedMethod: _awesomeNotificationTapListener);
      log('🔔 [PushInit] step 4 DONE');

      initialized = true;
      log('🔔 [PushInit] step 5: setDeviceToken()...');
      setDeviceToken();
      log('🔔 [PushInit] init() COMPLETE ✅');
    } catch (e, st) {
      log('🔔 [PushInit] init() FAILED ❌: $e\n$st');
    }
  }

  static void onMessageOpenedAppListener(
    RemoteMessage remoteMessage,
  ) {
    onTapNotification(remoteMessage.data);
  }

  static void _initializeNotificationChannels() {
    log('🔔 [PushInit] initializing awesome_notifications with icon resource://mipmap/ic_launcher');
    notification
        .initialize('resource://mipmap/ic_launcher', [
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
    ]).then((created) {
      log('🔔 [PushInit] awesome_notifications.initialize result=$created');
    }).catchError((e, st) {
      log('🔔 [PushInit] awesome_notifications.initialize ERROR ❌: $e\n$st');
      return false;
    });
  }

  @pragma("vm:entry-point")
  static Future<void> _awesomeNotificationTapListener(
      ReceivedAction action) async {
    log('Action is a ${action}');
    if (Platform.isIOS) {
      return;
    }
    onTapNotification(action.payload ?? {});
  }

  static Future<void> requestPermission() async {
    final NotificationSettings settings =
        await FirebaseMessaging.instance.getNotificationSettings();
    log('🔔 [PushInit] FCM authorizationStatus = ${settings.authorizationStatus}');

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      log('🔔 [PushInit] requesting awesome_notifications permissions...');
      await notification.requestPermissionToSendNotifications(
          channelKey: generalNotificationChannel,
          permissions: _requiredPermissionGroup);
      await notification.requestPermissionToSendNotifications(
          channelKey: chatNotificationChannel,
          permissions: _requiredPermissionGroup);
      await notification.requestPermissionToSendNotifications(
          channelKey: imageNotificationChannel,
          permissions: _requiredPermissionGroup);
    }
    final allowed = await notification.isNotificationAllowed();
    log('🔔 [PushInit] isNotificationAllowed = $allowed');
  }

  static Future<void> createGeneralNotification(
      {String? title, String? body, Map<String, String>? payload}) async {
    if (!Platform.isIOS) {
      log('🔔 [PushMsg] createGeneralNotification | title=$title | body=$body');
      final shown = await notification.createNotification(
          content: NotificationContent(
              id: 0,
              channelKey: generalNotificationChannel,
              title: title,
              body: body,
              payload: payload ?? {},
              wakeUpScreen: true));
      log('🔔 [PushMsg] createGeneralNotification shown=$shown');
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
    log('🔔 [PushMsg] FOREGROUND received | data=${notification.data} | notif=${notification.notification?.title}/${notification.notification?.body}');
    handleNotification(notification);
  }

  @pragma("vm:entry-point")
  static Future<void> backgroundNotification(RemoteMessage notification) async {
    log('🔔 [PushMsg] BACKGROUND received | data=${notification.data} | notif=${notification.notification?.title}/${notification.notification?.body}');
    handleBackgroundMessage(notification);
    setPrefrenceBool(iSFROMBACK, true);
  }

  static Future<void> handleNotification(RemoteMessage notification) async {
    handleBackgroundMessage(notification);
  }

  static void onTapNotification(Map<String, dynamic> data) async {
    _navigation(Map<String, String>.from(data));
    setPrefrenceBool(iSFROMBACK, false);
  }

  static void handleBackgroundMessage(RemoteMessage notification) {
    print(notification.data);
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

  static _navigation(Map<String, String> data) async {
    var orderId = data['order_id'] ?? '';
    if (orderId != '') {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => OrderDetailsScreen(
            id: orderId,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => const Dashboard()),
      );
    }
  }
}
