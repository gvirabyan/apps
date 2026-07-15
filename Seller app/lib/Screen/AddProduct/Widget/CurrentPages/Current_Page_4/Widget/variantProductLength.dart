import 'package:flutter/material.dart';
import '../../../../../../Provider/settingProvider.dart';
import '../../../../Add_Product.dart';
import '../../../variantProductDimensionField.dart';

class VariantProductLength extends StatelessWidget {
  final int pos;

  const VariantProductLength({
    super.key,
    required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    return VariantProductDimensionField(
      label: "Length (cms)",
      initialValue: addProvider!.variationList[pos].length ?? '',
      onChanged: (String? value) {
        addProvider!.variationList[pos].length = value;
      },
      width: width,
      height: height,
    );
  }
}
