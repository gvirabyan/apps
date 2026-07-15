import 'dart:developer';

import 'package:deliveryboy_multivendor/Helper/ApiBaseHelper.dart';
import 'package:deliveryboy_multivendor/Model/ReturnOrderModel.dart';
import 'package:deliveryboy_multivendor/Widget/api.dart';

typedef ReturnOrderResult = ({List<ReturnOrderModel> orders, String total});

class ReturnOrdersRepository {
  Future<ReturnOrderResult> fetchOrders(
      {required String offset, String? activeStatus}) async {
    try {
      var parameters = {
        'offset': offset,
        'limit': '10',
      };
      var response =
          await ApiBaseHelper().postAPICall(getReturnOrderApi, parameters);

      List<ReturnOrderModel> orders = (response['data'] as List).map(
        (e) {
          return ReturnOrderModel.fromJson(e);
        },
      ).toList();

      return (
        orders: orders,
        total: response['total'].toString(),
      );
    } catch (e, st) {
      log('Issue is $e and trace is $st');
      rethrow;
    }
  }

  Future<ReturnOrderModel> updateDigitalOrderItemStatus(
      {required String orderItemId, required String status}) async {
    var response = await ApiBaseHelper().postAPICall(ReturnOrderYUpdateStatus, {
      "status": status,
      "order_item_id": orderItemId,
    });
    if (response['error']) {
      throw response['message'];
    }
    return ReturnOrderModel.fromJson((response['data']));
  }
}
