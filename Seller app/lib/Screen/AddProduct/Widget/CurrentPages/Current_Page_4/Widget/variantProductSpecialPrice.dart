import 'package:flutter/material.dart';
import '../../../../../../Provider/settingProvider.dart';
import '../../../../Add_Product.dart';
import '../../../variantProductDimensionField.dart';

class VariantProductSpecialPrice extends StatelessWidget {
  final int pos;
  const VariantProductSpecialPrice({
    super.key,
    required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    return VariantProductDimensionField(
      label: "Special Price",
      initialValue: addProvider!.variationList[pos].disPrice ?? '',
      onChanged: (String? value) {
        addProvider!.variationList[pos].disPrice = value;
      },
      width: width,
      height: height,
    );
  }
}
