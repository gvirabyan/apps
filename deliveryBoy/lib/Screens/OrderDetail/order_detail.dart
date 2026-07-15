import 'dart:async';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/constant.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Model/orderModel.dart';
import 'package:deliveryboy_multivendor/Screens/OrderDetail/Widget/sellerDetailWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/orderDetailProvider.dart';
import '../../Widget/appBar.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/translateVariable.dart';
import 'Widget/basicDetailWidget.dart';
import 'Widget/priceDetailsWidget.dart';
import 'Widget/shippingDetailsWidget.dart';

class OrderDetail extends StatefulWidget {
  final OrderModel? model;
  final Function? updateHome;

  const OrderDetail({
    Key? key,
    this.model,
    this.updateHome,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateOrder();
  }
}

OrderDetailProvider? orderDetailProvider;

class StateOrder extends State<OrderDetail> with TickerProviderStateMixin {
  setStateNow() {
    setState(() {});
  }

  String? selectedStatus;
  final TextEditingController otpController = TextEditingController();
  final List<String> statusOptions = [
    'received',
    'processed',
    'assigned',
    'shipped',
    'delivered'
  ];
  List<String>? trimmedList;

  @override
  void initState() {
    super.initState();
    orderDetailProvider =
        Provider.of<OrderDetailProvider>(context, listen: false);
    orderDetailProvider!.initializeVariable();
    selectedStatus = widget.model!.activeStatus!; // Preselected status

    List<String> trimStatusAfter(String status) {
      int index = statusOptions.indexOf(status);
      return (index != -1 && index < statusOptions.length - 1)
          ? statusOptions.sublist(index + 1)
          : [];
    }

    trimmedList = trimStatusAfter(widget.model!.activeStatus!);

    orderDetailProvider!.buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    orderDetailProvider!.buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: orderDetailProvider!.buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

  @override
  void dispose() {
    orderDetailProvider!.buttonController!.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await orderDetailProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (BuildContext context) => super.widget,
            ),
          );
        } else {
          await orderDetailProvider!.buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    OrderModel model = widget.model!;

    return Scaffold(
      appBar: GradientAppBar(
        ORDER_DETAIL.translate(context: context),
        customback: true,
      ),
      key: orderDetailProvider!.scaffoldKey,
      backgroundColor: lightWhite,
      body: isNetworkAvail
          ? Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: orderDetailProvider!.controller,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                            top: 15.0,
                            bottom:
                                MediaQuery.of(context).padding.bottom + 15.0,
                            start: 15.0,
                            end: 15.0,
                          ),
                          child: Column(
                            children: [
                              BasicDetail(model: model),
                              model.deliveryDate != null &&
                                      model.deliveryDate!.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10.0,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  circularBorderRadius5)),
                                          color: white,
                                          boxShadow: const [
                                            BoxShadow(
                                                color: blarColor,
                                                offset: Offset(0, 0),
                                                blurRadius: 4,
                                                spreadRadius: 0),
                                          ],
                                        ),
                                        height: 52,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 6.0,
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 6.0,
                                          ),
                                          child: Text(
                                            PREFER_DATE_TIME.translate(
                                                    context: context) +
                                                ": ${model.deliveryDate!} - ${model.deliveryTime!}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  fontFamily: 'PlusJakartaSans',
                                                  color: grey3,
                                                  fontSize: textFontSize14,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              circularBorderRadius5)),
                                      color: white,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: blarColor,
                                            offset: Offset(0, 0),
                                            blurRadius: 4,
                                            spreadRadius: 0),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, left: 20),
                                          child: Text(
                                            PRODUCTS.translate(
                                                context:
                                                    context), // Replace with your desired text
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                  color: black,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "PlusJakartaSans",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: textFontSize16,
                                                ),
                                          ),
                                        ),
                                        ...model.consignmentItems!
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int i = entry.key;
                                          ConsignmentItems consignmentItems =
                                              entry.value;
                                          return productItem(
                                              consignmentItems, model, i);
                                        }).toList(),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              statusUpdate(model, context),
                              SellerDetailsScreen(model: model),
                              ShippingDetails(
                                model: model,
                              ),
                              PriceDetails(
                                model: model,
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                DesignConfiguration.showCircularProgress(
                  orderDetailProvider!.isProgress,
                  primary,
                ),
              ],
            )
          : noInternet(
              context,
              setStateNoInternate,
              orderDetailProvider!.buttonSqueezeanimation,
              orderDetailProvider!.buttonController,
            ),
    );
  }

  Widget statusUpdate(OrderModel model, BuildContext context) {
    void _openStatusBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SELECT_STATUS'.translate(context: context),
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
                Divider(),
                // Generate RadioListTile widgets from the statusOptions list
                RadioGroup<String>(
                  groupValue: selectedStatus,
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        selectedStatus = value;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Column(
                    children: trimmedList!.map((status) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          status[0].toUpperCase() + status.substring(1),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Radio<String>(
                          value: status,
                        ),
                        // Also you may want to make the ListTile itself tappable to select
                        onTap: () {
                          RadioGroup.maybeOf<String>(context)
                              ?.onChanged
                              .call(status);
                        },
                      );
                    }).toList(),
                  ),
                )

                // ...trimmedList!.map((status) {
                //   return ListTile(
                //     contentPadding: EdgeInsets.zero,
                //     title: Text(
                //       status[0].toUpperCase() +
                //           status.substring(1), // Capitalize first letter
                //       style:
                //           TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                //     ),
                //     trailing: Radio<String>(
                //       value: status,
                //       groupValue: selectedStatus,
                //       onChanged: (String? value) {
                //         setState(() {
                //           selectedStatus = value!;
                //         });
                //         Navigator.pop(context); // Close the BottomSheet
                //       },
                //     ),
                //   );
                // }).toList()
              ],
            ),
          );
        },
      );
    }

    void _showOTPDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext dialogcontext) {
          return AlertDialog(
            title: Text('Enter your OTP'),
            content: TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter OTP',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Future.delayed(Duration(milliseconds: 100), () {
                    Navigator.of(dialogcontext).pop();
                  });
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  String enteredOTP = otpController.text;
                  print('Entered OTP: $enteredOTP');
                  Future.delayed(Duration(milliseconds: 100), () {
                    orderDetailProvider!.updateOrder(selectedStatus, model.id,
                        enteredOTP, setStateNow, context, model);
                    Navigator.of(dialogcontext).pop();
                  });
                },
                child: Text('Update Status'),
              ),
            ],
          );
        },
      );
    }

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          padding: EdgeInsetsDirectional.all(8),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ORDER_STATUS".translate(context: context),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: black,
                      fontWeight: FontWeight.w400,
                      fontFamily: "PlusJakartaSans",
                      fontStyle: FontStyle.normal,
                      fontSize: textFontSize16,
                    ),
              ),
              Divider(),
              model.activeStatus == 'shipped' ||
                      model.activeStatus == 'processed' ||
                      model.activeStatus == 'received' ||
                      model.activeStatus == 'assigned'
                  ? Column(
                      children: [
                        GestureDetector(
                          child: Container(
                              padding: EdgeInsetsDirectional.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(
                                    5.0), // Rounded border
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedStatus!,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Icon(Icons.keyboard_arrow_down)
                                ],
                              )),
                          onTap: () => _openStatusBottomSheet(context),
                        ),
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsetsDirectional.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius:
                                  BorderRadius.circular(5.0), // Rounded border
                            ),
                            child: Center(
                              child: Text(
                                UpdateStatus.translate(context: context),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: white,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "PlusJakartaSans",
                                      fontStyle: FontStyle.normal,
                                      fontSize: textFontSize16,
                                    ),
                              ),
                            ),
                          ),
                          onTap: () {
                            print(
                                "selectedstatus--->${selectedStatus} ----->${model.otp}");
                            if (selectedStatus == 'delivered' &&
                                model.consignmentItems!.every((item) =>
                                    item.deliveryboyOtpSettingOn == "1") &&
                                model.otp != "" &&
                                model.otp!.isNotEmpty &&
                                model.otp != "0") {
                              print("isopened---->");
                              _showOTPDialog(context);
                            } else {
                              orderDetailProvider!.updateOrder(selectedStatus,
                                  model.id, '', setStateNow, context, model);
                            }
                          },
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          Text(
                            "ORDER_STATUS".translate(context: context) + ":",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: lightBlack2,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              model.activeStatus!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: black,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ));
  }

  Widget productItem(
      ConsignmentItems consignmentItems, OrderModel model, int i) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 0.0,
        bottom: 0,
        left: 10,
        right: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                // borderRadius: BorderRadius.circular(10.0),
                child: DesignConfiguration.getCacheNotworkImage(
                  boxFit: BoxFit.cover,
                  context: context,
                  heightvalue: 94.0,
                  imageurlString: consignmentItems.image!,
                  placeHolderSize: 150.0,
                  widthvalue: 64.0,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                        child: Text(
                          consignmentItems.productName ?? '',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: black,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PlusJakartaSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: textFontSize13,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // orderItem.attr_name!.isNotEmpty
                      //     ? ListView.builder(
                      //         physics: const NeverScrollableScrollPhysics(),
                      //         shrinkWrap: true,
                      //         itemCount: att.length,
                      //         itemBuilder: (context, index) {
                      //           return Padding(
                      //             padding:
                      //                 const EdgeInsets.only(bottom: 10),
                      //             child: Row(
                      //               children: [
                      //                 Flexible(
                      //                   child: Text(
                      //                     att[index].trim() + ":",
                      //                     overflow: TextOverflow.ellipsis,
                      //                     style: Theme.of(context)
                      //                         .textTheme
                      //                         .titleSmall!
                      //                         .copyWith(
                      //                           color: grey3,
                      //                           fontWeight: FontWeight.w400,
                      //                           fontFamily:
                      //                               "PlusJakartaSans",
                      //                           fontStyle: FontStyle.normal,
                      //                           fontSize: textFontSize13,
                      //                         ),
                      //                   ),
                      //                 ),
                      //                 Padding(
                      //                   padding: const EdgeInsets.only(
                      //                       left: 5.0),
                      //                   child: Text(
                      //                     val[index],
                      //                     style: Theme.of(context)
                      //                         .textTheme
                      //                         .titleSmall!
                      //                         .copyWith(
                      //                           color: black,
                      //                           fontWeight: FontWeight.w400,
                      //                           fontFamily:
                      //                               "PlusJakartaSans",
                      //                           fontStyle: FontStyle.normal,
                      //                           fontSize: textFontSize13,
                      //                         ),
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //           );
                      //         },
                      //       )
                      //     : Container(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              QUANTITY_LBL.translate(context: context) + ":",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: lightBlack2,
                                  ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                consignmentItems.quantity!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: black,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${DesignConfiguration.getPriceFormat(context, double.parse(consignmentItems.price!))!}",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: primary,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "PlusJakartaSans",
                                  fontStyle: FontStyle.normal,
                                  fontSize: textFontSize13,
                                ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
