import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/order/consignment_model.dart';
import 'package:sellermultivendor/Screen/OrderList/Widget/card_with_title_divider.dart';
import 'package:sellermultivendor/Widget/desing.dart';

/// Order Overview Card - displays parcel details
class OrderOverviewCard extends StatelessWidget {
  final ConsignmentModel consignment;

  const OrderOverviewCard({super.key, required this.consignment});

  @override
  Widget build(BuildContext context) {
    return CardWithTitleDivider(
      title: 'Order Overview'.translate(context: context),
      child: Column(
        children: [
          _buildDetailRow(
            title: 'parcel_id'.translate(context: context),
            content: consignment.id,
          ),
          _buildDetailRow(
            title: 'parcel_date'.translate(context: context),
            content: consignment.createdDate,
          ),
          _buildDetailRow(
            title: 'PAYMENT_MTHD'.translate(context: context),
            content: consignment.paymentMethod,
          ),
          if (consignment.deliveryDate != null &&
              consignment.deliveryDate != 'null' &&
              consignment.deliveryDate.isNotEmpty)
            _buildDetailRow(
              title: 'preferred_delivery_date'.translate(context: context),
              content: consignment.deliveryDate,
            ),
          if (consignment.deliveryTime != null &&
              consignment.deliveryTime != 'null' &&
              consignment.deliveryTime.isNotEmpty)
            _buildDetailRow(
              title: 'preferred_delivery_time'.translate(context: context),
              content: consignment.deliveryTime,
            ),
          if (consignment.trackingDetails != null &&
              consignment.isShiprocketOrderCreatedBool) ...[
            _buildDetailRow(
              title: 'shiprocket_order_id'.translate(context: context),
              content: consignment.trackingDetails!.shiprocketOrderId ?? '',
            ),
            _buildDetailRow(
              title: 'shiprocket_tracking_id'.translate(context: context),
              content: consignment.trackingDetails!.trackingId ?? '',
            ),
          ],
        ],
      ),
    );
  }
}

Widget _buildDetailRow({required String title, required String content}) {
  if (content.trim().isEmpty) {
    return const SizedBox();
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, overflow: TextOverflow.ellipsis, maxLines: 1),
        Flexible(
          child: Text(content, overflow: TextOverflow.ellipsis, maxLines: 1),
        ),
      ],
    ),
  );
}

/// Shipping Details Card - displays customer address and contact
class ShippingDetailsCard extends StatelessWidget {
  final ConsignmentModel consignment;

  const ShippingDetailsCard({super.key, required this.consignment});

  @override
  Widget build(BuildContext context) {
    return CardWithTitleDivider(
      title: 'SHIPPING_DETAIL'.translate(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(consignment.username.firstUpperCase()).bold(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(consignment.userAddress),
          ),
          if (consignment.cityName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('${"City".translate(context: context)}: ${consignment.cityName}'),
            ),
          if (consignment.areaName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('${"Area".translate(context: context)}: ${consignment.areaName}'),
            ),
          Text(
            '${"phone_number".translate(context: context)}: ${consignment.mobile}',
          ),
        ],
      ),
    );
  }
}

/// Price Details Card - displays pricing breakdown
class PriceDetailsCard extends StatelessWidget {
  final ConsignmentModel consignment;

  const PriceDetailsCard({super.key, required this.consignment});

  @override
  Widget build(BuildContext context) {
    return CardWithTitleDivider(
      title: 'PRICE_DETAIL'.translate(context: context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            title: 'price'.translate(context: context),
            content: DesignConfiguration.getPriceFormat(
              context,
              consignment.total.toDouble(),
            )!,
          ),
          _buildDetailRow(
            title: 'delivery_charge'.translate(context: context),
            content: DesignConfiguration.getPriceFormat(
              context,
              consignment.deliveryCharge.toDouble(),
            )!,
          ),
          _buildDetailRow(
            title: 'promocd'.translate(context: context),
            content: DesignConfiguration.getPriceFormat(
              context,
              consignment.promoDiscount.toDouble(),
            )!,
          ),
          _buildDetailRow(
            title: 'wallet_balance'.translate(context: context),
            content: DesignConfiguration.getPriceFormat(
              context,
              consignment.walletBalance.toDouble(),
            )!,
          ),
          const Divider(height: 0, indent: 0, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('total'.translate(context: context)).size(16),
              Text(
                DesignConfiguration.getPriceFormat(
                  context,
                  consignment.totalPayable.toDouble(),
                )!,
              ).size(16),
            ],
          ),
        ],
      ),
    );
  }
}
