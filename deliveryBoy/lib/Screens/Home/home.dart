import 'dart:async';
import 'package:deliveryboy_multivendor/Helper/assetsConstant.dart';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/constant.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Helper/push_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../Provider/SettingsProvider.dart';
import '../../Provider/homeProvider.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/simmerEffect.dart';
import '../../Widget/translateVariable.dart';
import 'Widget/DetailHeader.dart';
import 'Widget/orderIteam.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateHome();
  }
}

SettingProvider? settingProvider;
HomeProvider? homeProvider;
int currentSelected = 0;

class StateHome extends State<Home> with TickerProviderStateMixin {
  setStateNow() {
    setState(() {});
  }

  //==============================================================================
//============================= For Animation ==================================

  @override
  void initState() {
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    settingProvider = Provider.of<SettingProvider>(context, listen: false);
    homeProvider!.offset = 0;
    homeProvider!.total = 0;
    currentSelected = 0;
    homeProvider!.isLoading = true;
    homeProvider!.isLoadingItems = true;
    homeProvider!.orderList.clear();
    homeProvider!.getSetting(context);
    homeProvider!.getOrder(setStateNow, context);
    homeProvider!.getUserDetail(setStateNow, context);
    PushNotificationService.context = context;
    PushNotificationService.init();
    homeProvider!.buttonController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    homeProvider!.buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: homeProvider!.buttonController!,
        curve: Interval(
          0.0,
          0.150,
        ),
      ),
    );
    homeProvider!.controller.addListener(_scrollListener);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: homeProvider!.scaffoldKey,
        backgroundColor: lightWhite,
        body: isNetworkAvail
            ? homeProvider!.isLoading || supportedLocale == null
                ? const ShimmerEffect()
                : RefreshIndicator(
                    key: homeProvider!.refreshIndicatorKey,
                    onRefresh: _refresh,
                    child: SingleChildScrollView(
                      controller: homeProvider!.controller,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [grad1Color, grad2Color],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0, 1],
                                tileMode: TileMode.clamp,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    circularBorderRadius10), // Adjust the radius as needed
                                bottomRight: Radius.circular(
                                    circularBorderRadius10), // Adjust the radius as needed
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                SafeArea(
                                  child: SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        bottom: 10,
                                        top: 9.0,
                                        start: 15,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 0.0, right: 15),
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: primary,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          circularBorderRadius100),
                                                  border: Border.all(
                                                      color: primary),
                                                ),
                                                child: Icon(
                                                    Icons.account_circle,
                                                    size: 20),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Welcome, $CUR_USERNAME",
                                            style: const TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              color: white,
                                              fontSize: textFontSize16,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IntrinsicHeight(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 15),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(circularBorderRadius7)),
                                  color: white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: blarColor,
                                      offset: Offset(0, 0),
                                      blurRadius: 4,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                circularBorderRadius100),
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.1),
                                              child: SvgPicture.asset(
                                                  DesignConfiguration
                                                      .setSvgPath(
                                                          Assets.balance)),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                  start: 18.0,
                                                  bottom: 5.0,
                                                ),
                                                child: Text(
                                                    BAL_LBL.translate(
                                                        context: context),
                                                    style: const TextStyle(
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            "PlusJakartaSans",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize:
                                                            textFontSize14),
                                                    textAlign: TextAlign.left),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                  start: 18.0,
                                                ),
                                                child: Text(
                                                    DesignConfiguration
                                                        .getPriceFormat(
                                                            context,
                                                            double.parse(
                                                                CUR_BALANCE))!,
                                                    style: const TextStyle(
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily:
                                                            "PlusJakartaSans",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize:
                                                            textFontSize16),
                                                    textAlign: TextAlign.left),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    VerticalDivider(),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                circularBorderRadius100),
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withValues(alpha: 0.1),
                                              child: SvgPicture.asset(
                                                  DesignConfiguration
                                                      .setSvgPath(
                                                          Assets.report)),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                  start: 18.0,
                                                  bottom: 5.0,
                                                ),
                                                child: Text(
                                                    BONUS_LBL.translate(
                                                        context: context),
                                                    style: const TextStyle(
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily:
                                                            "PlusJakartaSans",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize:
                                                            textFontSize14),
                                                    textAlign: TextAlign.left),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                  start: 18.0,
                                                ),
                                                child: Text(CUR_BONUS!,
                                                    style: const TextStyle(
                                                        color: black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily:
                                                            "PlusJakartaSans",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize:
                                                            textFontSize16),
                                                    textAlign: TextAlign.left),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DetailHeader(update: setStateNow),
                          if (homeProvider!.activeStatus == SHIPED)
                            _buildFilterRow(context),
                          homeProvider!.orderList.isEmpty ||
                                  homeProvider!.isLoading
                              ? homeProvider!.isLoadingItems
                                  ? Container(
                                      height: deviceHeight * 0.5,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  : Container(
                                      height: deviceHeight * 0.5,
                                      child: Center(
                                        child: Text(
                                          noItem.translate(context: context),
                                        ),
                                      ),
                                    )
                              : homeProvider!.displayList.isEmpty
                                  ? Container(
                                      height: deviceHeight * 0.5,
                                      child: Center(
                                        child: Text(
                                          noItem.translate(context: context),
                                        ),
                                      ),
                                    )
                              : MediaQuery.removePadding(
                                  context: context,
                                  removeTop: true,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: (homeProvider!.offset! <
                                            homeProvider!.total!)
                                        ? homeProvider!.displayList.length + 1
                                        : homeProvider!.displayList.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return (index ==
                                                  homeProvider!
                                                      .displayList.length &&
                                              homeProvider!.isLoadingmore)
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : OrderIteam(
                                              index: index,
                                              update: setStateNow,
                                            );
                                    },
                                  ),
                                )
                        ],
                      ),
                    ),
                  )
            : noInternet(
                context,
                setStateNoInternate,
                homeProvider!.buttonSqueezeanimation,
                homeProvider!.buttonController,
              ));
  }

  Widget _buildFilterRow(BuildContext context) {
    final hasFilter = homeProvider!.filterCityName != null;
    final label = hasFilter
        ? '${homeProvider!.filterCityName}'
            '${homeProvider!.filterAreaName != null ? ' / ${homeProvider!.filterAreaName}' : ''}'
        : 'Filter by City / Area';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showFilterSheet(context),
              icon: const Icon(Icons.filter_list, size: 18),
              label: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: hasFilter ? primary : Colors.grey[700],
                  fontSize: textFontSize14,
                ),
              ),
              style: OutlinedButton.styleFrom(
                alignment: AlignmentDirectional.centerStart,
                side: BorderSide(color: hasFilter ? primary : Colors.grey),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          if (hasFilter)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () {
                homeProvider!.filterCityName = null;
                homeProvider!.filterAreaName = null;
                setStateNow();
              },
            ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext ctx) {
    final cities = homeProvider!.orderList
        .map((o) => o.city)
        .where((c) => c != null && c!.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList()
      ..sort();

    List<String> areasForCity(String cityName) {
      return homeProvider!.orderList
          .where((o) => o.city == cityName)
          .map((o) => o.areaName)
          .where((a) => a != null && a!.isNotEmpty)
          .cast<String>()
          .toSet()
          .toList()
        ..sort();
    }

    String? tempCityName = homeProvider!.filterCityName;
    String? tempAreaName = homeProvider!.filterAreaName;

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) {
          final areas = tempCityName != null ? areasForCity(tempCityName!) : <String>[];
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter by Location',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(sheetCtx),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Text('City',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: tempCityName,
                    hint: Text(cities.isEmpty ? 'No cities available' : 'Select City'),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: cities
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: cities.isEmpty
                        ? null
                        : (val) => setSheetState(() {
                              tempCityName = val;
                              tempAreaName = null;
                            }),
                  ),
                  const SizedBox(height: 16),
                  const Text('Area',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: tempAreaName,
                    hint: Text(tempCityName == null
                        ? 'Select a city first'
                        : areas.isEmpty
                            ? 'No areas available'
                            : 'Select Area'),
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: areas
                        .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                        .toList(),
                    onChanged: areas.isEmpty
                        ? null
                        : (val) => setSheetState(() => tempAreaName = val),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            homeProvider!.filterCityName = null;
                            homeProvider!.filterAreaName = null;
                            Navigator.pop(sheetCtx);
                            setStateNow();
                          },
                          child: const Text('Clear'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: tempCityName == null
                              ? null
                              : () {
                                  homeProvider!.filterCityName = tempCityName;
                                  homeProvider!.filterAreaName = tempAreaName;
                                  Navigator.pop(sheetCtx);
                                  setStateNow();
                                },
                          style: ElevatedButton.styleFrom(backgroundColor: primary),
                          child: const Text('Apply', style: TextStyle(color: white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _scrollListener() {
    if (homeProvider!.controller.offset >=
            homeProvider!.controller.position.maxScrollExtent &&
        !homeProvider!.controller.position.outOfRange) {
      if (this.mounted) {
        setState(
          () {
            homeProvider!.isLoadingmore = true;

            if (homeProvider!.offset! < homeProvider!.total!)
              homeProvider!.getOrder(setStateNow, context);
          },
        );
      }
    }
  }

  @override
  void dispose() {
    homeProvider!.buttonController!.dispose();
    super.dispose();
  }

  Future<Null> _refresh() async {
    homeProvider!.offset = 0;
    homeProvider!.total = 0;
    homeProvider!.orderList.clear();
    setState(
      () {
        homeProvider!.isLoading = true;
        homeProvider!.isLoadingItems = true;
      },
    );
    homeProvider!.orderList.clear();
    homeProvider!.getSetting(context);
    return homeProvider!.getOrder(setStateNow, context);
  }

  Future<void> _playAnimation() async {
    try {
      await homeProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();

    Future.delayed(Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          homeProvider!.getSetting(context);
          homeProvider!.getOrder(setStateNow, context);
        } else {
          await homeProvider!.buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }
}
