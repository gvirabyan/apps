import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/constant.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Widget/desing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class TextFieldContainer extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String labelText;
  final bool isObscureText;
  final String icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final bool isEnabled;
  final String? Function(String?)? validator;
  final int? maxErrorLines;

  const TextFieldContainer({
    Key? key,
    required this.controller,
    this.focusNode,
    required this.labelText,
    required this.isObscureText,
    required this.icon,
    this.keyboardType,
    this.inputFormatters,
    this.suffixIcon,
    this.isEnabled = true,
    this.validator,
    this.maxErrorLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: isObscureText,
        decoration: InputDecoration(
            prefixIcon: SvgPicture.asset(
              DesignConfiguration.setSvgPath(icon),
              fit: BoxFit.scaleDown,
              colorFilter:
                  const ColorFilter.mode(Colors.amber, BlendMode.srcIn),
            ),
            hintText: labelText.translate(context: context),
            hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: lightBlack2,
                  fontWeight: FontWeight.normal,
                ),
            filled: true,
            fillColor: lightWhite.withValues(alpha: 0.4),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            errorMaxLines: maxErrorLines,
            suffixIcon: suffixIcon,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              maxHeight: 20,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            border: InputBorder.none),
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        enabled: isEnabled,
        validator: validator == null
            ? (val) {
                if (val == null || val.isEmpty) {
                  return '${'PLZ_ENTER_LBL'.translate(context: context)} ${labelText.trim()}';
                }
                // You can add custom validation here if needed
                return null;
              }
            : validator,
      ),
    );
  }
}
