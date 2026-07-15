import 'package:flutter/material.dart';
import '../../../../../../Provider/settingProvider.dart';
import '../../../../Add_Product.dart';
import '../../../variantProductDimensionField.dart';

class VariantProductPrice extends StatelessWidget {
  final int pos;
  const VariantProductPrice({
    super.key,
    required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    return VariantProductDimensionField(
      label: "PRICE_LBL",
      initialValue: addProvider!.variationList[pos].price ?? '',
      onChanged: (String? value) {
        addProvider!.variationList[pos].price = value;
      },
      width: width,
      height: height,
    );
  }
}
