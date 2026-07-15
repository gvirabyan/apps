import 'package:deliveryboy_multivendor/Cubit/UpdateStatusReturnOrderCubit.dart';
import 'package:deliveryboy_multivendor/Cubit/returnOrderCubit.dart';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/constant.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Model/ReturnOrderModel.dart';
import 'package:deliveryboy_multivendor/Screens/Return/Widget/adminDetails.dart';
import 'package:deliveryboy_multivendor/Screens/Return/Widget/pickupDetails.dart';
import 'package:deliveryboy_multivendor/Widget/desing.dart';
import 'package:deliveryboy_multivendor/Widget/setSnackbar.dart';
import 'package:deliveryboy_multivendor/Widget/translateVariable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderDetailsScreen extends StatefulWidget {
  final ReturnOrderModel order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String? selectedStatus;
  final List<String> statusOptions = [
    'return_pickedup',
  ];

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.order.activeStatus!;
  }

  Widget statusUpdate(ReturnOrderModel model, BuildContext context) {
    void _openStatusBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsetsDirectional.only(
                end: 16.0,
                start: 16.0,
                top: 16.0,
                bottom: MediaQuery.of(context).padding.bottom + 16.0),
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
                      Navigator.pop(context); // Close the BottomSheet
                    }
                  },
                  child: Column(
                    children: statusOptions.map((status) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          status.replaceAll('_', ' '),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Radio<String>(
                          value: status,
                        ),
                        onTap: () {
                          // Make whole tile selectable
                          RadioGroup.maybeOf<String>(context)
                              ?.onChanged
                              .call(status);
                        },
                      );
                    }).toList(),
                  ),
                )
                // ...statusOptions.map((status) {
                //   return ListTile(
                //     contentPadding: EdgeInsets.zero,
                //     title: Text(
                //       status.replaceAll('_', ' '), // Capitalize first letter
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
              model.activeStatus == 'return_request_approved'
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
                                    selectedStatus!.replaceAll('_', ' '),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Icon(Icons.keyboard_arrow_down)
                                ],
                              )),
                          onTap: () => _openStatusBottomSheet(context),
                        ),
                        BlocConsumer<UpdateStatusReturnOrderCubit,
                            UpdateStatusReturnOrderState>(
                          listener: (context, state) {
                            if (state is UpdateStatusReturnOrderSuccess) {
                              context
                                  .read<FetchReturnOrderCubit>()
                                  .updateOrder(state.result);
                              setState(() {});
                              setSnackbar(
                                  'Update_Order_Successfully'
                                      .translate(context: context),
                                  context);
                            } else if (state is UpdateStatusReturnOrderFail) {
                              setSnackbar(state.errorMessage, context);
                            }
                          },
                          builder: (context, state) {
                            return GestureDetector(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsetsDirectional.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(
                                      5.0), // Rounded border
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
                                if (state
                                    is UpdateStatusReturnOrderInProgress) {
                                  return;
                                }
                                context
                                    .read<UpdateStatusReturnOrderCubit>()
                                    .updateReturnOrderStatus(
                                        orderItemId: widget.order.orderItemId!,
                                        status: selectedStatus!);
                              },
                            );
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
                              model.activeStatus!.replaceAll('_', ' '),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ORDER_DETAIL.translate(context: context),
        ),
        foregroundColor: white,
        automaticallyImplyLeading: true,
        systemOverlayStyle: SystemUiOverlayStyle.light
            .copyWith(statusBarColor: Colors.transparent),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [grad1Color, grad2Color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 1],
              tileMode: TileMode.clamp,
            ),
            borderRadius: BorderRadius.only(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 15.0,
            bottom: MediaQuery.of(context).padding.bottom + 15.0,
            left: 15.0,
            right: 15.0,
          ),
          child: Column(
            children: [
              basicDetails(widget.order, context),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 150,
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 15.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Product",
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: black,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PlusJakartaSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: textFontSize16,
                                  ),
                        ),
                        Divider(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              child: DesignConfiguration.getCacheNotworkImage(
                                boxFit: BoxFit.cover,
                                context: context,
                                heightvalue: 94.0,
                                imageurlString: widget.order.productImage!,
                                placeHolderSize: 150.0,
                                widthvalue: 64.0,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 10.0, top: 10),
                                      child: Text(
                                        widget.order.productName ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: black,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "PlusJakartaSans",
                                              fontStyle: FontStyle.normal,
                                              fontSize: textFontSize15,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        'qty : ${widget.order.quantity ?? ''}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              color: black,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "PlusJakartaSans",
                                              fontStyle: FontStyle.normal,
                                              fontSize: textFontSize15,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 5,
              ),
              statusUpdate(widget.order, context),
              SizedBox(
                height: 5,
              ),
              PickupDetails(order: widget.order),
              SizedBox(
                height: 5,
              ),
              AdminDetails(order: widget.order)
            ],
          ),
        ),
      ),
    );
  }
}

Widget basicDetails(ReturnOrderModel order, BuildContext context) {
  return Container(
    height: 100,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(circularBorderRadius5)),
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
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 15.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ORDER_OVERVIEW.translate(context: context),
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: black,
                  fontWeight: FontWeight.w400,
                  fontFamily: "PlusJakartaSans",
                  fontStyle: FontStyle.normal,
                  fontSize: textFontSize16,
                ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ORDER_ID_LBL.translate(context: context),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: grey3,
                        fontWeight: FontWeight.w400,
                        fontFamily: "PlusJakartaSans",
                        fontStyle: FontStyle.normal,
                        fontSize: textFontSize14,
                      ),
                ),
                Text(
                  '#' + order.orderId!,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontFamily: 'PlusJakartaSans',
                        color: black,
                        fontSize: textFontSize14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${PAYMENT_MTHD.translate(context: context)}",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: grey3,
                      fontWeight: FontWeight.w400,
                      fontFamily: "PlusJakartaSans",
                      fontStyle: FontStyle.normal,
                      fontSize: textFontSize14,
                    ),
              ),
              Text(
                order.paymentMethod!,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontFamily: 'PlusJakartaSans',
                      color: black,
                      fontSize: textFontSize14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
