import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class CityListRepository {
  static Future<Map<String, dynamic>> getCities({
    required Map<String, dynamic> parameter,
    bool skipAuth = false,
  }) async {
    try {
      return await ApiBaseHelper().postAPICall(getCitiesApi, parameter, skipAuth: skipAuth);
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }

  static Future<Map<String, dynamic>> getCitiesGroup({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      return await ApiBaseHelper().postAPICall(getCitiesGroupApi, parameter);
    } on Exception catch (e) {
      throw ApiException(e.toString());
    }
  }
}
