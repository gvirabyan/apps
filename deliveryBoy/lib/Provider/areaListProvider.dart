import 'package:deliveryboy_multivendor/Model/area.dart';
import 'package:deliveryboy_multivendor/Repository/areaRepository.dart';
import 'package:flutter/material.dart';
import '../Helper/constant.dart';
import '../Widget/parameterString.dart';

class AreaListProvider extends ChangeNotifier {
  List<Area> areaList = [];
  bool isLoading = false;
  bool isError = false;
  String errorString = '';

  Future<void> getAreas({required String cityId}) async {
    areaList.clear();
    isLoading = true;
    isError = false;
    notifyListeners();

    try {
      var parameter = {
        CITY_ID: cityId,
        LIMIT: '100',
        OFFSET: '0',
      };
      var getdata = await AreaListRepository.getAreas(parameter: parameter);
      bool error = getdata["error"];
      if (!error) {
        var data = getdata["data"];
        areaList = (data as List).map((d) => Area.fromMap(d)).toList();
      }
    } catch (e) {
      errorString = e.toString();
      isError = true;
    }

    isLoading = false;
    notifyListeners();
  }

  void clearAreas() {
    areaList.clear();
    notifyListeners();
  }
}
