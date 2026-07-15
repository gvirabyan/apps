import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';
import '../Widget/translateVariable.dart';

class AreaListRepository {
  static Future<Map<String, dynamic>> getAreas({
    required Map<String, dynamic> parameter,
  }) async {
    try {
      return await ApiBaseHelper().postAPICall(getAreasApi, parameter);
    } on Exception catch (e) {
      throw ApiException('$somethingMSg${e.toString()}');
    }
  }
}
