import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:flutter/material.dart';
import '../../../Widget/translateVariable.dart';

String? validateField(String? value, BuildContext context) {
  if (value!.isEmpty) {
    return   FIELD_REQUIRED.translate(context: context);
  } else {
    return null;
  }
}