import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Widget/desing.dart';

class GetRowFields extends StatelessWidget {
  final String title;
  final String value;
  final bool simple;
  const GetRowFields({
    super.key,
    required this.value,
    required this.title,
    required this.simple,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: title == "${'Final Total'.translate(context: context)} : " ||
                    title ==
                        "Grand Final Total :".translate(context: context) ||
                    title == "${"ID_LBL".translate(context: context)} - "
                ? Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: black,
                      fontWeight: FontWeight.w400,
                      fontFamily: "PlusJakartaSans",
                      fontStyle: FontStyle.normal,
                      fontSize: textFontSize14,
                    )
                : Theme.of(context).textTheme.labelLarge!.copyWith(
                      color: grey3,
                      fontWeight: FontWeight.w400,
                      fontFamily: "PlusJakartaSans",
                      fontStyle: FontStyle.normal,
                      fontSize: textFontSize14,
                    ),
          ),
          Text(
            () {
              if (simple) {
                return value;
              } else {
                return DesignConfiguration.getPriceFormat(
                  context,
                  double.parse(value),
                )!;
              }
            }(),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: title ==
                              "${'Final Total'.translate(context: context)} : " ||
                          title ==
                              "Grand Final Total :"
                                  .translate(context: context) ||
                          title == "${"ID_LBL".translate(context: context)} - "
                      ? black
                      : grey,
                  fontWeight: FontWeight.w400,
                  fontFamily: "PlusJakartaSans",
                  fontStyle: FontStyle.normal,
                  fontSize: textFontSize14,
                ),
          ),
        ],
      ),
    );
  }
}
