import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Helper/push_notification_service.dart';
import 'package:deliveryboy_multivendor/Repository/NotificationRepository.dart';
import 'package:deliveryboy_multivendor/Widget/parameterString.dart';
import 'package:deliveryboy_multivendor/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Widget/translateVariable.dart';
import '../../Authentication/LoginScreen.dart';
import '../home.dart';
import 'dart:io';

class LogOutDialog {
  static logOutDailog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(circularBorderRadius5),
                ),
              ),
              content: Text(
                LOGOUTTXT.translate(context: context),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: black),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    LOGOUTNO.translate(context: context),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: lightBlack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text(
                    LOGOUTYES.translate(context: context),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    PushNotificationService.context = context;
                    final fcmId = globalSettingsProvider?.fcmId;
                    print("fcmid---->${fcmId}");
                    NotificationRepository.updateFcmID(
                      parameter: {
                        FCM_ID: fcmId,
                        'device_type': Platform.isAndroid ? 'android' : 'ios',
                        'is_logout': '1',
                      },
                    );
                    settingProvider!.clearUserSession(context);
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(builder: (context) => Login()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
