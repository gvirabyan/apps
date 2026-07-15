import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'package:sellermultivendor/Widget/api.dart';
import '../Model/ZipCodesModel/ZipcodeGroupModel.dart';
import '../Model/ZipCodesModel/ZipCodeModel.dart';
import '../Model/CityModel/CityGroupModel.dart';
import '../Model/city.dart';
import '../Repository/profileRepositry.dart';
import '../Repository/zipcodeRepositry.dart';
import '../Repository/cityListRepository.dart';
import '../Widget/security.dart';
import '../Widget/networkAvailablity.dart';
import '../Widget/parameterString.dart';
import '../Widget/sharedPreferances.dart';
import '../Widget/snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProfileProvider extends ChangeNotifier {
  String? name,
      email,
      mobile,
      address,
      curPass,
      newPass,
      confPass,
      loaction,
      accNo,
      storename,
      storeurl,
      storeDesc,
      accname,
      bankname,
      bankcode,
      latitutute,
      longitude,
      taxname,
      taxnumber,
      pannumber,
      status,
      storelogo,
      authSign,
      lowStockLimit;

  // Deliverability fields
  String? deliverableZipcodeType,
      deliverableZipcodesGroupIds,
      zipcodeDeliveryMethod,
      deliverableCityType,
      deliverableCitiesGroupIds,
      cityDeliveryMethod,
      serviceableZipcodeIds, // IDs for API (e.g., "2,9")
      serviceableZipcodes, // Display values (e.g., "123456, 789012")
      serviceableCityIds, // IDs for API
      serviceableCities; // Display values (e.g., "New York, Los Angeles")

  // Lists for storing selected groups
  List<ZipcodeGroupModel> selectedZipcodeGroups = [];
  List<CityGroupModel> selectedCityGroups = [];
  List<ZipcodeGroupModel> zipcodeSearchGroupsList = [];
  List<CityGroupModel> citySearchGroupsList = [];

  // Lists for storing selected individual zipcodes/cities
  List<ZipCodeModel> selectedZipcodesList = [];
  List<CityModel> selectedCitiesList = [];

  var selectedImageFromGellery, selectedAuthSign, selectstorelogo;
  bool isLoading = true;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<FormState> sellernameKey = GlobalKey<FormState>();
  GlobalKey<FormState> mobilenumberKey = GlobalKey<FormState>();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> addressKey = GlobalKey<FormState>();
  GlobalKey<FormState> storenameKey = GlobalKey<FormState>();
  GlobalKey<FormState> storeurlKey = GlobalKey<FormState>();
  GlobalKey<FormState> storeDescKey = GlobalKey<FormState>();
  GlobalKey<FormState> accnameKey = GlobalKey<FormState>();
  GlobalKey<FormState> accnumberKey = GlobalKey<FormState>();
  GlobalKey<FormState> bankcodeKey = GlobalKey<FormState>();
  GlobalKey<FormState> banknameKey = GlobalKey<FormState>();
  GlobalKey<FormState> latitututeKey = GlobalKey<FormState>();
  GlobalKey<FormState> longituteKey = GlobalKey<FormState>();
  GlobalKey<FormState> taxnameKey = GlobalKey<FormState>();
  GlobalKey<FormState> taxnumberKey = GlobalKey<FormState>();
  GlobalKey<FormState> pannumberKey = GlobalKey<FormState>();
  GlobalKey<FormState> lowStackLimitKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? nameC,
      emailC,
      mobileC,
      addressC,
      storenameC,
      storeurlC,
      storeDescC,
      accnameC,
      accnumberC,
      bankcodeC,
      banknameC,
      latitututeC,
      longituteC,
      taxnameC,
      taxnumberC,
      pannumberC,
      curPassC,
      newPassC,
      confPassC,
      unusedC,
      lowStockLimitC;

  bool isSelected = false, isArea = true;
  bool showCurPassword = false, showPassword = false, showCmPassword = false;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  initializeVariable() {
    name = null;
    email = null;
    mobile = null;
    address = null;
    curPass = null;
    newPass = null;
    confPass = null;
    loaction = null;
    accNo = null;
    storename = null;
    storeurl = null;
    storeDesc = null;
    accname = null;
    bankname = null;
    bankcode = null;
    latitutute = null;
    longitude = null;
    taxname = null;
    taxnumber = null;
    pannumber = null;
    status = null;
    storelogo = null;
    authSign = null;
    lowStockLimit = null;
    selectedImageFromGellery = null;
    selectedAuthSign = null;
    isLoading = true;
    isSelected = false;
    isArea = true;
    showCurPassword = false;
    showPassword = false;
    showCmPassword = false;
    // Deliverability fields
    deliverableZipcodeType = null;
    deliverableZipcodesGroupIds = null;
    zipcodeDeliveryMethod = null;
    deliverableCityType = null;
    deliverableCitiesGroupIds = null;
    cityDeliveryMethod = null;
    serviceableZipcodeIds = null;
    serviceableZipcodes = null;
    serviceableCityIds = null;
    serviceableCities = null;
    selectedZipcodeGroups = [];
    selectedCityGroups = [];
    zipcodeSearchGroupsList = [];
    citySearchGroupsList = [];
    selectedZipcodesList = [];
    selectedCitiesList = [];
  }

  Future<void> getSallerDetail(BuildContext context, Function update) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
      var parameter = {};
      var result = await ProfileRepository.getSallerDetail(
        parameter: parameter,
      );
      bool error = result["error"];
      if (!error) {
        var data = result["data"][0];
        CUR_BALANCE = double.parse(data[BALANCE]).toStringAsFixed(2);
        LOGO = data["logo"].toString();
        RATTING = data[Rating] ?? "";
        NO_OFF_RATTING = data[NoOfRatings] ?? "";
        name = data[Username];
        CUR_USERNAME = data[Username];
        email = data[EmailText];
        EMAIL = data[EmailText];
        mobile = data[Mobile];
        address = data[Address];
        storename = data[StoreName];
        storeurl = data[Storeurl];
        storeDesc = data[storeDescription];
        accNo = data[accountNumber];
        accname = data[accountName];
        bankcode = data[BankCOde];
        bankname = data[bankNAme];
        latitutute = data[Latitude];
        longitude = data[Longitude];
        taxname = data[taxName];
        taxnumber = data[taxNumber];
        pannumber = data[panNumber];
        status = data[STATUS];
        storelogo = data[StoreLogo];
        authSign = data[AuthSign];
        lowStockLimit = data[LOW_STOCK_LIMIT];
        // Deliverability fields
        deliverableZipcodeType =
            data['deliverable_zipcode_type']?.toString() ?? '0';
        deliverableZipcodesGroupIds =
            data['deliverable_zipcodes_group_ids']?.toString() ?? '';
        zipcodeDeliveryMethod =
            data['zipcode_delivery_method']?.toString() ?? '0';
        deliverableCityType = data['deliverable_city_type']?.toString() ?? '0';
        deliverableCitiesGroupIds =
            data['deliverable_cities_group_ids']?.toString() ?? '';
        cityDeliveryMethod = data['city_delivery_method']?.toString() ?? '0';
        // Store IDs from API response
        serviceableZipcodeIds = data['serviceable_zipcodes']?.toString() ?? '';
        serviceableCityIds = data['serviceable_cities']?.toString() ?? '';
        mobileC!.text = mobile ?? "";
        nameC!.text = name ?? "";
        emailC!.text = email ?? "";
        addressC!.text = address ?? "";
        storenameC!.text = storename ?? "";
        storeurlC!.text = storeurl ?? "";
        storeDescC!.text = storeDesc ?? "";
        accnameC!.text = accname ?? "";
        accnumberC!.text = accNo ?? "";
        bankcodeC!.text = bankcode ?? "";
        banknameC!.text = bankname ?? "";
        latitututeC!.text = latitutute ?? "";
        longituteC!.text = longitude ?? "";
        taxnameC!.text = taxname ?? "";
        taxnumberC!.text = taxnumber ?? "";
        pannumberC!.text = pannumber ?? "";
        lowStockLimitC!.text = lowStockLimit ?? "";
      }
      // Load saved deliverability groups
      await loadSavedDeliverabilityGroups(context);

      isLoading = false;
      update();
    } else {
      isNetworkAvail = false;
      isLoading = false;
      update();
    }
    return;
  }

  // Load saved deliverability groups based on stored IDs
  Future<void> loadSavedDeliverabilityGroups(BuildContext context) async {
    try {
      // Load zipcode groups if IDs exist
      if (deliverableZipcodesGroupIds != null &&
          deliverableZipcodesGroupIds!.isNotEmpty) {
        final List<String> savedIds = deliverableZipcodesGroupIds!.split(',');

        // Fetch groups
        var result = await ZipcodeRepository.setZipCodeGroup(
          offset: 0,
          limit: 1000, // Fetch enough to find the selected ones
          search: '',
          ignoreSeller: '1',
        );

        bool error = result['error'] ?? true;
        if (!error && result['data'] != null) {
          selectedZipcodeGroups.clear();
          var data = result['data'] as List;

          final allGroups = data
              .map((item) => ZipcodeGroupModel.fromJson(item))
              .toList();

          // Filter to match saved IDs
          selectedZipcodeGroups.addAll(
            allGroups.where((group) => savedIds.contains(group.id)).toList(),
          );
        }
      }

      // Load city groups if IDs exist
      if (deliverableCitiesGroupIds != null &&
          deliverableCitiesGroupIds!.isNotEmpty) {
        final List<String> savedIds = deliverableCitiesGroupIds!.split(',');

        var result = await CityListRepository.getCitiesGroup(
          parameter: {'limit': '1000', 'offset': '0', 'ignore_seller': '1'},
        );

        bool error = result['error'] ?? true;
        if (!error && result['data'] != null) {
          selectedCityGroups.clear();
          var data = result['data'] as List;

          final allGroups = data
              .map((item) => CityGroupModel.fromJson(item))
              .toList();

          // Filter to match saved IDs
          selectedCityGroups.addAll(
            allGroups.where((group) => savedIds.contains(group.id)).toList(),
          );
        }
      }

      // Load individual zipcodes if IDs exist
      if (serviceableZipcodeIds != null && serviceableZipcodeIds!.isNotEmpty) {
        final List<String> savedIds = serviceableZipcodeIds!
            .split(',')
            .where((id) => id.trim().isNotEmpty)
            .toList();

        if (savedIds.isNotEmpty) {
          var result = await ZipcodeRepository.setZipCode(
            offset: 0,
            limit: 1000,
            skipAuth: true,
          );

          bool error = result['error'] ?? true;
          if (!error && result['data'] != null) {
            selectedZipcodesList.clear();
            var data = result['data'] as List;

            final allZipcodes = data
                .map((item) => ZipCodeModel.fromJson(item))
                .toList();

            // Filter to match saved IDs
            selectedZipcodesList.addAll(
              allZipcodes.where((z) => savedIds.contains(z.id)).toList(),
            );

            // Update display value
            serviceableZipcodes = selectedZipcodesList
                .map((z) => z.zipcode)
                .join(', ');
          }
        }
      }

      // Load individual cities if IDs exist
      if (serviceableCityIds != null && serviceableCityIds!.isNotEmpty) {
        final List<String> savedIds = serviceableCityIds!
            .split(',')
            .where((id) => id.trim().isNotEmpty)
            .toList();

        if (savedIds.isNotEmpty) {
          var result = await CityListRepository.getCities(
            parameter: {'limit': '1000', 'offset': '0'},
            skipAuth: true,
          );

          bool error = result['error'] ?? true;
          if (!error && result['data'] != null) {
            selectedCitiesList.clear();
            var data = result['data'] as List;

            final allCities = data
                .map((item) => CityModel.fromMap(item))
                .toList();

            // Filter to match saved IDs
            selectedCitiesList.addAll(
              allCities.where((c) => savedIds.contains(c.id)).toList(),
            );

            // Update display value
            serviceableCities = selectedCitiesList
                .map((c) => c.name)
                .join(', ');
          }
        }
      }
    } catch (e) {
      print('Error loading saved deliverability groups: $e');
    }
  }

  Future<void> setUpdateUser(BuildContext context, Function update) async {
    var parameter = {
      Name: name ?? "",
      Mobile: mobile ?? "",
      EmailText: email ?? "",
      Address: address ?? "",
      StoreName: storename ?? "",
      Storeurl: storeurl ?? "",
      storeDescription: storeDesc ?? "",
      accountNumber: accNo ?? "",
      accountName: accname ?? "",
      bankCode: bankcode ?? "",
      bankName: bankname ?? "",
      Latitude: latitutute ?? "",
      Longitude: longitude ?? "",
      taxName: taxname ?? "",
      taxNumber: taxnumber ?? "",
      panNumber: pannumber ?? "",
      STATUS: status ?? "1",
      LOW_STOCK_LIMIT: lowStockLimit ?? "",
      // Deliverability fields
      'deliverable_zipcode_type': deliverableZipcodeType ?? "0",
      'deliverable_zipcodes_group_ids[]': selectedZipcodeGroups.isEmpty
          ? ""
          : selectedZipcodeGroups.map((e) => e.id).toList().join(','),
      'deliverable_city_type': deliverableCityType ?? "0",
      'deliverable_cities_group_ids[]': selectedCityGroups.isEmpty
          ? ""
          : selectedCityGroups.map((e) => e.id).toList().join(','),
      'serviceable_zipcodes[]': selectedZipcodesList.isEmpty
          ? ""
          : selectedZipcodesList.map((z) => z.id).join(','),
      'serviceable_cities[]': selectedCitiesList.isEmpty
          ? ""
          : selectedCitiesList.map((c) => c.id).join(','),
    };
    var result = await ProfileRepository.updateUser(parameter: parameter);

    bool error = result["error"];
    String? msg = result["message"];
    if (!error) {
      await buttonController!.reverse();
      setSnackbar(msg!, context);
    } else {
      await buttonController!.reverse();
      setSnackbar(msg!, context);
      update();
    }
  }

  Future<void> updateProfilePic(BuildContext context, Function update) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var request = http.MultipartRequest("POST", updateUserApi);
        request.headers.addAll(headers);
        // request.fields[Id] = context.read<SettingProvider>().CUR_USERID!;
        request.fields[Name] = name ?? "";
        request.fields[Mobile] = mobile ?? "";
        request.fields[EmailText] = email ?? "";
        request.fields[Address] = address ?? "";
        request.fields[StoreName] = storename ?? "";
        request.fields[Storeurl] = storeurl ?? "";
        request.fields[storeDescription] = storeDesc ?? "";
        request.fields[Latitude] = latitutute ?? "";
        request.fields[Longitude] = longitude ?? "";
        request.fields[taxName] = taxname ?? "";
        request.fields[taxNumber] = taxnumber ?? "";
        request.fields[STATUS] = status ?? "1";
        request.fields[LOW_STOCK_LIMIT] = lowStockLimit ?? "";
        // Deliverability fields
        request.fields['deliverable_zipcode_type'] =
            deliverableZipcodeType ?? "0";
        request.fields['deliverable_zipcodes_group_ids[]'] =
            selectedZipcodeGroups.isEmpty
            ? ""
            : selectedZipcodeGroups.map((e) => e.id).toList().join(',');
        request.fields['deliverable_city_type'] = deliverableCityType ?? "0";
        request.fields['deliverable_cities_group_ids[]'] =
            selectedCityGroups.isEmpty
            ? ""
            : selectedCityGroups.map((e) => e.id).toList().join(',');
        request.fields['serviceable_zipcodes[]'] = selectedZipcodesList.isEmpty
            ? ""
            : selectedZipcodesList.map((z) => z.id).join(',');
        request.fields['serviceable_cities[]'] = selectedCitiesList.isEmpty
            ? ""
            : selectedCitiesList.map((c) => c.id).join(',');

        if (selectedImageFromGellery != null) {
          final mimeType = lookupMimeType(selectedImageFromGellery.path);
          var extension = mimeType!.split("/");
          var storelogo = await http.MultipartFile.fromPath(
            "store_logo",
            selectedImageFromGellery.path,
            contentType: MediaType('image', extension[1]),
          );
          request.files.add(storelogo);
        }
        print("authorized sign****$selectedAuthSign");
        if (selectedAuthSign != null) {
          final mimeType = lookupMimeType(selectedAuthSign.path);
          var extension = mimeType!.split("/");
          var authSign = await http.MultipartFile.fromPath(
            AuthSign,
            selectedAuthSign.path,
            contentType: MediaType('image', extension[1]),
          );
          request.files.add(authSign);
        }
        print("updateuser----${request.fields}");
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var getdata = json.decode(responseString);
        print("image getdata****$getdata");
        bool error = getdata["error"];
        String msg = getdata['message'];
        if (!error) {
          setSnackbar(msg, context);
          getSallerDetail(context, update);
        } else {
          setSnackbar(msg, context);
          LOGO = storeLogo;
          isLoading = false;
        }
      } on TimeoutException catch (_) {
        setSnackbar('somethingMSg'.translate(context: context), context);
      }
    } else {
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        isNetworkAvail = false;
        update();
      });
    }
  }

  Future<void> changePassWord(BuildContext context, Function update) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      var parameter = {
        Name: name ?? "",
        Mobile: mobile ?? "",
        EmailText: email ?? "",
        Address: address ?? "",
        StoreName: storename ?? "",
        Storeurl: storeurl ?? "",
        storeDescription: storeDesc ?? "",
        accountNumber: accNo ?? "",
        accountName: accname ?? "",
        bankCode: bankcode ?? "",
        bankName: bankname ?? "",
        Latitude: latitutute ?? "",
        Longitude: longitude ?? "",
        taxName: taxname ?? "",
        taxNumber: taxnumber ?? "",
        panNumber: pannumber ?? "",
        STATUS: status ?? "1",
        OLDPASS: curPass,
        NEWPASS: newPass,
        LOW_STOCK_LIMIT: lowStockLimit,
      };
      var result = await ProfileRepository.updateUser(parameter: parameter);

      bool error = result["error"];
      String? msg = result["message"];
      if (!error) {
        setSnackbar(msg!, context);
      } else {
        setSnackbar(msg!, context);
      }
    } else {
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        await buttonController!.reverse();
        isNetworkAvail = false;
        update();
      });
    }
  }
}
