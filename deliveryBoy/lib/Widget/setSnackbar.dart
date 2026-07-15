import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../Helper/color.dart';

setSnackbar(String msg, BuildContext context) {
  return showToast(msg,
      fullWidth: true,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.slideToBottom,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 2),
      curve: Curves.elasticOut,
      reverseCurve: Curves.linear,
      borderRadius: BorderRadius.circular(10.0),
      backgroundColor: black.withValues(alpha: 0.8),
      textStyle: TextStyle(color: white));
}
