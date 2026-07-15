import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class ZipcodeRepository {
  // for add faqs.
  static Future<Map<String, dynamic>> setZipCode({
    required int offset,
    required int limit,
    String? search,
    bool skipAuth = false,
  }) async {
    try {
      var parameter = {
        "offset": offset.toString(),
        "limit": limit.toString(),
        if (search != null && search.trim().isNotEmpty) "search": search,
      };
      var zipCodeDetail = await ApiBaseHelper().postAPICall(
        getZipcodesApi,
        parameter,
        skipAuth: skipAuth,
      );

      return zipCodeDetail;
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> getZipcodes({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail = await ApiBaseHelper().postAPICall(
        getZipcodesApi,
        parameter,
      );

      return loginDetail;
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> setZipCodeGroup({
    required int offset,
    required int limit,
    String? search,
    String? ignoreSeller,
    String? sellerId,
  }) async {
    try {
      var parameter = {
        "offset": offset.toString(),
        "limit": limit.toString(),
        if (search != null && search.trim().isNotEmpty) "search": search,
        if (ignoreSeller != null) "ignore_seller": ignoreSeller,
        if (sellerId != null) "seller_id": sellerId,
      };
      var zipCodeGroupDetail = await ApiBaseHelper().postAPICall(
        getZipcodesGroupApi,
        parameter,
      );

      return zipCodeGroupDetail;
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> getZipcodesGroup({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      var loginDetail = await ApiBaseHelper().postAPICall(
        getZipcodesGroupApi,
        parameter,
      );

      return loginDetail;
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }
}
