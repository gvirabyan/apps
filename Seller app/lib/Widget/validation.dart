import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';

class StringValidation {
// product name velidatation

  static String? validateThisFieldRequired(
      String? value, BuildContext context) {
    if (value!.isEmpty) {
      return "This Field is Required!".translate(context: context);
    }
    return null;
  }

// password verification

  static String? validatePass(String? value, BuildContext context,
      {required bool onlyRequired}) {
    if (onlyRequired) {
      if (value!.isEmpty) {
        return "PWD_REQUIRED".translate(context: context);
      } else {
        return null;
      }
    } else {
      if (value!.isEmpty) {
        return "PWD_REQUIRED".translate(context: context);
      } else if (!RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_.?=^`-]).{8,}$')
          .hasMatch(value)) {
        return 'PASSWORD_VALIDATION'.translate(context: context);
      } else {
        return null;
      }
    }
  }

//email validation
  static String? validateEmail(String value, BuildContext context) {
    if (value.isEmpty) {
      return "EMAIL_REQUIRED".translate(context: context);
    } else if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)"
            r'*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+'
            r'[a-z0-9](?:[a-z0-9-]*[a-z0-9])?')
        .hasMatch(value)) {
      return "ENTER_VALID_EMAIL_ADDRESS".translate(context: context);
    } else {
      return null;
    }
  }

// sort detail velidatation

  static String? sortdescriptionvalidate(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return "SORT_DESCRIPTION_REQUIRED".translate(context: context);
    }
    if (value.length < 3) {
      return "MINIMAM_5_CHARACTER_REQUIRED".translate(context: context);
    }
    return null;
  }

// product name velidatation

  static String? validateProduct(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return "ProductNameRequired".translate(context: context);
    }
    if (value.length < 3) {
      return 'Please Add Valid Product name'.translate(context: context);
    }
    return null;
  }

//mobile verification

  static String? validateMob(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return "MOB_REQUIRED".translate(context: context);
    }
    /* if (value.length < 5) {
      return   "VALID_MOB");
    }*/
    return null;
  }

// command for many fields

  static String? validateField(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return "FIELD_REQUIRED".translate(context: context);
    } else {
      return null;
    }
  }

// name validation

  static String? validateUserName(String? value, BuildContext context) {
    if (value!.isEmpty) {
      return "USER_REQUIRED".translate(context: context);
    }
    if (value.length <= 1) {
      return "USER_LENGTH".translate(context: context);
    }
    return null;
  }

  static String capitalize(String s) {
    if (s == "") {
      return "";
    } else {
      return s[0].toUpperCase() + s.substring(1);
    }
  }
}

// // for the translation of string
// String? getTranslated(BuildContext context, String key) {
//   return DemoLocalization.of(context)!.translate(key) ?? key;
// }
