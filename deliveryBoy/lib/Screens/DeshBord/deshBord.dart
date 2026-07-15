import 'package:deliveryboy_multivendor/Helper/assetsConstant.dart';
import 'package:deliveryboy_multivendor/Helper/extensions/string.dart';
import 'package:deliveryboy_multivendor/Screens/Return/Return.dart';
import 'package:deliveryboy_multivendor/Widget/setSnackbar.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import '../../Helper/color.dart';
import '../../Helper/constant.dart';
import '../../Widget/desing.dart';
import '../CashCollection/cash_collection.dart';
import '../Home/home.dart';
import '../WalletHistory/wallet_history.dart';
import '../getDrawer/drawerWidget.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late List<Widget> fragments;
  int _curBottom = 0;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    fragments = [
      Home(),
      ReturnOrder(),
      WalletHistory(isBack: false),
      CashCollection(
        isBack: false,
      ),
      GetDrawerWidget(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _curBottom == 0 &&
          !(currentBackPressTime == null ||
              DateTime.now().difference(currentBackPressTime!) >
                  const Duration(seconds: 2)),
      onPopInvokedWithResult: (didPop, result) {
        if (_curBottom != 0) {
          setState(
            () {
              _curBottom = 0;
            },
          );
        } else {
          DateTime now = DateTime.now();

          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) >
                  const Duration(seconds: 2)) {
            currentBackPressTime = now;
            setSnackbar('Press back again to Exit', context);
            setState(() {});
          }
        }
      },
      child: Scaffold(
        bottomNavigationBar: getBottomNav(),
        body: fragments[_curBottom],
      ),
    );
  }

  getBottomNav() {
    return Container(
      decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(circularBorderRadius13)),
          boxShadow: [
            BoxShadow(
                color: black12,
                offset: Offset(0, -3),
                blurRadius: 6,
                spreadRadius: 0)
          ],
          color: white),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(circularBorderRadius12),
          topLeft: Radius.circular(circularBorderRadius12),
        ),
        child: BottomNavigationBar(
          unselectedItemColor: grey3,
          selectedLabelStyle: Theme.of(context).textTheme.bodySmall,
          unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath(Assets.homeInactive),
                height: 25,
                width: 25,
              ),
              activeIcon: SvgPicture.asset(
                DesignConfiguration.setSvgPath(Assets.homeActive),
                height: 25,
                width: 25,
              ),
              label: 'Home'.translate(context: context),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath(Assets.returnInactive),
                height: 25,
                width: 25,
              ),
              activeIcon: SvgPicture.asset(
                DesignConfiguration.setSvgPath(Assets.returnActive),
                height: 25,
                width: 25,
              ),
              label: 'RETURN'.translate(context: context),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath(Assets.walletInactive),
                height: 25,
                width: 25,
              ),
              activeIcon: SvgPicture.asset(
                DesignConfiguration.setSvgPath(Assets.walletActive),
                height: 25,
                width: 25,
              ),
              label: 'WALLET'.translate(context: context),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath(Assets.cashCollectionInactive),
                height: 25,
                width: 25,
              ),
              activeIcon: SvgPicture.asset(
                DesignConfiguration.setSvgPath(Assets.cashCollectionActive),
                height: 25,
                width: 25,
              ),
              label: 'Cash Collection'.translate(context: context),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                DesignConfiguration.setSvgPath(Assets.profileInactive),
                height: 25,
                width: 25,
              ),
              activeIcon: SvgPicture.asset(
                DesignConfiguration.setSvgPath(Assets.profileActive),
                height: 25,
                width: 25,
              ),
              label: 'PROFILE'.translate(context: context),
            ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _curBottom,
          selectedItemColor: black,
          onTap: (int index) {
            if (mounted) {
              setState(
                () {
                  _curBottom = index;
                },
              );
            }
          },
          elevation: 25,
        ),
      ),
    );
  }
}
