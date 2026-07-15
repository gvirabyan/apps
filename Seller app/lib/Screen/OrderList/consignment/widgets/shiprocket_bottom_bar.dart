import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/cancel_shiprocket_order_confirmation_dialog.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/createShiprocketOrderBottomsheet.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/cubits/order/cancel_shiprocket_order_cubit.dart';
import 'package:sellermultivendor/cubits/order/create_shiprocket_order_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignments_cubit.dart';
import 'package:sellermultivendor/cubits/order/update_shiprocket_order_status_cubit.dart';
import 'package:sellermultivendor/main.dart';
import 'package:url_launcher/url_launcher.dart';

/// Bottom bar for shiprocket order actions
class ShiprocketBottomBar extends StatelessWidget {
  final ConsignmentModel consignment;
  final OrderModel order;

  const ShiprocketBottomBar({
    super.key,
    required this.consignment,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: EdgeInsets.zero,
      notchMargin: 0,
      child: FittedBox(
        fit: BoxFit.none,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (consignment.isShiprocketOrderCreatedBool) ...[
              _buildShiprocketOrderCreatedActions(context),
              _buildRefreshOrderStatusButton(context),
            ] else ...[
              _buildCreateShiprocketOrderButton(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildShiprocketOrderCreatedActions(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * 00.9,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (consignment.activeStatus.toString().toLowerCase() !=
              'delivered') ...[
            Expanded(
              child: BlocConsumer<CancelShiprocketOrderCubit,
                  CancelShiprocketOrderState>(
                listener: (context, state) {
                  if (state is CancelShiprocketOrderSuccess) {
                    context
                        .read<FetchConsignmentsCubit>()
                        .updateConsignment(state.consignment);
                    setSnackbar(
                        'SHIPROCKET_ORDER_CANCELED_SUCCESSFULLY'
                            .translate(context: context),
                        context);
                  } else if (state is CancelShiprocketOrderFail) {
                    setSnackbar(state.errorMessage, context);
                  }
                },
                builder: (context, state) {
                  return OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: black),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      if (state is CancelShiprocketOrderInProgress) {
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const CancelShiprocketOrderConfirmationDialog();
                        },
                      ).then((value) {
                        if (value == true) {
                          context
                              .read<CancelShiprocketOrderCubit>()
                              .cancelShiprocketOrder(
                                  shiprocketOrderId: consignment
                                          .trackingDetails?.shiprocketOrderId ??
                                      "");
                        }
                      });
                    },
                    child: Row(
                      children: [
                        if (state is CancelShiprocketOrderInProgress) ...[
                          const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: black,
                              strokeWidth: 1.5,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                        Expanded(
                          child: Text(
                            'CANCEL_ORDER'.translate(context: context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: primary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                if (consignment.trackingDetails == null ||
                    consignment.trackingDetails!.url == null ||
                    consignment.trackingDetails!.url!.isEmpty) {
                  setSnackbar(
                      "tracking_url_not_added".translate(context: context),
                      context);
                  return;
                }
                final Uri uri =
                    Uri.parse(consignment.trackingDetails!.url ?? "");
                try {
                  await launchUrl(uri);
                } catch (e) {
                  setSnackbar('UNABLE_TO_OPEN_URL'.translate(context: context),
                      context);
                }
              },
              child: Text(
                'TRACK_ORDER'.translate(context: context),
                style: const TextStyle(
                    color: primary, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshOrderStatusButton(BuildContext context) {
    return BlocConsumer<UpdateShiprocketOrderStatusCubit,
        UpdateShiprocketOrderStatusState>(
      listener: (context, state) {
        if (state is UpdateShiprocketOrderStatusSuccess) {
          context
              .read<FetchConsignmentsCubit>()
              .updateConsignment(state.consignment);
          setSnackbar(
              'SHIPROCKET_ORDER_UPDATED_SUCCESSFULLY'
                  .translate(context: context),
              context);
        } else if (state is UpdateShiprocketOrderStatusFail) {
          setSnackbar(state.errorMessage, context);
        }
      },
      builder: (context, state) {
        return MaterialButton(
          textColor: white,
          height: 41,
          disabledColor: primary.withValues(alpha: 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          minWidth: context.screenWidth * 00.9,
          onPressed: () {
            if (state is UpdateShiprocketOrderStatusInProgress) {
              return;
            }
            context
                .read<UpdateShiprocketOrderStatusCubit>()
                .updateShiprocketOrderStatus(
                    trackingId: consignment.trackingDetails!.trackingId ?? "");
          },
          color: primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is UpdateShiprocketOrderStatusInProgress)
                const SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    color: white,
                    strokeWidth: 1.5,
                  ),
                ),
              const SizedBox(
                width: 8,
              ),
              Text('REFRESH_ORDER_STATUS'.translate(context: context)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCreateShiprocketOrderButton(BuildContext context) {
    return BlocConsumer<CreateShiprocketOrderCubit, CreateShiprocketOrderState>(
      listener: (context, state) {
        if (state is CreateShiprocketOrderSuccess) {
          context
              .read<FetchConsignmentsCubit>()
              .updateConsignment(state.consignment);
          setSnackbar(
              'SHIPROCKET_ORDER_CREATED_SUCCESSFULLY'
                  .translate(context: context),
              context);
        } else if (state is CreateShiprocketOrderFail) {
          setSnackbar(state.errorMessage, context);
        }
      },
      builder: (context, state) {
        return MaterialButton(
          textColor: white,
          height: 41,
          disabledColor: primary.withValues(alpha: 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 22),
          minWidth: context.screenWidth * 00.9,
          onPressed: () {
            if (state is CreateShiprocketOrderInProgress) {
              return;
            }
            showCreateShiprocketOrderBottomSheet(
                rootNavigatorKey.currentContext!,
                cubit: context.read<CreateShiprocketOrderCubit>(),
                pickupLocation: order.pickupLocation ?? '',
                consignmentId: consignment.id);
          },
          color: primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is CreateShiprocketOrderInProgress)
                const SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      color: white,
                      strokeWidth: 1.5,
                    )),
              const SizedBox(
                width: 8,
              ),
              Text('CREATE_SHIPROCKET_ORDER'.translate(context: context)),
            ],
          ),
        );
      },
    );
  }
}
