import 'dart:async';
import 'package:deliveryboy_multivendor/Model/city.dart';
import 'package:deliveryboy_multivendor/Repository/cityRepository.dart';
import 'package:flutter/material.dart';
import '../Helper/constant.dart';
import '../Widget/parameterString.dart';

class CityListProvider extends ChangeNotifier {
  List<City> cityList = [];
  int offset = 0;
  int total = 0;
  bool isLoadingmore = false;
  bool isLoading = false;
  bool isError = false;
  bool isLoadingMoreError = false;
  String searchString = '';
  String errorString = '';

  Future<void> getCities({bool isReload = true}) async {
    debugPrint('[CityListProvider] getCities called | isReload=$isReload | isLoadingmore=$isLoadingmore | offset=$offset | total=$total');
    if (isLoadingmore == true || (offset >= total && !isReload)) {
      debugPrint('[CityListProvider] early return — skipped');
      return;
    }
    if (isReload) {
      cityList.clear();
      offset = 0;
      isLoading = true;
    } else {
      isLoadingmore = true;
    }
    notifyListeners();

    try {
      var parameter = {
        LIMIT: perPage.toString(),
        OFFSET: offset.toString(),
        if (searchString.trim().isNotEmpty) SEARCH: searchString,
      };
      debugPrint('[CityListProvider] API request params: $parameter');
      var getdata = await CityListRepository.getCities(
        parameter: parameter,
      );
      debugPrint('[CityListProvider] API response: $getdata');
      bool error = getdata["error"];
      if (!error) {
        total = int.parse(getdata["total"].toString());
        if ((offset) < total) {
          var data = getdata["data"];
          cityList.addAll((data as List)
              .map(
                (data) => City.fromMap(data),
              )
              .toList());
          offset = offset + perPage;
        }
        debugPrint('[CityListProvider] loaded ${cityList.length} cities | total=$total');
      } else {
        debugPrint('[CityListProvider] API returned error=true');
      }
    } catch (e) {
      errorString = e.toString();
      debugPrint('[CityListProvider] EXCEPTION: $e');
      if (isReload) {
        isError = true;
      } else {
        isLoadingMoreError = true;
      }
    }

    if (isReload) {
      isLoading = false;
    } else {
      isLoadingmore = false;
    }
    notifyListeners();
  }
}
