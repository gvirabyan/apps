import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Helper/extensions/extensions.dart';
import 'getCommannWidget.dart';

class VariantInputField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final Function(String?) onChanged;
  final TextInputType keyboardType;
  final bool useUnderlineBorder;
  final double? height;
  final double? width;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;

  const VariantInputField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.useUnderlineBorder = false,
    this.height,
    this.width,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getPrimaryCommanText(label.translate(context: context), true),
          Container(
            height: height ?? (MediaQuery.of(context).size.height * 0.06),
            width: width,
            padding: const EdgeInsets.only(),
            child: TextFormField(
              keyboardType: keyboardType,
              initialValue: initialValue ?? '',
              style: const TextStyle(
                color: black,
                fontWeight: FontWeight.normal,
              ),
              focusNode: focusNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: onFieldSubmitted,
              onChanged: onChanged,
              decoration: InputDecoration(
                filled: true,
                fillColor: white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                prefixIconConstraints:
                    const BoxConstraints(minWidth: 40, maxHeight: 20),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: black,
                  ),
                  borderRadius: BorderRadius.circular(circularBorderRadius7),
                ),
                enabledBorder: useUnderlineBorder
                    ? UnderlineInputBorder(
                        borderSide: const BorderSide(color: grey2),
                        borderRadius:
                            BorderRadius.circular(circularBorderRadius8),
                      )
                    : OutlineInputBorder(
                        borderSide: const BorderSide(color: grey2),
                        borderRadius:
                            BorderRadius.circular(circularBorderRadius8),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
