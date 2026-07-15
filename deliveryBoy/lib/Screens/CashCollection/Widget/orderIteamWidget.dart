import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:flutter/material.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Model/cash_collection_model.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../cash_collection.dart';

class OrderItem extends StatelessWidget {
  final int index;
  OrderItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CashColl_Model model = cashCollectionProvider!.cashList[index];

    Color back;
    if (model.type == "Collected") {
      back = Colors.green;
    } else {
      back = pink;
    }
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 15.0,
        end: 15.0,
        bottom: 10.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularBorderRadius5)),
          color: white,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(circularBorderRadius5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (model.orderId! != "" && model.orderId! != "")
                      Text(
                        "ID".translate(context: context) +
                            " : " +
                            model.orderId!,
                      )
                    else
                      Text(
                        ID_LBL.translate(context: context) + " : " + model.id!,
                      ),
                    const Spacer(),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                          color: back,
                          borderRadius: const BorderRadius.all(
                              Radius.circular(circularBorderRadius5))),
                      child: Text(
                        StringValidation.capitalize(model.type!),
                        style: const TextStyle(color: white),
                      ),
                    )
                  ],
                ),
                const Divider(),
                Text("DATE".translate(context: context) + " : " + model.date!),
                Text(
                  MSG_LBL.translate(context: context) + " : " + model.message!,
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      AMT_LBL.translate(context: context),
                      style: const TextStyle(
                        color: black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DesignConfiguration.getPriceFormat(
                        context,
                        double.parse(
                          model.amount!,
                        ),
                      )!,
                      style: const TextStyle(
                        color: black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
