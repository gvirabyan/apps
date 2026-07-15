import 'dart:io';

import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/constant.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Model/ReturnOrderModel.dart';
import 'package:deliveryboy_multivendor/Widget/setSnackbar.dart';
import 'package:deliveryboy_multivendor/Widget/translateVariable.dart';
import 'package:deliveryboy_multivendor/Widget/validation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminDetails extends StatelessWidget {
  final ReturnOrderModel order;
  const AdminDetails({
    Key? key,
    required this.order,
  }) : super(key: key);

  void _launchCaller(
    String phoneNumber,
    BuildContext context,
  ) async {
    var url = "tel:$phoneNumber";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      setSnackbar('Could not launch $url', context);
      throw 'Could not launch $url';
    }
  }

  _launchMap(lat, lng) async {
    var url = '';
    if (Platform.isAndroid) {
      url =
          "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving&dir_action=navigate";
    } else {
      url =
          "http://maps.apple.com/?saddr=&daddr=$lat,$lng&directionsmode=driving&dir_action=navigate";
    }
    print("url string : ${url}");
    print("uri : ${Uri.parse(url)}");
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularBorderRadius5)),
          color: white,
          boxShadow: const [
            BoxShadow(
                color: blarColor,
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ADMIN_DETAILS.translate(context: context),
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: black,
                          fontWeight: FontWeight.w400,
                          fontFamily: "PlusJakartaSans",
                          fontStyle: FontStyle.normal,
                          fontSize: textFontSize16,
                        ),
                  ),
                  order.adminLatitude != "" && order.adminLongitude != ""
                      ? SizedBox(
                          height: 25,
                          child: IconButton(
                            icon: const Icon(
                              Icons.pin_drop_outlined,
                              color: primary,
                              size: 20,
                            ),
                            onPressed: () {
                              _launchMap(
                                order.adminLatitude,
                                order.adminLongitude,
                              );
                            },
                          ),
                        )
                      : Container()
                ],
              ),
              const Divider(
                color: grey3,
              ),
              Text(
                StringValidation.capitalize(
                  order.adminAddress!,
                ),
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  color: grey3,
                  fontSize: textFontSize13,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                ),
              ),
              InkWell(
                child: Row(
                  children: [
                    Text(
                      '${MOBILEHINT_LBL.translate(context: context)} -',
                      style: const TextStyle(
                        color: grey,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${order.adminMobile!}",
                      style: const TextStyle(
                        color: primary,
                        fontFamily: 'PlusJakartaSans',
                        fontSize: textFontSize13,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _launchCaller(order.mobile!, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
