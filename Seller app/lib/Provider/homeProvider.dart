import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Provider/settingProvider.dart';
import 'dart:math';
import '../Widget/parameterString.dart';
import '../Repository/homeRepositry.dart';
import '../Screen/HomePage/home.dart';
import '../Widget/sharedPreferances.dart';

enum HomeProviderStatus {
  initial,
  inProgress,
  isSuccsess,
  isFailure,
  isMoreLoading,
}

class HomeProvider extends ChangeNotifier {
  HomeProviderStatus _systemProviderPolicyStatus = HomeProviderStatus.initial;

  String errorMessage = '';
  String grandFinalTotalOfSales = "";

  String? totalorderCount,
      totalproductCount,
      totalcustCount,
      totaldelBoyCount,
      totalsoldOutCount,
      totallowStockCount;
  int? overallSale;
  // String totalSalesAmount = '0';
  List? weekEarning = [],
      days = [],
      dayEarning = [],
      months = [],
      monthEarning = [],
      catCountList = [],
      catList = [],
      weeks = [];
  get getCurrentStatus => _systemProviderPolicyStatus;

  changeStatus(HomeProviderStatus status) {
    _systemProviderPolicyStatus = status;
    notifyListeners();
  }

  //get Sales Report Request
  Future allocateAllData(BuildContext context) async {
    context.read<SettingProvider>().CUR_USERID = await getPrefrence(Id);
    try {
      changeStatus(HomeProviderStatus.inProgress);
      Map<String, dynamic> parameter = {
        // SellerId: context.read<SettingProvider>().currentUerID,
      };
      var totalOFSales = await HomeRepository.fetchSalesReport(
        parameter: parameter,
      );

      grandFinalTotalOfSales = totalOFSales;
      var getStatics = await HomeRepository.fetchGetStatics(
        parameter: parameter,
      );

      CUR_CURRENCY = getStatics["currency_symbol"]?.toString() ?? '';
      var counts = getStatics['counts'];
      var count = (counts != null && counts.isNotEmpty) ? counts[0] : {};
      totalorderCount = count["order_counter"]?.toString() ?? '0';
      totalproductCount = count["product_counter"]?.toString() ?? '0';
      totalsoldOutCount = count['count_products_sold_out_status']?.toString() ?? '0';
      totallowStockCount = count["count_products_low_status"]?.toString() ?? '0';
      totalcustCount = count["user_counter"]?.toString() ?? '0';
      delPermission = count["permissions"] != null
          ? count["permissions"]['assign_delivery_boy']?.toString()
          : null;
      customerViewPermission =
          count["permissions"] != null &&
          count["permissions"]['customer_privacy'] == "1";

      var earnings = getStatics['earnings'];
      var earning = (earnings != null && earnings.isNotEmpty) ? earnings[0] : {};
      overallSale = int.tryParse(earning["overall_sale"]?.toString() ?? '0') ?? 0;

      var weeklyEarnings = earning["weekly_earnings"];
      weekEarning = weeklyEarnings?['total_sale'] ?? [];
      weeks = weeklyEarnings?['week'] ?? [];

      var dailyEarnings = earning["daily_earnings"];
      days = dailyEarnings?['day'] ?? [];
      dayEarning = dailyEarnings?['total_sale'] ?? [];

      var monthlyEarnings = earning["monthly_earnings"];
      months = monthlyEarnings?['month_name'] ?? [];
      monthEarning = monthlyEarnings?['total_sale'] ?? [];

      var temp = getStatics['category_wise_product_count'];
      if (temp != null && temp.toString() != "[]") {
        catCountList = temp['counter'] ?? [];
        catList = temp['cat_name'] ?? [];
        colorList.clear();
        for (int i = 0; i < catList!.length; i++) {
          colorList.add(generateRandomColor());
        }
      }

      changeStatus(HomeProviderStatus.isSuccsess);
    } catch (e) {
      errorMessage = e.toString();

      changeStatus(HomeProviderStatus.isFailure);
    }
  }

  // Future<void> getSalesReportRequest(
  //   BuildContext context,
  // ) async {
  //   isNetworkAvail = await isNetworkAvailable();
  //   if (isNetworkAvail) {
  //     var parameter = {
  //       // SellerId: context.read<SettingProvider>().CUR_USERID,
  //     };
  //     var result = await SalesReportRepository.getSalesReportRequest(
  //       parameter: parameter,
  //     );
  //     print("result****$result");
  //     bool error = result["error"];
  //     if (!error) {
  //       totalSalesAmount = result["total_delivery_charge"];
  //     } else {
  //       totalSalesAmount = '0';
  //     }
  //   } else {}
  // }

  Color generateRandomColor() {
    Random random = Random();
    // Pick a random number in the range [0.0, 1.0)
    double randomDouble = random.nextDouble();

    return Color((randomDouble * 0xFFFFFF).toInt()).withValues(alpha: 1.0);
  }
}
