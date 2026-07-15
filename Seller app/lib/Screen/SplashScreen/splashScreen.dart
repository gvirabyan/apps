import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/assetsConstant.dart';
import 'package:sellermultivendor/Model/appSettingsModel.dart';
import 'package:sellermultivendor/Repository/appSettingsRepository.dart';
import 'package:sellermultivendor/Repository/getSettingRepositry.dart';
import 'package:sellermultivendor/Widget/errorContainer.dart';
import 'package:sellermultivendor/Widget/parameterString.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/desing.dart';
import '../../Widget/sharedPreferances.dart';
import '../../Widget/systemChromeSettings.dart';
import '../Authentication/Login.dart';
import '../DeshBord/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isError = false;
  String errorMessage = '';

  @override
  void initState() {
    SystemChromeSettings.setSystemButtomNavigationonlyTop();
    SystemChromeSettings.setSystemUIOverlayStyleWithLightBrightNessStyle();
    super.initState();
    getSettings();
  }

//==============================================================================
//============================= Build Method ===================================
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      body: isError
          ? Center(
              child: ErrorContainer(
                  onTapRetry: () {
                    getSettings();
                  },
                  errorMessage: errorMessage),
            )
          : Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: DesignConfiguration.back(),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsetsDirectional.symmetric(
                          vertical: 20, horizontal: 10),
                      decoration: const BoxDecoration(
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: lightWhite,
                              blurRadius: 5.0,
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: SvgPicture.asset(
                        DesignConfiguration.setNewSvgPath(Assets.loginLogo),
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ),
                Image.asset(
                  DesignConfiguration.setPngPath(Assets.doodle),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 8, bottom: 30),
                      child: Text(
                        'Powered by Turki Oudah Eid AlAtawi Information Technology Establishment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: fontColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
    );
  }

  getSettings() async {
    if (isError) {
      isError = false;
      setState(() {});
    }
    try {
      final data = await SystemRepository.fetchSystemSettings();
      AppSettingsRepository.appSettings = AppSettingsModel.fromMap(data);
      Future.delayed(
        const Duration(seconds: 5),
        () {
          navigationPage();
        },
      );
    } catch (e) {
      isError = true;
      errorMessage = e.toString();
      setState(() {});
    }
  }

  Future<void> navigationPage() async {
    bool isFirstTime = await getPrefrenceBool(isLogin);

    if (isFirstTime) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const Dashboard(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const Login(),
        ),
      );
    }
  }

  @override
  void dispose() async {
    super.dispose();
    bool isFirstTime = await getPrefrenceBool(isLogin);
    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();

    if (isFirstTime) {
      SystemChromeSettings.setSystemUIOverlayStyleWithLightBrightNessStyle();
    } else {
      SystemChromeSettings.setSystemUIOverlayStyleWithDarkBrightNessStyle();
    }
  }
}
