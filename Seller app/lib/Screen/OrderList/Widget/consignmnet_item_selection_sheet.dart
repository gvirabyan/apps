import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/ordered_item_card.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/cubits/order/create_consignment_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignments_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_orders_cubit.dart';
import 'package:sellermultivendor/main.dart';

class ConsignmentItemSelectionBottomSheet extends StatefulWidget {
  final List<OrderItem> orderItems;
  final String orderId;
  const ConsignmentItemSelectionBottomSheet({
    super.key,
    required this.orderId,
    required this.orderItems,
  });

  @override
  State<ConsignmentItemSelectionBottomSheet> createState() =>
      _ConsignmentItemSelectionBottomSheetState();
}

class _ConsignmentItemSelectionBottomSheetState
    extends State<ConsignmentItemSelectionBottomSheet> {
  final TextEditingController _consignmentNameController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> selectedItemIds = [];
  late List<OrderItem> pendingConsignmentItems = widget.orderItems
      .where(
        (e) =>
            e.isConsignmentCreated == '0' &&
            e.activeStatus!.toLowerCase() != "cancelled",
      )
      .toList();
  String? selectedPickupLocation;

  @override
  Widget build(BuildContext context) {
    bool showPickupDropdown = pendingConsignmentItems.every(
      (e) => e.pickupLocation != null && e.pickupLocation!.trim().isNotEmpty,
    );
    List<OrderItem> filteredItems =
        (!showPickupDropdown || selectedPickupLocation == null)
        ? pendingConsignmentItems
        : pendingConsignmentItems
              .where((item) => item.pickupLocation == selectedPickupLocation)
              .toList();

    return BlocListener<CreateConsignmentCubit, CreateConsignmentState>(
      listener: (context, state) {
        if (state is CreateConsignmentSuccess) {
          context.read<FetchOrdersCubit>().updateOrder(state.orderModel);
          context.read<FetchConsignmentsCubit>().fetch(
            orderId: state.orderModel.id!,
          );

          Navigator.pop(context);
          setSnackbar('consign_created'.translate(context: context), context);
        }
        if (state is CreateConsignmentFail) {
          Navigator.pop(context);
          Navigator.pop(context);
          setSnackbar(state.error.toString(), rootNavigatorKey.currentContext!);
        }
      },
      child: Form(
        key: _formKey,
        child: SizedBox(
          height: context.screenHeight * 0.75,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('confirm_parcel'.translate(context: context)).size(20),
                    const CloseButton(),
                  ],
                ),
              ),
              const Divider(height: 0, indent: 0, thickness: 2),
              buildSearchField(),
              Expanded(
                child: Column(
                  children: [
                    if (showPickupDropdown)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: grey1,
                            borderRadius: BorderRadius.circular(
                              circularBorderRadius7,
                            ),
                            border: Border.all(color: grey2, width: 1),
                          ),
                          width: double.infinity,
                          height: height * 0.06,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedPickupLocation,
                                hint: Text(
                                  "SELECTPICKUPLOCATION".translate(
                                    context: context,
                                  ),
                                ),
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down_outlined,
                                ),
                                items: pendingConsignmentItems
                                    .map((item) => item.pickupLocation)
                                    .where((loc) => loc != null)
                                    .toSet()
                                    .toList()
                                    .map<DropdownMenuItem<String>>((
                                      String? location,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: location,
                                        child: Text(location ?? ""),
                                      );
                                    })
                                    .toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedPickupLocation = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    if (!showPickupDropdown || selectedPickupLocation != null)
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: filteredItems.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            OrderItem item = filteredItems[index];
                            return OrderdItemCard(
                              item: item,
                              enableSelection: true,
                              onSelectionChange: (id) {
                                if (selectedItemIds.contains(item.id)) {
                                  selectedItemIds.remove(item.id);
                                } else {
                                  selectedItemIds.add(item.id!);
                                }
                                setState(() {});
                              },
                              selected: selectedItemIds.contains(item.id),
                            );
                          },
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Text(
                            "PLEASESELECTPICKUPLOCATION".translate(
                              context: context,
                            ),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(color: primary),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('CANCEL'.translate(context: context)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child:
                          BlocBuilder<
                            CreateConsignmentCubit,
                            CreateConsignmentState
                          >(
                            builder: (context, state) {
                              return MaterialButton(
                                color: primary,
                                height: 42,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textColor: white,
                                onPressed: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  bool didSuccess = false;
                                  if (_formKey.currentState!.validate()) {
                                    didSuccess = true;
                                  } else {
                                    return;
                                  }
                                  print(
                                    "selectedItemIds------->$selectedItemIds",
                                  );
                                  didSuccess =
                                      (await showDialog<bool>(
                                        context: context,
                                        builder: (dContext) {
                                          return AlertDialog(
                                            title: Text(
                                              'CONFIRM_PARCEL_CREATION'
                                                  .translate(context: context),
                                            ),
                                            content: Text(
                                              'CONFIRM_PARCEL'.translate(
                                                context: context,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'CANCEL'.translate(
                                                    context: context,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (selectedItemIds.isEmpty) {
                                                    Navigator.pop(
                                                      context,
                                                      false,
                                                    );
                                                    setSnackbar(
                                                      'PLEASE_SELECT_ANY_PRODUCT'
                                                          .translate(
                                                            context: context,
                                                          ),
                                                      context,
                                                    );
                                                  } else {
                                                    Navigator.pop(
                                                      context,
                                                      true,
                                                    );
                                                  }
                                                },
                                                child: Text(
                                                  'CONFIRM'.translate(
                                                    context: context,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      )) ??
                                      false;
                                  if (didSuccess) {
                                    context
                                        .read<CreateConsignmentCubit>()
                                        .create(
                                          consignmentTitle:
                                              _consignmentNameController.text,
                                          orderId: widget.orderId,
                                          orderItemIds: selectedItemIds,
                                        );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (state is CreateConsignmentInProgress)
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(
                                            color: white,
                                            strokeWidth: 1.5,
                                          ),
                                        ),
                                      ),
                                    Text('CREATE'.translate(context: context)),
                                  ],
                                ),
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: TextFormField(
        controller: _consignmentNameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'please_enter_consignment_title'.translate(context: context);
          }
          return null;
        },
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'consignment_title'.translate(context: context),
          filled: true,
          fillColor: lightWhite,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
