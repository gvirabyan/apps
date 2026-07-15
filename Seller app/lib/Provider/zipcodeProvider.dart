import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/Constant.dart';
import '../Model/ZipCodesModel/ZipCodeModel.dart';
import '../Model/ZipCodesModel/ZipcodeGroupModel.dart';
import '../Repository/zipcodeRepositry.dart';
import '../Screen/AddProduct/Add_Product.dart';
import '../Screen/EditProduct/EditProduct.dart';

enum ProductAction { addProduct, editProduct, signup }

class ZipcodeProvider extends ChangeNotifier {
  int offset = 0;
  int total = 0;
  String errorMessage = '';
  String searchString = '';

  List<ZipCodeModel> zipcodeList = [];
  List<ZipcodeGroupModel> zipcodeGroupList = [];

  Future<bool> setZipCode(
    ProductAction productfrom, {
    bool isRefresh = true,
  }) async {
    if (isRefresh) {
      offset = 0;

      if (productfrom == ProductAction.addProduct) {
        addProvider!.zipSearchList.clear();
      } else if (productfrom == ProductAction.signup) {
        zipcodeList.clear();
      } else {
        editProvider!.zipSearchList.clear();
      }
      notifyListeners();
    } else {
      // Check if we already have all the data
      if (productfrom == ProductAction.addProduct) {
        if (addProvider!.zipSearchList.length >= total) {
          return false; // Already have all items
        }
      } else if (productfrom == ProductAction.signup) {
        if (zipcodeList.length >= total) {
          return false; // Already have all items
        }
      } else {
        if (editProvider!.zipSearchList.length >= total) {
          return false; // Already have all items
        }
      }
      notifyListeners();
    }
    try {
      var result = await ZipcodeRepository.setZipCode(
        offset: offset,
        limit: 10,
        search: searchString,
      );
      bool error = result['error'];
      errorMessage = result['message'];
      if (!error) {
        total = int.parse(result["total"].toString());
        if (offset < total) {
          var data = result['data'];
          if (productfrom == ProductAction.addProduct) {
            addProvider!.zipSearchList.addAll(
              (data as List)
                  .map((data) => ZipCodeModel.fromJson(data))
                  .toList(),
            );
          } else if (productfrom == ProductAction.signup) {
            zipcodeList.addAll(
              (data as List)
                  .map((data) => ZipCodeModel.fromJson(data))
                  .toList(),
            );
          } else {
            editProvider!.zipSearchList.addAll(
              (data as List)
                  .map((data) => ZipCodeModel.fromJson(data))
                  .toList(),
            );
          }
        }
      }
      notifyListeners();
      return error;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return true;
    }
  }

  Future<bool> setZipCodeGroup(
    ProductAction productfrom, {
    bool isRefresh = true,
    String? ignoreSeller,
    String? sellerId,
  }) async {
    if (isRefresh) {
      offset = 0;

      if (productfrom == ProductAction.addProduct) {
        addProvider!.zipcodeSearchGroupsList.clear();
      } else if (productfrom == ProductAction.signup) {
        zipcodeGroupList.clear();
      } else {
        editProvider!.zipcodeSearchGroupsList.clear();
      }
      notifyListeners();
    } else {
      // Check if we already have all the data
      if (productfrom == ProductAction.addProduct) {
        if (addProvider!.zipcodeSearchGroupsList.length >= total) {
          return false; // Already have all items
        }
      } else if (productfrom == ProductAction.signup) {
        if (zipcodeGroupList.length >= total) {
          return false; // Already have all items
        }
      } else {
        if (editProvider!.zipcodeSearchGroupsList.length >= total) {
          return false; // Already have all items
        }
      }
      notifyListeners();
    }
    try {
      var result = await ZipcodeRepository.setZipCodeGroup(
        offset: offset,
        limit: perPage,
        search: searchString,
        ignoreSeller: ignoreSeller,
        sellerId: sellerId,
      );
      bool error = result['error'];
      errorMessage = result['message'];
      if (!error) {
        total = int.parse(result["total"].toString());
        if (offset < total) {
          var data = result['data'] as List;
          if (productfrom == ProductAction.addProduct) {
            addProvider!.zipcodeSearchGroupsList.addAll(
              data.map((data) => ZipcodeGroupModel.fromJson(data)).toList(),
            );
          } else if (productfrom == ProductAction.signup) {
            zipcodeGroupList.addAll(
              data.map((data) => ZipcodeGroupModel.fromJson(data)).toList(),
            );
          } else {
            editProvider!.zipcodeSearchGroupsList.addAll(
              data.map((data) => ZipcodeGroupModel.fromJson(data)).toList(),
            );
          }
          // Increment offset for pagination
          offset = offset + perPage;
        }
      }
      notifyListeners();
      return error;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return true;
    }
  }
}
