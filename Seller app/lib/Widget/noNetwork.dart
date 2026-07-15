import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sellermultivendor/Helper/assetsConstant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import '../Helper/Color.dart';
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
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
            child: AppBtn(
              title: "TRY_AGAIN_INT_LBL".translate(context: context),
              btnAnim: buttonSqueezeanimation,
              btnCntrl: buttonController,
              onBtnSelected: setStateNoInternate,
            ),
          )
        ],
      ),
    ),
  );
}

noIntImage() {
  return SvgPicture.asset(
    DesignConfiguration.setNewSvgPath(Assets.noInternet),
    fit: BoxFit.contain,
    // color: primary,
  );
}

noIntText(BuildContext context) {
  return Text(
    "NO_INTERNET".translate(context: context),
    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
          color: primary,
          fontWeight: FontWeight.normal,
        ),
  );
}

noIntDec(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
    child: Text(
      "NO_INTERNET_DISC".translate(context: context),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: lightBlack2,
            fontWeight: FontWeight.normal,
          ),
    ),
  );
}
