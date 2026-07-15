import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sellermultivendor/Helper/assetsConstant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/dialogAnimate.dart';
import '../../../Widget/parameterString.dart';

void appMaintenanceDialog(BuildContext context) async {
  await dialogAnimate(
    context,
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setStater) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(circularBorderRadius5),
              ),
            ),
            title: Text(
              'APP_MAINTENANCE'.translate(context: context),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Lottie.asset(Assets.appMaintenanceAnimation),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  MAINTENANCE_MESSAGE != ''
                      ? '$MAINTENANCE_MESSAGE'
                      : 'MAINTENANCE_DEFAULT_MESSAGE'
                          .translate(context: context),
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
