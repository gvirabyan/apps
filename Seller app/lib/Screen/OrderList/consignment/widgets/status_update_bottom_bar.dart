import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/assetsConstant.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/delivery_boy_model.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Repository/ordeListRepositry.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/deliveryboy_selection_sheet.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/select_status_bottomsheet.dart';
import 'package:sellermultivendor/Widget/desing.dart';
import 'package:sellermultivendor/cubits/deliveryboy/fetch_deliveryboy_cubit.dart';
import 'package:sellermultivendor/cubits/order/update_consignment_status_cubit.dart';
import 'package:sellermultivendor/main.dart';

/// Bottom bar for updating order status
class StatusUpdateBottomBar extends StatefulWidget {
  final ConsignmentModel consignment;
  final Function(OrderStatus?, DeliveryBoy?) onStatusChanged;
  final VoidCallback onUpdatePressed;

  const StatusUpdateBottomBar({
    super.key,
    required this.consignment,
    required this.onStatusChanged,
    required this.onUpdatePressed,
  });

  @override
  State<StatusUpdateBottomBar> createState() => _StatusUpdateBottomBarState();
}

class _StatusUpdateBottomBarState extends State<StatusUpdateBottomBar> {
  OrderStatus? selectedOrderStatus;
  DeliveryBoy? selectedDeliveryBoy;

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
            SizedBox(
              width: context.screenWidth * 00.9,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDropdownCard(
                    title: selectedOrderStatus == null
                        ? 'update_status'.translate(context: context)
                        : selectedOrderStatus!.name.toString().firstUpperCase(),
                    onTap: () async {
                      selectedOrderStatus = await showModalBottomSheet(
                        isDismissible: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        context: rootNavigatorKey.currentContext!,
                        builder: (context) {
                          return SelectStatusBottomSheet(
                            selectedOrderStatus: selectedOrderStatus,
                            currentOrderStatus: OrderStatus.values
                                .byName(widget.consignment.activeStatus),
                          );
                        },
                      );
                      setState(() {
                        widget.onStatusChanged(
                            selectedOrderStatus, selectedDeliveryBoy);
                      });
                    },
                  ),
                  Container(
                    width: 2,
                    height: 32,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: lightWhite,
                  ),
                  _buildDropdownCard(
                    title: selectedDeliveryBoy != null
                        ? selectedDeliveryBoy!.name.firstUpperCase()
                        : 'DELIVERY_BOY'.translate(context: context),
                    onTap: () async {
                      selectedDeliveryBoy = await showModalBottomSheet(
                        isDismissible: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        isScrollControlled: true,
                        constraints: BoxConstraints(
                          minHeight: context.screenHeight * 0.6,
                          maxHeight: context.screenHeight * 0.9,
                        ),
                        context: rootNavigatorKey.currentContext!,
                        builder: (context) {
                          return BlocProvider(
                            create: (context) => FetchDeliveryboyCubit(),
                            child: const DeliveryboySelectionSheet(),
                          );
                        },
                      );
                      setState(() {
                        widget.onStatusChanged(
                            selectedOrderStatus, selectedDeliveryBoy);
                      });
                    },
                  ),
                ],
              ),
            ),
            MaterialButton(
              textColor: white,
              height: 41,
              disabledColor: primary.withValues(alpha: 0.8),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              minWidth: context.screenWidth * 00.9,
              onPressed: context.watch<UpdateConsignmentStatusCubit>().state
                      is! UpdateConsignmentStatusInProgress
                  ? widget.onUpdatePressed
                  : null,
              color: primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (context.watch<UpdateConsignmentStatusCubit>().state
                      is UpdateConsignmentStatusInProgress)
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
                  Text('update_status'.translate(context: context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownCard(
      {required String title, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onTap.call();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: Text(title).setMaxLines(lines: 1).centerAlign()),
            SvgPicture.asset(
                DesignConfiguration.setNewSvgPath(Assets.downArrow)),
            const SizedBox(
              width: 5,
            )
          ],
        ),
      ),
    );
  }
}
