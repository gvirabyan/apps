import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/delivery_boy_model.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Repository/ordeListRepositry.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/consignment_card.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/update_tracking_details_bottomsheet.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/cubits/order/cancel_shiprocket_order_cubit.dart';
import 'package:sellermultivendor/cubits/order/create_shiprocket_order_cubit.dart';
import 'package:sellermultivendor/cubits/order/create_wafeq_invoice_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignments_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_orders_cubit.dart';
import 'package:sellermultivendor/cubits/order/update_consignment_status_cubit.dart';
import 'package:sellermultivendor/cubits/order/update_shiprocket_order_status_cubit.dart';
import 'package:sellermultivendor/main.dart';
import 'widgets/download_actions_section.dart';
import 'widgets/info_cards.dart';
import 'widgets/shiprocket_bottom_bar.dart';
import 'widgets/status_update_bottom_bar.dart';

class ConsignmentDetails extends StatefulWidget {
  final ConsignmentModel consignment;
  final OrderModel order;

  const ConsignmentDetails({
    super.key,
    required this.consignment,
    required this.order,
  });

  @override
  State<ConsignmentDetails> createState() => _ConsignmentDetailsState();
}

class _ConsignmentDetailsState extends State<ConsignmentDetails> {
  OrderStatus? selectedOrderStatus;
  DeliveryBoy? selectedDeliveryBoy;
  TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _onTapUpdateStatus() async {
    // Validate selections
    if (selectedOrderStatus == null) {
      setSnackbar("set_order_status".translate(context: context), context,
          margin: const EdgeInsets.only(bottom: 100),
          backgroundColor: lightWhite,
          action: SnackBarBehavior.floating);
      return;
    }

    // Check if OTP is required for delivered status
    if (selectedOrderStatus!.name == 'delivered' &&
        selectedDeliveryBoy != null &&
        widget.consignment.consignmentItems
            .every((item) => item.deliveryboyOtpSettingOn == "1")) {
      String? enteredOtp = await showOTPDialog(context, formKey, otpController);
      if (enteredOtp == null || enteredOtp.isEmpty) {
        return;
      }
      otpController.text = enteredOtp;
    }

    if (selectedOrderStatus!.name == 'assigned' && selectedDeliveryBoy == null) {
      setSnackbar("dboy_update".translate(context: context), context,
          margin: const EdgeInsets.only(bottom: 100),
          backgroundColor: lightWhite,
          action: SnackBarBehavior.floating);
      return;
    }

    if (selectedDeliveryBoy == null &&
        widget.consignment.trackingDetails?.courierAgency == null) {
      setSnackbar("dboy_update".translate(context: context), context,
          margin: const EdgeInsets.only(bottom: 100),
          backgroundColor: lightWhite,
          action: SnackBarBehavior.floating);
      return;
    }

    // Update consignment status
    if (selectedOrderStatus!.name == 'delivered') {
      if (selectedDeliveryBoy != null) {
        context.read<UpdateConsignmentStatusCubit>().update(
              consignmentId: widget.consignment.id,
              status: selectedOrderStatus!.name,
              deliveryboyId: selectedDeliveryBoy!.id,
              otp: otpController.text,
            );
      } else {
        context.read<UpdateConsignmentStatusCubit>().update(
              consignmentId: widget.consignment.id,
              status: selectedOrderStatus!.name,
              otp: otpController.text,
            );
      }
    } else {
      if (selectedDeliveryBoy != null) {
        context.read<UpdateConsignmentStatusCubit>().update(
            consignmentId: widget.consignment.id,
            status: selectedOrderStatus!.name,
            deliveryboyId: selectedDeliveryBoy!.id);
      } else {
        context.read<UpdateConsignmentStatusCubit>().update(
            consignmentId: widget.consignment.id,
            status: selectedOrderStatus!.name);
      }
    }

    selectedOrderStatus = null;
    selectedDeliveryBoy = null;
    otpController.clear();
  }

  void _onStatusChanged(OrderStatus? status, DeliveryBoy? deliveryBoy) {
    setState(() {
      selectedOrderStatus = status;
      selectedDeliveryBoy = deliveryBoy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateWafeqInvoiceCubit(),
      child: Scaffold(
        backgroundColor: lightWhite,
        floatingActionButton: _buildFloatingActionButton(),
        bottomNavigationBar: _buildBottomNavigationBar(),
        body: _buildBody(),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (!widget.order.isDigitalOrder &&
        widget.consignment.activeStatus != 'delivered' &&
        !widget.consignment.isShiprocketConsignmentBool) {
      return FloatingActionButton(
        onPressed: () async {
          await showUpdateTrackingDetailsBottomsheet(
              rootNavigatorKey.currentContext!, widget.consignment);
          setState(() {});
        },
        child: const Icon(
          Icons.add_location_alt_rounded,
          color: white,
        ),
      );
    }
    return null;
  }

  Widget? _buildBottomNavigationBar() {
    if (widget.consignment.isShiprocketConsignmentBool) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => CreateShiprocketOrderCubit()),
          BlocProvider(create: (context) => CancelShiprocketOrderCubit()),
          BlocProvider(create: (context) => UpdateShiprocketOrderStatusCubit()),
        ],
        child: ShiprocketBottomBar(
          consignment: widget.consignment,
          order: widget.order,
        ),
      );
    } else if (widget.consignment.activeStatus != 'delivered') {
      return StatusUpdateBottomBar(
        consignment: widget.consignment,
        onStatusChanged: _onStatusChanged,
        onUpdatePressed: _onTapUpdateStatus,
      );
    }
    return null;
  }

  Widget _buildBody() {
    return MultiBlocListener(
      listeners: [
        BlocListener<UpdateConsignmentStatusCubit,
            UpdateConsignmentStatusState>(
          listener: (context, state) {
            if (state is UpdateConsignmentStatusInSuccess) {
              context
                  .read<FetchConsignmentsCubit>()
                  .updateConsignment(state.result);
              context.read<FetchOrdersCubit>().refreshOrderList();
              setState(() {});
              setSnackbar(
                  'PARCEL_STATUS_UPDATE_SUCCESSFULLY'
                      .translate(context: context),
                  context);

              // Trigger Wafeq e-invoice on order confirmation (processed status).
              // Invoice creation is fire-and-forget — it never blocks order flow.
              final newStatus = state.result.activeStatus;
              debugPrint('🧾 WAFEQ | status updated → activeStatus=$newStatus | orderId=${widget.order.id}');
              if (newStatus == 'processed' || newStatus == 'shipped') {
                debugPrint('🧾 WAFEQ | triggering invoice for order #${widget.order.id} (status=$newStatus)');
                context
                    .read<CreateWafeqInvoiceCubit>()
                    .createInvoice(widget.order);
              } else {
                debugPrint('🧾 WAFEQ | skipped — status "$newStatus" does not trigger invoice');
              }
            }
            if (state is UpdateConsignmentStatusFail) {
              setSnackbar(state.error.toString(), context);
            }
          },
        ),
        BlocListener<CreateWafeqInvoiceCubit, CreateWafeqInvoiceState>(
          listener: (context, state) {
            if (state is CreateWafeqInvoiceFailed) {
              // Non-blocking: show a subtle warning so the seller can follow up
              setSnackbar(
                'Invoice sync failed: ${state.errorMessage}',
                context,
              );
            }
          },
        ),
      ],
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ConsignmentCard(consignment: widget.consignment),
              const SizedBox(height: 14),
              OrderOverviewCard(consignment: widget.consignment),
              const SizedBox(height: 14),
              ShippingDetailsCard(consignment: widget.consignment),
              const SizedBox(height: 10),
              DownloadActionsSection(consignment: widget.consignment),
              PriceDetailsCard(consignment: widget.consignment),
              const SizedBox(height: 55),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> showOTPDialog(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController otpController,
  ) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ENTEROTP'.translate(context: context)),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.isEmpty || value.length != 6) {
                  return 'OTPERROR'.translate(context: context);
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'ENTEROTP'.translate(context: context),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('CANCEL'.translate(context: context)),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(dialogContext).pop(otpController.text);
                }
              },
              child: Text('Submit'.translate(context: context)),
            ),
          ],
        );
      },
    );
  }
}
