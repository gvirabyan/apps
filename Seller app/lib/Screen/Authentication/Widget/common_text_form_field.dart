import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String hintText;
  final Widget? prefixIcon;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final Color fillColor;
  final Color borderColor;
  final double borderRadius;
  final int? maxLength;
  final int? maxLines;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? suffixIcon;

  const CommonTextFormField({
    super.key,
    required this.controller,
    this.focusNode,
    this.onFieldSubmitted,
    this.validator,
    this.onSaved,
    required this.hintText,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.inputFormatters,
    this.textInputAction = TextInputAction.next,
    this.fillColor = const Color(0xFFF5F5F5),
    this.borderColor = const Color(0xFF000000),
    this.borderRadius = 7.0,
    this.maxLength,
    this.maxLines = 1,
    this.hintStyle,
    this.contentPadding,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: hintStyle,
        filled: true,
        fillColor: fillColor,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 40, maxHeight: 20),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor.withValues(alpha: 0.1)),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        border: InputBorder.none,
      ),
    );
  }
}
