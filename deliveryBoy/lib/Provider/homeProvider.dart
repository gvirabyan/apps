import 'dart:async';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Model/orderModel.dart';
import 'package:flutter/material.dart';
import '../Helper/constant.dart';
import '../Repository/homeRepositry.dart';
import '../Screens/Authentication/LoginScreen.dart';
import '../Screens/Home/Widget/getMaintenanceDialog.dart';
import '../Screens/Home/home.dart';
import '../Widget/networkAvailablity.dart';
import '../Widget/parameterString.dart';
import '../Widget/setSnackbar.dart';
import '../Widget/translateVariable.dart';

class HomeProvider extends ChangeNotifier {
  int curDrwSel = 0;
  List<OrderModel> orderList = [];
  int currentIndex = 0;
  String? verifyPassword;
  String? mobileNumber;
  bool isLoadingmore = true;
  // String? errorTrueMessage;
  bool isLoadingItems = true;
  FocusNode? passFocus = FocusNode();
  TextEditingController passwordController = TextEditingController();

  List<OrderModel> tempList = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String? profile;
  ScrollController controller = ScrollController();
  int? total, offset;
  bool isLoading = true;
  List<String> statusList = [
    ALL,
    PLACED,
    PROCESSED,
    ASSIGNED,
    SHIPED,
    DELIVERD,
    CANCLED,
    RETURNED,
    awaitingPayment
  ];
  String activeStatus = "";

  String? filterCityId;
  String? filterCityName;
  String? filterAreaId;
  String? filterAreaName;

  List<OrderModel> get displayList {
    if (filterCityName == null && filterAreaName == null) return orderList;
    return orderList.where((order) {
      final cityMatch = filterCityName == null || order.city == filterCityName;
      final areaMatch = filterAreaName == null || order.areaName == filterAreaName;
      return cityMatch && areaMatch;
    }).toList();
  }

//==============================================================================
//============================= For Language Selection =========================
  int? selectLan;
  // List<String> langCode = [
  //   ENGLISH,
  //   HINDI,
  //   CHINESE,
  //   SPANISH,
  //   ARABIC,
  //   RUSSIAN,
  //   JAPANESE,
  //   DEUTSCH
  // ];

  String? all,
      received,
      orderTrackingTotal,
      processed,
      assigned,
      shipped,
      delivered,
      cancelled,
      returned,
      awaiting;
  Future<Null> getOrder(
    Function update,
    BuildContext context,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        CUR_USERID = await settingProvider!.getPrefrence(ID) ?? "";
        CUR_USERNAME = await settingProvider!.getPrefrence(USERNAME);
        if (offset == 0) {
          orderList = [];
        }
        var parameter = {LIMIT: perPage.toString(), OFFSET: offset.toString()};
        if (activeStatus != "") {
          if (activeStatus == awaitingPayment) {
            activeStatus = "awaiting";
          }
          parameter[ACTIVE_STATUS] = activeStatus;
        }
        if (filterCityId != null && filterCityId!.isNotEmpty) {
          parameter[CITY_ID] = filterCityId!;
        }
        if (filterAreaId != null && filterAreaId!.isNotEmpty) {
          parameter[AREA_ID] = filterAreaId!;
        }
        var getdata = await HomeRepository.getOrders(
          parameter: parameter,
        );

        bool error = getdata["error"];
        if (activeStatus != "") {
          total = int.parse(getdata[activeStatus]?.toString() ?? '0');
        } else {
          total = int.parse(getdata['total']?.toString() ?? '0');
        }

        if (!error) {
          if (offset! < total!) {
            all = getdata["total"];
            received = getdata["received"];
            processed = getdata["processed"];
            assigned = getdata["assigned"];
            shipped = getdata["shipped"];
            delivered = getdata["delivered"];
            cancelled = getdata["cancelled"];
            returned = getdata["returned"];
            awaiting = getdata["awaiting"];
            tempList.clear();

            var data = getdata["data"];

            tempList = (data as List)
                .map((data) => OrderModel.fromJson(data))
                .toList();

            orderList.addAll(tempList);

            offset = offset! + perPage;
          }
          isLoading = false;
          isLoadingItems = false;
          update();
        } else {
          isLoading = false;
          isLoadingItems = false;
          update();
        }
      } catch (_) {
        setSnackbar(somethingMSg, context);
        isLoading = false;
        isLoadingItems = false;
        update();
      }
    } else {
      isNetworkAvail = false;
      isLoading = false;
      isLoadingItems = false;
      update();
    }

    return null;
  }

  Future<void> getSetting(BuildContext context) async {
    try {
      CUR_USERID = await settingProvider!.getPrefrence(ID);

      var parameter = {TYPE: CURRENCY};
      var getdata = await HomeRepository.getSettings(
        parameter: parameter,
      );

      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        CUR_CURRENCY = getdata["currency"];
        DECIMAL_POINTS = getdata['decimal_point'];
        supportedLocale = getdata['supported_locals'];
        IS_APP_UNDER_MAINTENANCE =
            getdata['is_delivery_boy_app_under_maintenance'];
        MAINTENANCE_MESSAGE = getdata['message_for_delivery_boy_app'];
        IS_DELIVERY_BOY_OTP_IS_ON =
            getdata['system_settings']['is_delivery_boy_otp_setting_on'];

        if (IS_APP_UNDER_MAINTENANCE == "1") {
          AppMaintenanceDialog.appMaintenanceDialog(context);
        }
      } else {
        setSnackbar(msg!, context);
      }
    } on TimeoutException catch (_) {
      setSnackbar(somethingMSg.translate(context: context), context);
    }
  }

  Future<void> getUserDetail(
    Function update,
    BuildContext context,
  ) async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        CUR_USERID = await settingProvider!.getPrefrence(ID);
        homeProvider!.mobileNumber =
            await settingProvider!.getPrefrence(MOBILE);
        Map<String, dynamic> parameter = {
          // ID: CUR_USERID
        };
        var getdata = await HomeRepository.getUserDetail(
          parameter: parameter,
        );

        bool error = getdata["error"];
        print("getdata user*****$getdata******$parameter****");
        if (!error) {
          var data = getdata["data"][0];
          CUR_BALANCE = double.parse(data[BALANCE]).toString();
          EMAILID = data[EMAIL];
          CUR_BONUS = data[BONUS];
          CUR_DRIVING_LICENSE = data[DRIVING_LICENSE];
          settingProvider!
              .setListPrefrence(DRIVING_LICENSE, CUR_DRIVING_LICENSE);
        }
        homeProvider!.isLoading = false;

        update();
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg.translate(context: context), context);

        homeProvider!.isLoading = false;
        update();
      }
    } else {
      isNetworkAvail = false;
      homeProvider!.isLoading = false;
      update();
    }

    return null;
  }

  Future<void> deleteAccountAPI(
    String mobile,
    Function update,
    BuildContext context,
  ) async {
    var data = {
      // "user_id": CUR_USERID,
      "mobile": mobile,
      "password": homeProvider!.verifyPassword
    };
    print("parameter :$data");
    var getdata = await HomeRepository.deleteAccountAPI(
      parameter: data,
    );

    bool error = getdata['error'];
    String? msg = getdata['message'];
    print(getdata);
    if (!error) {
      homeProvider!.currentIndex = 0;
      homeProvider!.verifyPassword = "";
      homeProvider!.passwordController.text = "";
      setSnackbar(msg!, context);
      settingProvider!.clearUserSession(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
          (Route<dynamic> route) => false);
    } else {
      // homeProvider!.errorTrueMessage = msg;
      Navigator.pop(context);
      homeProvider!.currentIndex == 0;
      update();
      homeProvider!.verifyPassword = "";
      homeProvider!.passwordController.text = "";
      setSnackbar(msg!, context);
    }
  }
}
