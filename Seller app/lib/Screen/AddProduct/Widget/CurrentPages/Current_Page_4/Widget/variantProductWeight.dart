import 'package:flutter/material.dart';
import '../../../../Add_Product.dart';
import '../../../../../../Provider/settingProvider.dart';
import '../../../variantProductDimensionField.dart';

class VariantProductWeight extends StatelessWidget {
  final int pos;

  const VariantProductWeight({
    super.key,
    required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    return VariantProductDimensionField(
      label: "Weight (kg)",
      initialValue: addProvider!.variationList[pos].weight ?? '',
      onChanged: (String? value) {
        addProvider!.variationList[pos].weight = value;
      },
      width: width,
      height: height,
    );
  }
}
