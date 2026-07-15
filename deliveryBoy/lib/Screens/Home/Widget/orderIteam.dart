import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Model/orderModel.dart';
import 'package:deliveryboy_multivendor/Widget/desing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';
import '../../../Widget/parameterString.dart';
import '../../../Widget/translateVariable.dart';
import '../../../Widget/validation.dart';
import '../../OrderDetail/order_detail.dart';
import '../home.dart';
import 'package:intl/intl.dart';

class OrderIteam extends StatelessWidget {
  final int index;
  final Function update;

  const OrderIteam({
    Key? key,
    required this.index,
    required this.update,
  }) : super(key: key);

  _launchCaller(index) async {
    var url = "tel:${homeProvider!.displayList[index].mobile}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    OrderModel model = homeProvider!.displayList[index];
    DateTime dateTime = DateTime.parse(model.createdDate!);
    String formattedDate = DateFormat('MMMM dd, yyyy').format(dateTime);
    Color back;
    if ((model.activeStatus) == DELIVERD)
      back = Colors.green.withValues(alpha: 0.85);
    else if ((model.activeStatus) == SHIPED)
      back = Colors.orange.withValues(alpha: 0.85);
    else if ((model.activeStatus) == CANCLED || model.activeStatus == RETURNED)
      back = Colors.red.withValues(alpha: 0.85);
    else if ((model.activeStatus) == PROCESSED)
      back = Colors.indigo.withValues(alpha: 0.85);
    else if (model.activeStatus == WAITING)
      back = Colors.black;
    else if (model.activeStatus == 'return_request_decline')
      back = Colors.red;
    else if (model.activeStatus == 'return_request_pending')
      back = Colors.indigo.withValues(alpha: 0.85);
    else
      back = Colors.cyan;
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 15,
        right: 15,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularBorderRadius5)),
          boxShadow: const [
            BoxShadow(
              color: blarColor,
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
          color: white,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(circularBorderRadius5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 08.0,
                  start: 21,
                  end: 12,
                  bottom: 00,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          "# ${model.id!}",
                          style: const TextStyle(color: black),
                        ),
                      ],
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
                        () {
                          if (model.activeStatus! == "delivered") {
                            return "delivered".translate(context: context);
                          } else if (model.activeStatus! == "cancelled") {
                            return "cancelled".translate(context: context);
                          } else if (model.activeStatus == "returned") {
                            return "returned".translate(context: context);
                          } else if (model.activeStatus! == "processed") {
                            return "processed".translate(context: context);
                          } else if (model.activeStatus == "shipped") {
                            return "shipped".translate(context: context);
                          } else if (model.activeStatus! == "received") {
                            return "received".translate(context: context);
                          } else if (model.activeStatus! ==
                              "return_request_pending") {
                            return "RETURN_REQUEST_PENDING_LBL"
                                .translate(context: context);
                          } else if (model.activeStatus! ==
                              "return_request_approved") {
                            return "RETURN_REQUEST_APPROVE_LBL"
                                .translate(context: context);
                          } else if (model.activeStatus! ==
                              "return_request_decline") {
                            return "RETURN_REQUEST_DECLINE_LBL"
                                .translate(context: context);
                          } else {
                            return StringValidation.capitalize(
                                model.activeStatus!);
                          }
                        }(),
                        style: const TextStyle(color: white),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ORDER_DETAIL.translate(context: context),
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: black,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PlusJakartaSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: textFontSize16,
                                  ),
                        ),
                        Text(
                          formattedDate,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: black,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "PlusJakartaSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: textFontSize14,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap:
                            true, // Allow the ListView to shrink to the size of its children
                        itemCount: model.consignmentItems!.length > 2
                            ? 2
                            : model.consignmentItems!.length,
                        itemBuilder: (context, index) {
                          print(
                              "productname--->${model.consignmentItems![index].productName!}");
                          return Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 5, // Adjust the size of the dot
                                color: Colors.black, // Customize the dot color
                              ),
                              SizedBox(
                                width: 8, // Add space between the dot and text
                              ),
                              Expanded(
                                child: Text(
                                  model.consignmentItems![index].productName!,
                                  maxLines: 1,
                                  overflow: TextOverflow
                                      .ellipsis, // Show "..." if text overflows
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    if (model.consignmentItems!.length > 2)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "View Order details",
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: primary,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "PlusJakartaSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: textFontSize14,
                                  ),
                        ),
                      ),
                    if (model.sellerDetails?.storeName != null &&
                        model.sellerDetails!.storeName!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Row(
                          children: [
                            const Icon(Icons.store_outlined,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                model.sellerDetails!.storeName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "PlusJakartaSans",
                                      fontSize: textFontSize13,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if ((model.city != null && model.city!.isNotEmpty) ||
                        (model.areaName != null && model.areaName!.isNotEmpty))
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                [
                                  if (model.areaName != null &&
                                      model.areaName!.isNotEmpty)
                                    model.areaName!,
                                  if (model.city != null &&
                                      model.city!.isNotEmpty)
                                    model.city!,
                                ].join(', '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "PlusJakartaSans",
                                      fontSize: textFontSize13,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          model.username!,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: black,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PlusJakartaSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: textFontSize16,
                                  ),
                        ),
                        Text(
                          DesignConfiguration.getPriceFormat(
                              context, double.parse(model.totalPayable!))!,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: primary,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PlusJakartaSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: textFontSize16,
                                  ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        model.mobile != ""
                            ? InkWell(
                                child: Text(
                                  "${model.mobile!}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: grey,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "PlusJakartaSans",
                                          fontStyle: FontStyle.normal,
                                          fontSize: textFontSize16,
                                          decoration: TextDecoration.underline),
                                ),
                                onTap: () {
                                  _launchCaller(index);
                                },
                              )
                            : Container(),
                        Text(
                          model.paymentMethod!,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: grey,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PlusJakartaSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: textFontSize16,
                                  ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          onTap: () async {
            await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => OrderDetail(
                  model: homeProvider!.displayList[index],
                ),
              ),
            ).then((value) {
              update();
            });
            homeProvider!.getUserDetail(update, context);
            update();
          },
        ),
      ),
    );
  }
}
