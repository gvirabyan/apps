import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';

class CommonField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final bool isObscureText;
  final TextInputType? keyboardType;

  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final bool? isEnabled;
  final Function(String)? onchanged;
  final String? Function(String?)? validator;
  final int? maxErrorLines;
  final int? maxlines;

  const CommonField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.isObscureText,
      this.suffixIcon,
      this.isEnabled,
      this.onchanged,
      this.keyboardType,
      this.validator,
      this.maxlines,
      this.inputFormatters,
      this.maxErrorLines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.next,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: isObscureText,

        maxLines: maxlines,
        decoration: InputDecoration(
            hintText: labelText,
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
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: black.withValues(alpha: 0.1)),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
            ),
            border: InputBorder.none),
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        enabled: isEnabled,
        // ignore: prefer_if_null_operators
        validator: validator == null
            ? (val) {
                if (val == null || val.isEmpty) {
                  return '${'FIELD_REQUIRED'.translate(context: context)} ${labelText?.trim()}';
                }
                return null;
              }
            : validator,
        onChanged: onchanged,
      ),
    );
  }
}

class CommonText extends StatelessWidget {
  final String text;
  const CommonText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: black,
            ),
      ),
    );
  }
}
