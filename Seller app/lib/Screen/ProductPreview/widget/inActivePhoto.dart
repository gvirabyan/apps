import 'package:flutter/material.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';

class InActivePhoto extends StatelessWidget {
  const InActivePhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 3.0,
        end: 3.0,
      ),
      child: Container(
        height: 8.0,
        width: 8.0,
        decoration: BoxDecoration(
          color: primary.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(circularBorderRadius5),
        ),
      ),
    );
  }
}
