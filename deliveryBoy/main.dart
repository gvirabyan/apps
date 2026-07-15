import 'dart:io';

import 'package:deliveryboy_multivendor/Cubit/UpdateStatusReturnOrderCubit.dart';
import 'package:deliveryboy_multivendor/Cubit/languageCubit.dart';
import 'package:deliveryboy_multivendor/Cubit/loadCountryCodeCubit.dart';
import 'package:deliveryboy_multivendor/Cubit/returnOrderCubit.dart';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/constant.dart';
import 'package:deliveryboy_multivendor/Helper/push_notification_service.dart';
import 'package:deliveryboy_multivendor/Localization/Demo_Localization.dart';
import 'package:deliveryboy_multivendor/Provider/AuthProvider.dart';
import 'package:deliveryboy_multivendor/Provider/SettingsProvider.dart';
import 'package:deliveryboy_multivendor/Provider/SystemProvider.dart';
import 'package:deliveryboy_multivendor/Provider/UserProvider.dart';
import 'package:deliveryboy_multivendor/Provider/WalletProvider.dart';
import 'package:deliveryboy_multivendor/Provider/cashCollectionProvider.dart';
import 'package:deliveryboy_multivendor/Provider/cityListProvider.dart';
import 'package:deliveryboy_multivendor/Provider/homeProvider.dart';
import 'package:deliveryboy_multivendor/Provider/notificationListProvider.dart';
import 'package:deliveryboy_multivendor/Provider/orderDetailProvider.dart';
import 'package:deliveryboy_multivendor/Provider/signupProvider.dart';
import 'package:deliveryboy_multivendor/Provider/zipcodeListProvider.dart';
import 'package:deliveryboy_multivendor/Repository/hiveRepository.dart';
import 'package:deliveryboy_multivendor/Repository/returnOrderRepositry.dart';
import 'package:deliveryboy_multivendor/Screens/DeshBord/deshBord.dart';
import 'package:deliveryboy_multivendor/Screens/Splash/splash.dart';
import 'package:deliveryboy_multivendor/Widget/systemChromeSettings.dart';
import 'package:deliveryboy_multivendor/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isNotEmpty) {
    await Firebase.initializeApp(
      // name: 'eshop-multivendor-deliveryboy',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }

  await Hive.initFlutter();
  await HiveRepository.init();

  SystemChromeSettings.setSystemButtomNavigationonlyTop();
  SystemChromeSettings.setSystemUIOverlayStyleWithLightBrightNessStyle();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseMessaging.onBackgroundMessage(
      PushNotificationService.backgroundNotification);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        Provider<SettingProvider>(
          create: (context) => SettingProvider(prefs),
        ),
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider()),
        ChangeNotifierProvider<SystemProvider>(
            create: (context) => SystemProvider()),
        ChangeNotifierProvider<CashCollectionProvider>(
            create: (context) => CashCollectionProvider()),
        ChangeNotifierProvider<OrderDetailProvider>(
            create: (context) => OrderDetailProvider()),
        ChangeNotifierProvider<NotificationListProvider>(
            create: (context) => NotificationListProvider()),
        ChangeNotifierProvider<HomeProvider>(
            create: (context) => HomeProvider()),
        ChangeNotifierProvider<MyWalletProvider>(
            create: (context) => MyWalletProvider()),
        ChangeNotifierProvider<ZipcodeListProvider>(
            create: (context) => ZipcodeListProvider()),
        ChangeNotifierProvider<CityListProvider>(
            create: (context) => CityListProvider()),
        ChangeNotifierProvider<SignupAuthenticationProvider>(
            create: (context) => SignupAuthenticationProvider()),
        BlocProvider(
          create: (_) => FetchReturnOrderCubit(ReturnOrdersRepository()),
        ),
        BlocProvider(
          create: (_) => UpdateStatusReturnOrderCubit(),
        ),
        BlocProvider<CountryCodeCubit>(
          create: (context) => CountryCodeCubit(),
        ),
        BlocProvider(
          create: (final context) => LanguageCubit(),
        ),
      ],
      child: MyApp(sharedPreferences: prefs),
    ),
  );
}

//to get token without using context
SettingProvider? globalSettingsProvider;

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  MyApp({Key? key, required this.sharedPreferences}) : super(key: key);

  // static void setLocale(BuildContext context, Locale newLocale) {
  //   _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
  //   state.setLocale(newLocale);
  // }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLanguageLoaded = false;
  // Locale? _locale;

  // setLocale(Locale locale) {
  //   if (mounted) {
  //     setState(
  //       () {
  //         _locale = locale;
  //       },
  //     );
  //   }
  // }

  @override
  void initState() {
    globalSettingsProvider = SettingProvider(widget.sharedPreferences);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isLanguageLoaded) {
      context.read<LanguageCubit>().loadCurrentLanguage();
      _isLanguageLoaded = true;
    }
  }

  // @override
  // void didChangeDependencies() {
  //   getLocale().then(
  //     (locale) {
  //       if (mounted) {
  //         setState(
  //           () {
  //             _locale = locale;
  //           },
  //         );
  //       }
  //     },
  //   );
  //   super.didChangeDependencies();
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
        builder: (final BuildContext context,
                final LanguageState languageState) =>
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: MaterialApp(
                   builder: (context, child) {
                return ScrollConfiguration(
                  behavior: GlobalScrollBehavior(),
                  child: AnnotatedRegion<SystemUiOverlayStyle>(
                    value: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent, // Optional
                      statusBarIconBrightness:
                          Brightness.dark, // Status bar icons → dark (black)
                      systemNavigationBarColor: /*  Theme.of(
                        context,
                      ).colorScheme.white */
                          Colors.transparent, // Bottom nav bar background
                      systemNavigationBarIconBrightness:
                          Brightness.dark, // Bottom nav icons → dark (black)
                      systemNavigationBarDividerColor: Colors.transparent,
                    ),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: SafeArea(
                        bottom: Platform.isIOS ? false : true,
                        top: false,
                        child: child!,
                      ),
                    ),
                  ),
                ); // Directionality
              },
              
                  title: appName,
                  theme: ThemeData(
                    useMaterial3: false,
                    primarySwatch: primary_app,
                    fontFamily: 'opensans',
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  locale: (languageState is LanguageLoader)
                      ? Locale(languageState.languageCode)
                      : Locale(defaultLanguageCode),
                  supportedLocales: appLanguages
                      .map(
                        (final language) =>
                            getLocaleFromLanguageCode(language.languageCode),
                      )
                      .toList(),
                  localizationsDelegates: const [
                    AppLocalization.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  // locale: _locale,
                  // localizationsDelegates: const [
                  //   DemoLocalization.delegate,
                  //   GlobalMaterialLocalizations.delegate,
                  //   GlobalWidgetsLocalizations.delegate,
                  //   GlobalCupertinoLocalizations.delegate,
                  // ],
                  // supportedLocales: const [
                  //   Locale("en", "US"),
                  //   Locale("zh", "CN"),
                  //   Locale("es", "ES"),
                  //   Locale("hi", "IN"),
                  //   Locale("ar", "DZ"),
                  //   Locale("ru", "RU"),
                  //   Locale("ja", "JP"),
                  //   Locale("de", "DE")
                  // ],
                  // localeResolutionCallback: (locale, supportedLocales) {
                  //   for (var supportedLocale in supportedLocales) {
                  //     if (supportedLocale.languageCode == locale!.languageCode &&
                  //         supportedLocale.countryCode == locale.countryCode) {
                  //       return supportedLocale;
                  //     }
                  //   }
                  //   return supportedLocales.first;
                  // },
                  debugShowCheckedModeBanner: false,
                  initialRoute: '/',
                  routes: {
                    '/': (context) => Splash(),
                    '/home': (context) => Dashboard(),
                  },
                )));
  }
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Optionally customize scrollbar behavior
    return child;
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    // Optionally customize overscroll glow behavior
    return child; // No glow effect
  }
}

