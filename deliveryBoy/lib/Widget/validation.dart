import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Widget/translateVariable.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';

class StringValidation {
  static String? validateUserName(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return USER_REQUIRED.translate(context: context);
    }
    if (value.length <= 1) {
      return USER_LENGTH.translate(context: context);
    }
    return null;
  }

  static String? validateMob(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return MOB_REQUIRED.translate(context: context);
    }
    if (value.length < 6 || value.length > 15) {
      return VALID_MOB.translate(context: context);
    }
    return null;
  }

  static String? validateField(String? value, BuildContext context) {
    if (value!.length == 0)
      return FIELD_REQUIRED.translate(context: context);
    else
      return null;
  }

  static String? validateEmail(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return 'EMAIL_REQUIRED'.translate(context: context);
    } else if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)"
            r'*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+'
            r'[a-z0-9](?:[a-z0-9-]*[a-z0-9])?')
        .hasMatch(value)) {
      return 'VALID_EMAIL'.translate(context: context);
    } else {
      return null;
    }
  }

  // static String? validatePass(String? value, BuildContext context) {
  //   if (value!.length == 0)
  //     return   PWD_REQUIRED)!;
  //   else if (value.length <= 5)
  //     return   PWD_LENGTH)!;
  //   else
  //     return null;
  // }

  static String? validatePass(String? value, BuildContext context,
      {required bool onlyRequired}) {
    if (onlyRequired) {
      if (value!.isEmpty) {
        return PWD_REQUIRED.translate(context: context);
      } else {
        return null;
      }
    } else {
      if (value!.isEmpty) {
        return PWD_REQUIRED.translate(context: context);
      } else if (!RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!%@#\$&*~_.?=^`-]).{8,}$')
          .hasMatch(value)) {
        return 'PASSWORD_VALIDATION'.translate(context: context);
      } else {
        return null;
      }
    }
  }

  static String? validateMobIntl(
      PhoneNumber? phoneNumber, BuildContext context) {
    if (phoneNumber == null || phoneNumber.number.isEmpty) {
      return MOB_REQUIRED.translate(context: context);
    }
    if (phoneNumber.number.length < 6 || phoneNumber.number.length > 16) {
      return VALID_MOB.translate(context: context);
    }
    return null;
  }

  static String? validateAltMob(String value, BuildContext context) {
    if (value.isNotEmpty) if (value.length < 9) {
      return VALID_MOB.translate(context: context);
    }
    return null;
  }

  static String capitalize(String s) {
    if (s == '') {
      return '';
    }
    return s[0].toUpperCase() + s.substring(1);
  }
}

// for the translation of string
// String? getTranslated(BuildContext context, String key) {
//   return DemoLocalization.of(context)!.translate(key) ?? key;
// }
