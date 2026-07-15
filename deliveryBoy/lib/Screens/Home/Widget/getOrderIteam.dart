import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Screens/Home/home.dart';
import 'package:deliveryboy_multivendor/Widget/desing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../Helper/color.dart';
import '../../../Helper/constant.dart';

class CommanDesingWidget extends StatelessWidget {
  final String title;
  final int index;
  final Function update;
  final String imagetitle;
  const CommanDesingWidget(
      {Key? key,
      required this.index,
      required this.title,
      required this.update,
      required this.imagetitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: blarColor,
            offset: Offset(0, 0),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
        color: currentSelected == index ? primary : white,
        borderRadius: BorderRadius.all(
          Radius.circular(circularBorderRadius7),
        ),
      ),
      child: InkWell(
        onTap: () {
          print("click on button");
          if (homeProvider!.isLoadingItems) {
            return;
          }
          homeProvider!.activeStatus =
              index == 0 ? "" : homeProvider!.statusList[index];
          homeProvider!.isLoadingmore = true;
          homeProvider!.offset = 0;
          homeProvider!.isLoadingItems = true;
          currentSelected = index;
          homeProvider!.getOrder(update, context);
          update();
        },
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 12.0,
                    ),
                    child: Text(
                      () {
                        if (index == 0) {
                          if (homeProvider!.all != null) {
                            return homeProvider!.all!;
                          } else {
                            return "0";
                          }
                        } else if (index == 1) {
                          if (homeProvider!.received != null) {
                            return homeProvider!.received!;
                          } else {
                            return "0";
                          }
                        } else if (index == 2) {
                          if (homeProvider!.processed != null) {
                            return homeProvider!.processed!;
                          } else {
                            return "0";
                          }
                        } else if (index == 3) {
                          if (homeProvider!.assigned != null) {
                            return homeProvider!.assigned!;
                          } else {
                            return "0";
                          }
                        } else if (index == 4) {
                          if (homeProvider!.shipped != null) {
                            return homeProvider!.shipped!;
                          } else {
                            return "0";
                          }
                        } else if (index == 5) {
                          if (homeProvider!.delivered != null) {
                            return homeProvider!.delivered!;
                          } else {
                            return "0";
                          }
                        } else if (index == 6) {
                          if (homeProvider!.cancelled != null) {
                            return homeProvider!.cancelled!;
                          } else {
                            return "0";
                          }
                        } else if (index == 7) {
                          if (homeProvider!.returned != null) {
                            return homeProvider!.returned!;
                          } else {
                            return "0";
                          }
                        } else {
                          return "";
                        }
                      }(),
                      style: TextStyle(
                        color: currentSelected == index ? white : black,
                        fontWeight: FontWeight.bold,
                        fontSize: textFontSize16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 5.0,
                    ),
                    child: Text(
                      title.translate(context: context),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: currentSelected == index ? white : black,
                        fontSize: textFontSize12,
                      ),
                    ),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(circularBorderRadius100),
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: currentSelected == index
                      ? white
                      : Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                  child: SvgPicture.asset(
                    DesignConfiguration.setSvgPath(imagetitle),
                    height: 20,
                    width: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
