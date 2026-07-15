import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../SalesReport.dart';
import 'getRowFields.dart';

class GetGeneralDataShower extends StatelessWidget {
  const GetGeneralDataShower({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 15,
        right: 15,
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularBorderRadius7)),
          boxShadow: [
            BoxShadow(
              color: blarColor,
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          color: white,
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 18.0, right: 18, top: 18, bottom: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GetRowFields(
                title: "TOTAL_ORDERS".translate(context: context),
                value: salesProvider!.totalReports,
                simple: true,
              ),
              GetRowFields(
                title: "GRAND_TOTAL".translate(context: context),
                value: salesProvider!.totalDeliveryCharge,
                simple: false,
              ),
              GetRowFields(
                title: "TOTAL_DELIVERY_CHARGE".translate(context: context),
                value: salesProvider!.grandFinalTotal,
                simple: false,
              ),
              const Divider(),
              GetRowFields(
                title: "Grand Final Total :".translate(context: context),
                value: salesProvider!.grandTotal,
                simple: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
