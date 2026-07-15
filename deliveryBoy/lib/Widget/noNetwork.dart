import 'package:deliveryboy_multivendor/Helper/assetsConstant.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Widget/translateVariable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../Helper/color.dart';
import 'ButtonDesing.dart';
import 'desing.dart';

Widget noInternet(
  BuildContext context,
  setStateNoInternate,
  Animation<dynamic>? buttonSqueezeanimation,
  AnimationController? buttonController,
) {
  return Center(
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: TRY_AGAIN_INT_LBL.translate(context: context),
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: setStateNoInternate,
          )
        ],
      ),
    ),
  );
}

noIntImage() {
  return SvgPicture.asset(
    DesignConfiguration.setSvgPath(Assets.noInternet),
    fit: BoxFit.contain,
    // color: primary,
  );
}

noIntText(BuildContext context) {
  return Container(
    child: Text(
      NO_INTERNET.translate(context: context),
      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: primary,
            fontWeight: FontWeight.normal,
          ),
    ),
  );
}

noIntDec(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
    child: Text(
      NO_INTERNET_DISC.translate(context: context),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: lightBlack2,
            fontWeight: FontWeight.normal,
          ),
    ),
  );
}
