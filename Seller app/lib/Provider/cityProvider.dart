import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import 'package:sellermultivendor/Model/city.dart';
import 'package:sellermultivendor/Model/CityModel/CityGroupModel.dart';
import 'package:sellermultivendor/Repository/cityListRepository.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';

class CityProvider extends ChangeNotifier {
  int offset = 0;
  int total = 0;
  bool isLoadingmore = false;
  bool isLoading = true;
  bool isError = false;
  bool isLoadingMoreError = false;
  String searchString = '';
  String errorString = '';
  List<CityModel> cityList = [];
  List<CityGroupModel> cityGroupList = [];

  Future<void> getCities({
    bool isReload = true,
  }) async {
    if (isLoadingmore == true || (offset >= total && !isReload)) {
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
      var getdata = await CityListRepository.getCities(parameter: parameter);
      bool error = getdata["error"];
      if (!error) {
        total = int.parse(getdata["total"].toString());
        if ((offset) < total) {
          var data = getdata["data"];
          cityList.addAll(
            (data as List).map((data) => CityModel.fromMap(data)).toList(),
          );
          offset = offset + perPage;
        }
      }
    } catch (e) {
      errorString = e.toString();
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

  Future<void> getCitiesGroup({
    bool isReload = true,
    String? ignoreSeller,
    String? sellerId,
  }) async {
    if (isLoadingmore == true || (offset >= total && !isReload)) {
      return;
    }
    if (isReload) {
      cityGroupList.clear();
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
        if (ignoreSeller != null) 'ignore_seller': ignoreSeller,
        if (sellerId != null) 'seller_id': sellerId,
      };
      var getdata = await CityListRepository.getCitiesGroup(
        parameter: parameter,
      );
      bool error = getdata["error"];
      if (!error) {
        total = int.parse(getdata["total"].toString());
        if ((offset) < total) {
          var data = getdata["data"];
          cityGroupList.addAll(
            (data as List)
                .map((data) => CityGroupModel.fromJson(data))
                .toList(),
          );
          offset = offset + perPage;
        }
      }
    } catch (e) {
      errorString = e.toString();
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

  // Future<bool> fetchCityGroups(ProductAction productfrom) async {
  //   try {
  //     var result = await CityListRepository.getCitiesGroup(
  //       parameter: {'offset': '0', 'limit': '100'},
  //     );
  //     bool error = result['error'];
  //     errorString = result['message'];
  //     if (!error) {
  //       var data = result['data'];
  //       if (productfrom == ProductAction.addProduct) {
  //         addProvider!.cityGroupsList = (data as List)
  //             .map((data) => CityGroupModel.fromJson(data))
  //             .toList();
  //       } else {
  //         editProvider!.cityGroupsList = (data as List)
  //             .map((data) => CityGroupModel.fromJson(data))
  //             .toList();
  //       }
  //     }
  //     notifyListeners();
  //     return error;
  //   } catch (e) {
  //     errorString = e.toString();
  //     notifyListeners();
  //     return true;
  //   }
  // }
}
