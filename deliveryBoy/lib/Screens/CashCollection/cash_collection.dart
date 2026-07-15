import 'dart:async';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Screens/WalletHistory/Widget/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Helper/constant.dart';
import '../../Provider/cashCollectionProvider.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/simmerEffect.dart';
import '../../Widget/translateVariable.dart';
import 'Widget/getAppBar.dart';
import 'Widget/getCardValue.dart';
import 'Widget/orderIteamWidget.dart';

class CashCollection extends StatefulWidget {
  final bool isBack;
  const CashCollection({Key? key, required this.isBack}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateCash();
  }
}

CashCollectionProvider? cashCollectionProvider;

class StateCash extends State<CashCollection> with TickerProviderStateMixin {
  TabController? _tabController;

  setStateNow() {
    setState(() {});
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    print('-------tab $_tabController');
    cashCollectionProvider =
        Provider.of<CashCollectionProvider>(context, listen: false);
    getcashhistory();
    cashCollectionProvider!.buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    cashCollectionProvider!.buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: cashCollectionProvider!.buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
    cashCollectionProvider!.controller.addListener(_scrollListener);
    cashCollectionProvider!.controllerText.addListener(() {
      if (cashCollectionProvider!.controllerText.text.isEmpty) {
        if (mounted) {
          setState(
            () {
              cashCollectionProvider!.searchText = "";
            },
          );
        }
      } else {
        if (mounted) {
          setState(
            () {
              cashCollectionProvider!.searchText =
                  cashCollectionProvider!.controllerText.text;
            },
          );
        }
      }

      if (cashCollectionProvider!.lastsearch !=
              cashCollectionProvider!.searchText &&
          ((cashCollectionProvider!.searchText.length > 1) ||
              (cashCollectionProvider!.searchText == ""))) {
        cashCollectionProvider!.lastsearch = cashCollectionProvider!.searchText;
        cashCollectionProvider!.isLoadingmore = true;
        cashCollectionProvider!.offset = 0;
        if (_tabController?.index == 0) {
          cashCollectionProvider!.getOrder(
            "delivery",
            cashCollectionProvider!.currentSortOrder,
            setStateNow,
            context,
          );
        } else {
          cashCollectionProvider!.getOrder(
            "admin",
            cashCollectionProvider!.currentSortOrder,
            setStateNow,
            context,
          );
        }
      } else {
        getcashhistory();
      }
    });
    super.initState();
  }

  getcashhistory() {
    if (_tabController?.index == 0) {
      cashCollectionProvider!.cashList.clear();

      cashCollectionProvider!.offset = 0;
      cashCollectionProvider!.total = 0;
      cashCollectionProvider!.isLoading = true;
      cashCollectionProvider!.isLoadingmore = true;
      setStateNow();
      cashCollectionProvider!.getOrder(
        "delivery",
        cashCollectionProvider!.currentSortOrder,
        setStateNow,
        context,
      );
    } else {
      cashCollectionProvider!.cashList.clear();

      cashCollectionProvider!.offset = 0;

      cashCollectionProvider!.total = 0;
      cashCollectionProvider!.isLoading = true;
      cashCollectionProvider!.isLoadingmore = true;
      setStateNow();
      cashCollectionProvider!.getOrder(
        "admin",
        cashCollectionProvider!.currentSortOrder,
        setStateNow,
        context,
      );
    }
  }

  _scrollListener() {
    if (cashCollectionProvider!.controller.offset >=
            cashCollectionProvider!.controller.position.maxScrollExtent &&
        !cashCollectionProvider!.controller.position.outOfRange) {
      if (mounted) {
        setState(
          () {
            cashCollectionProvider!.isLoadingmore = true;

            if (cashCollectionProvider!.offset! <
                cashCollectionProvider!.total!) {
              // Use the correct 'from' value based on the selected tab
              String from = _tabController?.index == 0 ? "delivery" : "admin";
              cashCollectionProvider!.getOrder(
                from,
                cashCollectionProvider!.currentSortOrder,
                setStateNow,
                context,
              );
            }
          },
        );
      }
    }
  }

  getfilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(circularBorderRadius5),
            color: white),
        child: TabBar(
            onTap: (index) {
              {
                getcashhistory();
              }
            },
            indicatorSize: TabBarIndicatorSize.tab,
            padding: EdgeInsets.all(8),
            labelPadding: EdgeInsets.zero,
            unselectedLabelStyle:
                Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: black,
                      fontWeight: FontWeight.normal,
                    ),
            labelStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: white,
                  fontWeight: FontWeight.bold,
                ),
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            controller: _tabController,
            indicator: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(circularBorderRadius5)),
            tabs: [
              CommanButton(
                selected: _tabController?.index == 0 ? true : false,
                title: DELIVERY_BOY_CASH_TXT.translate(context: context),
              ),
              CommanButton(
                selected: _tabController?.index == 1 ? true : false,
                title: DELIVERY_BOY_CASH_COLL_TXT.translate(context: context),
              ),
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: cashCollectionProvider!.scaffoldKey,
      backgroundColor: lightWhite,
      appBar: GradientAppBar2(
          CASH_COLL.translate(context: context), context, setStateNow,
          customback: widget.isBack),
      body: SingleChildScrollView(
        controller: cashCollectionProvider!.controller,
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            GetCardValue(),
            getfilters(),
            isNetworkAvail
                ? cashCollectionProvider!.isLoading
                    ? const ShimmerEffect()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          cashCollectionProvider!.cashList.isEmpty
                              ? cashCollectionProvider!.isGettingdata
                                  ? Container()
                                  : const Center(child: Text(noItem))
                              : MediaQuery.removePadding(
                                  context: context,
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(top: 10),
                                    shrinkWrap: true,
                                    itemCount: cashCollectionProvider!
                                            .cashList.length +
                                        (cashCollectionProvider!.offset! <
                                                cashCollectionProvider!.total!
                                            ? 1
                                            : 0),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      if (index <
                                          cashCollectionProvider!
                                              .cashList.length) {
                                        return OrderItem(index: index);
                                      } else {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ),
                          cashCollectionProvider!.isGettingdata
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Container(),
                        ],
                      )
                : noInternet(
                    context,
                    setStateNoInternate,
                    cashCollectionProvider!.buttonSqueezeanimation,
                    cashCollectionProvider!.buttonController,
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _playAnimation() async {
    try {
      await cashCollectionProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          cashCollectionProvider!.getOrder(
            "delivery",
            cashCollectionProvider!.currentSortOrder,
            setStateNow,
            context,
          );
        } else {
          await cashCollectionProvider!.buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }
}
