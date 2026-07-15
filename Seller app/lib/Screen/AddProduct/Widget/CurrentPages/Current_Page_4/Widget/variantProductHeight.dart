import 'package:flutter/material.dart';
import '../../../../../../Provider/settingProvider.dart';
import '../../../../Add_Product.dart';
import '../../../variantProductDimensionField.dart';

class VariantProductHeight extends StatelessWidget {
  final int pos;
  const VariantProductHeight({
    super.key,
    required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    return VariantProductDimensionField(
      label: "Height (cms)",
      initialValue: addProvider!.variationList[pos].height ?? '',
      onChanged: (String? value) {
        addProvider!.variationList[pos].height = value;
      },
      width: width,
      height: height,
    );
  }
}
