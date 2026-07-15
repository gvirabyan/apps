import 'dart:async';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/assetsConstant.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Provider/Theme.dart';
import 'package:eshop_multivendor/Provider/homePageProvider.dart';
import 'package:eshop_multivendor/Screen/IntroSlider/Intro_Slider.dart';
import 'package:eshop_multivendor/Screen/NoInterNetWidget/NoInterNet.dart';
import 'package:eshop_multivendor/cubits/appSettingsCubit.dart';
import 'package:eshop_multivendor/widgets/errorContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../Helper/String.dart';
import '../../widgets/desing.dart';
import '../../widgets/systemChromeSettings.dart';

//splash screen of app
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashScreen();
}

class _SplashScreen extends State<Splash> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController buttonController;
  late Animation buttonSqueezeanimation;
  bool from = false;
  late AnimationController navigationContainerAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  @override
  void initState() {
    buttonController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    Future.delayed(Duration.zero, () {
      SystemChromeSettings.setSystemChromes(
          isDarkTheme: Provider.of<ThemeNotifier>(context, listen: false)
                  .getThemeMode() ==
              ThemeMode.dark);
    });
    initializeAnimationController();
    Future.delayed(Duration.zero, () {
      context.read<AppSettingsCubit>().fetchAndStoreAppSettings();
    });

    super.initState();
  }

  void initializeAnimationController() {
    Future.delayed(
      Duration.zero,
      () {
        context.read<HomePageProvider>()
          ..setAnimationController(navigationContainerAnimationController)
          ..setBottomBarOffsetToAnimateController(
              navigationContainerAnimationController)
          ..setAppBarOffsetToAnimateController(
              navigationContainerAnimationController);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    buttonSqueezeanimation = Tween(
      begin: MediaQuery.of(context).size.width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
    return Scaffold(
      key: _scaffoldKey,
      body: BlocConsumer<AppSettingsCubit, AppSettingsState>(
        listener: (context, state) {
          if (state is AppSettingsSuccess) {
            navigationPage();
          }
        },
        builder: (context, state) {
          if (state is AppSettingsFailure) {
            if (state.message.contains('No Internet connection')) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: NoInterNet(
                      buttonController: buttonController,
                      buttonSqueezeanimation: buttonSqueezeanimation,
                      setStateNoInternate: () {
                        buttonController.forward().then((value) {
                          buttonController.value = 0;
                          context
                              .read<AppSettingsCubit>()
                              .fetchAndStoreAppSettings();
                        });
                      }),
                ),
              );
            }
            return Center(
              child: ErrorContainer(
                  onTapRetry: () {
                    context.read<AppSettingsCubit>().fetchAndStoreAppSettings();
                  },
                  errorMessage: state.message),
            );
          }
          return Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: DesignConfiguration.back(),
                child: Center(
                  child: Container(
                    padding: EdgeInsetsDirectional.symmetric(
                        vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.4),
                            blurRadius: 5.0,
                          ),
                        ],
                        borderRadius: BorderRadius.all(
                            Radius.circular(circularBorderRadius10))),
                    child: SvgPicture.asset(
                      DesignConfiguration.setSvgPath(Assets.splashlogo),
                      // fit: BoxFit.fill,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ),
              Image.asset(
                DesignConfiguration.setPngPath(Assets.doodle),
                // fit: BoxFit.fill,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Center(
                      child: Text(
                        'Powered by Turki Oudah Eid AlAtawi Information Technology Establishment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .fontColor
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Future<void> navigationPage() async {
    SettingProvider settingsProvider =
        Provider.of<SettingProvider>(context, listen: false);

    bool isFirstTime = await settingsProvider.getPrefrenceBool(ISFIRSTTIME);
    if (isFirstTime) {
      setState(
        () {
          from = true;
        },
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(
        () {
          from = false;
        },
      );
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const IntroSlider(),
        ),
      );
    }
  }
}
