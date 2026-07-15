import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Repository/NotificationRepository.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import 'package:sellermultivendor/main.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/sharedPreferances.dart';
import '../../Authentication/Login.dart';

logOutDailog(BuildContext context) async {
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
              "LOGOUTTXT".translate(context: context),
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(color: primary),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "LOGOUTNO".translate(context: context),
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
                  "LOGOUTYES".translate(context: context),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  final fcmId = globalSettingsProvider?.fcmId;
                  print("fcmid---->${fcmId}");
                  NotificationRepository.updateFcmID(
                    parameter: {
                      FCMID: fcmId,
                      'device_type': Platform.isAndroid ? 'android' : 'ios',
                      'is_logout': '1',
                    },
                  );
                  clearUserSession(context);
                  Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(builder: (context) => const Login()),
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
