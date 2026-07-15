import 'package:flutter/material.dart';
import '../../../../../../Provider/settingProvider.dart';
import '../../../../Add_Product.dart';
import '../../../variantProductDimensionField.dart';

class VariantProductBreadth extends StatelessWidget {
  final int pos;

  const VariantProductBreadth({
    super.key,
    required this.pos,
  });

  @override
  Widget build(BuildContext context) {
    return VariantProductDimensionField(
      label: "Breadth (cms)",
      initialValue: addProvider!.variationList[pos].breadth ?? '',
      onChanged: (String? value) {
        addProvider!.variationList[pos].breadth = value;
      },
      width: width,
      height: height,
    );
  }
}
