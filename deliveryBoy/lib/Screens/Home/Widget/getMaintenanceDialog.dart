import 'package:deliveryboy_multivendor/Helper/assetsConstant.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../Helper/constant.dart';
import '../../../Widget/dialogAnimate.dart';
import '../../../Widget/translateVariable.dart';

class AppMaintenanceDialog {
  static void appMaintenanceDialog(BuildContext context) async {
    await dialogAnimate(
      context,
      StatefulBuilder(
        builder: (
          BuildContext context,
          StateSetter setStater,
        ) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    circularBorderRadius5,
                  ),
                ),
              ),
              title: Text(
                APP_MAINTENANCE.translate(context: context),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Lottie.asset(Assets.appMaintenanceAnimation),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    MAINTENANCE_MESSAGE != ""
                        ? "$MAINTENANCE_MESSAGE"
                        : "$MAINTENANCE_DEFAULT_MESSAGE",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: textFontSize12,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
