import 'dart:core';
import 'package:deliveryboy_multivendor/Helper/ApiBaseHelper.dart';
import 'package:deliveryboy_multivendor/Widget/api.dart';
import 'package:deliveryboy_multivendor/Widget/translateVariable.dart';

class NotificationRepository {
  static Future<Map<String, dynamic>> updateFcmID({
    required var parameter,
  }) async {
    try {
      print(parameter);
      var responseData =
          await ApiBaseHelper().postAPICall(getFundTransferApi, parameter);

      print(responseData);

      return responseData;
    } on Exception catch (e) {
      throw ApiException('$somethingMSg${e.toString()}');
    }
  }
}
