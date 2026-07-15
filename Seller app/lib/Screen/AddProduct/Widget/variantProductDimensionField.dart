import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import 'getCommanWidget.dart';

class VariantProductDimensionField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final void Function(String?) onChanged;
  final double width;
  final double height;

  const VariantProductDimensionField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getPrimaryCommanText(label.translate(context: context), true),
          SizedBox(
            width: width * 0.4,
            height: height * 0.06,
            child: TextFormField(
              keyboardType: TextInputType.number,
              initialValue: initialValue ?? '',
              style: const TextStyle(
                color: black,
                fontWeight: FontWeight.normal,
              ),
              textInputAction: TextInputAction.next,
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
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: grey2),
                  borderRadius: BorderRadius.circular(circularBorderRadius8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
