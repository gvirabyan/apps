import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sellermultivendor/Helper/assetsConstant.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Screen/HomePage/home.dart';

import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

enum OrderStatus {
  orders('assets/images/SVG/${Assets.allOrders}.svg'),
  received('assets/images/SVG/${Assets.received}.svg'),
  processed('assets/images/SVG/${Assets.processed}.svg'),
  assigned('assets/images/SVG/${Assets.assigned}.svg'),
  shipped('assets/images/SVG/${Assets.shipped}.svg'),
  delivered('assets/images/SVG/${Assets.delivered}.svg'),
  cancelled('assets/images/SVG/${Assets.cancelled}.svg'),
  returned('assets/images/SVG/${Assets.returned}.svg'),
  awaiting('assets/images/SVG/${Assets.awaiting}.svg');

  final String assetIconSvgPath;

  const OrderStatus(this.assetIconSvgPath);

  String? get apiValue {
    switch (this) {
      case OrderStatus.orders:
        return 'orders';
      case OrderStatus.received:
        return 'received';
      case OrderStatus.processed:
        return 'processed';
      case OrderStatus.assigned:
        return 'assigned';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.returned:
        return 'returned';
      case OrderStatus.awaiting:
        return 'awaiting';
    }
  }
}

typedef OrderResult = ({
  List<OrderModel> orders,
  List<Map<OrderStatus, String>> statusData,
  String total
});

class OrdersRepository {
  Future<OrderModel> fetchOrderById(String id) async {
    try {
      Map<String, String> parameter = {'id': id};
      var response =
          await ApiBaseHelper().postAPICall(getOrdersApi, parameter);

      OrderModel order = OrderModel.fromJson(response['data'][0]);

      return order;
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }

  Future<OrderResult> fetchOrders(
      {required String offset,
      String? searchString,
      DateTimeRange? dateRange,
      String? orderType,
      String? activeStatus}) async {
    try {
      var parameters = {
        'offset': offset,
        'limit': '10',
        if (searchString != null) 'search': searchString,
        if (activeStatus != null && activeStatus != "orders")
          'active_status': activeStatus,
        if (dateRange != null)
          'start_date': DateFormat('yyyy/MM-dd').format(dateRange.start),
        if (dateRange != null)
          'end_date': DateFormat('yyyy/MM-dd').format(dateRange.end),
        if (orderType != null) 'order_type': orderType,
      };
      var response =
          await ApiBaseHelper().postAPICall(getOrdersApi, parameters);

      List<OrderModel> orders = (response['data'] as List).map(
        (e) {
          return OrderModel.fromJson(e);
        },
      ).toList();

      return (
        orders: orders,
        total: response['total'].toString(),
        statusData: [
          {
            OrderStatus.orders: response['total'].toString(),
          },
          {
            OrderStatus.received: response['received'].toString(),
          },
          {
            OrderStatus.processed: response['processed'].toString(),
          },
          {
            OrderStatus.assigned: (response['assigned'] ?? '0').toString(),
          },
          {
            OrderStatus.shipped: response['shipped'].toString(),
          },
          {
            OrderStatus.delivered: response['delivered'].toString(),
          },
          {
            OrderStatus.cancelled: response['cancelled'].toString(),
          },
          {
            OrderStatus.returned: response['returned'].toString(),
          },
          {
            OrderStatus.awaiting: response['awaiting'].toString(),
          }
        ]
      );
    } catch (e, st) {
      log('Issue is $e and trace is $st');
      rethrow;
    }
  }

  Future<OrderModel> updateDigitalOrderItemStatus(
      {required String orderID,
      required String status,
      required String itemId}) async {
    Map<String, String> parameter = {
      "order_id": orderID,
      "status": status,
      "order_item_ids": itemId,
    };
    var response = await apiBaseHelper.postAPICall(digitalOrderStatusUpdate, parameter);
    if (response['error']) {
      throw response['message'];
    }
    return OrderModel.fromJson((response['data']));
  }

  static Future<void> editOrderTracking({
    required String consignmentId,
    required String courierAgency,
    required String trackingId,
    required String url,
  }) async {
    try {
      final parameters = {
        'consignment_id': consignmentId,
        'courier_agency': courierAgency,
        'tracking_id': trackingId,
        'url': url,
      };
      return await ApiBaseHelper()
          .postAPICall(editOrderTrackingApi, parameters);
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }
}
