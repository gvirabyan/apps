import 'package:flutter/material.dart';
import 'package:sellermultivendor/Localization/Demo_Localization.dart';

extension STREXT on String {
  double toDouble() {
    return double.tryParse(this) ?? 0;
  }

  int toInt() {
    return int.tryParse(this) ?? 0;
  }

  String firstUpperCase() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String translate({required final BuildContext context}) =>
      (AppLocalization.of(context)!.getTranslatedValues(this) ?? this).trim();

  // String translate(BuildContext context) {
  //   return   this) ?? this;
  // }

  String replaceUnderscores() {
    StringBuffer buffer = StringBuffer();
    int length = toString().length;
    for (var i = 0; i < length; i++) {
      String current = this[i];
      if (current == '_') {
        if (i + 1 < length) {
          buffer.write(' ');
          buffer.write(this[++i].toUpperCase());
        }
      } else {
        buffer.write(current);
      }
    }
    return buffer.toString();
  }
}
