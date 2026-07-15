import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/PushNotificationService.dart';
import 'package:sellermultivendor/Provider/addPickUpLocationProvider.dart';
import 'package:sellermultivendor/Provider/brandProvider.dart';
import 'package:sellermultivendor/Provider/cityProvider.dart';
import 'package:sellermultivendor/Provider/faqProvider.dart';
import 'package:sellermultivendor/Provider/pickUpLocationProvider.dart';
import 'package:sellermultivendor/Provider/pushNotificationProvider.dart';
import 'package:sellermultivendor/Repository/chatRepository.dart';
import 'package:sellermultivendor/Repository/consignment_repository.dart';
import 'package:sellermultivendor/Repository/generateAWBRepository.dart';
import 'package:sellermultivendor/Repository/hiveRepository.dart';
import 'package:sellermultivendor/Repository/ordeListRepositry.dart';
import 'package:sellermultivendor/Repository/sendPickUpRequestRepository.dart';
import 'package:sellermultivendor/cubits/groupConverstationsCubit.dart';
import 'package:sellermultivendor/cubits/languageCubit.dart';
import 'package:sellermultivendor/cubits/loadCountryCodeCubit.dart';
import 'package:sellermultivendor/cubits/makeMeOnlineCubit.dart';
import 'package:sellermultivendor/cubits/order/create_consignment_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignments_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_orders_cubit.dart';
import 'package:sellermultivendor/cubits/order/generate_awb_cubit.dart';
import 'package:sellermultivendor/cubits/order/send_pickup_request_cubit.dart';
import 'package:sellermultivendor/cubits/personalConverstationsCubit.dart';
import 'package:sellermultivendor/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Helper/Color.dart';
import 'Helper/Constant.dart';
import 'Localization/Demo_Localization.dart';
import 'Provider/ProductListProvider.dart';
import 'Provider/ProfileProvider.dart';
import 'Provider/addProductProvider.dart';
import 'Provider/attributeSetProvider.dart';
import 'Provider/categoryProvider.dart';
import 'Provider/countryProvider.dart';
import 'Provider/editProductProvider.dart';
import 'Provider/homeProvider.dart';
import 'Provider/loginProvider.dart';
import 'Provider/mediaProvider.dart';
import 'Provider/privacyProvider.dart';
import 'Provider/reviewListProvider.dart';
import 'Provider/salesReportProvider.dart';
import 'Provider/searchProvider.dart';
import 'Provider/settingProvider.dart';
import 'Provider/stockmanagementProvider.dart';
import 'Provider/taxProvider.dart';
import 'Provider/walletProvider.dart';
import 'Provider/zipcodeProvider.dart';
import 'Screen/SplashScreen/splashScreen.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
  if (Firebase.apps.isNotEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  await Hive.initFlutter();
  await HiveRepository.init();

  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(
      PushNotificationService.backgroundNotification,
    );
  }

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
        ChangeNotifierProvider<AddProductProvider>(
          create: (_) => AddProductProvider(),
        ),
        ChangeNotifierProvider<CountryProvider>(
          create: (_) => CountryProvider(),
        ),
        ChangeNotifierProvider<BrandProvider>(create: (_) => BrandProvider()),
        ChangeNotifierProvider<PickUpLocationProvider>(
          create: (_) => PickUpLocationProvider(),
        ),
        ChangeNotifierProvider<TaxProvider>(create: (_) => TaxProvider()),
        ChangeNotifierProvider<SettingProvider>(
          create: (_) => SettingProvider(sharedPreferences),
        ),
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
        ChangeNotifierProvider<ZipcodeProvider>(
          create: (_) => ZipcodeProvider(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider<AttributeProvider>(
          create: (_) => AttributeProvider(),
        ),
        ChangeNotifierProvider<MediaProvider>(create: (_) => MediaProvider()),
        ChangeNotifierProvider<SystemProvider>(create: (_) => SystemProvider()),
        ChangeNotifierProvider<ProductListProvider>(
          create: (_) => ProductListProvider(),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider<ReviewListProvider>(
          create: (_) => ReviewListProvider(),
        ),
        ChangeNotifierProvider<SalesReportProvider>(
          create: (_) => SalesReportProvider(),
        ),
        ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
        ChangeNotifierProvider<FaQProvider>(create: (_) => FaQProvider()),
        ChangeNotifierProvider<EditProductProvider>(
          create: (_) => EditProductProvider(),
        ),
        ChangeNotifierProvider<WalletTransactionProvider>(
          create: (_) => WalletTransactionProvider(),
        ),
        ChangeNotifierProvider<StockProviderProvider>(
          create: (_) => StockProviderProvider(),
        ),
        ChangeNotifierProvider<AddPickUpLocationProvider>(
          create: (_) => AddPickUpLocationProvider(),
        ),
        ChangeNotifierProvider<CityProvider>(create: (_) => CityProvider()),
        ChangeNotifierProvider<PushNotificationProvider>(
          create: (_) => PushNotificationProvider(),
        ),
        BlocProvider(
          create: (_) => PersonalConverstationsCubit(ChatRepository()),
        ),
        BlocProvider(create: (_) => GroupConversationsCubit(ChatRepository())),
        BlocProvider(create: (_) => FetchOrdersCubit(OrdersRepository())),
        BlocProvider(
          create: (_) => CreateConsignmentCubit(ConsignmentRepository()),
        ),
        BlocProvider(
          create: (_) => FetchConsignmentsCubit(ConsignmentRepository()),
        ),
        BlocProvider(
          create: (_) => SendPickUpRequestCubit(SendPickUpRepository()),
        ),
        BlocProvider(create: (_) => GenerateAWBCubit(GenerateAWBRepository())),
        BlocProvider<CountryCodeCubit>(create: (_) => CountryCodeCubit()),
        BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
        BlocProvider<MakeMeOnlineCubit>(
          create: (context) => MakeMeOnlineCubit(ChatRepository()),
        ),
      ],
      child: MyApp(sharedPreferences: sharedPreferences),
    ),
  );
}

//to get token without using context
SettingProvider? globalSettingsProvider;
GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  // static void setLocale(BuildContext context, Locale newLocale) {
  //   _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
  //   state.setLocale(newLocale);
  // }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Locale? _locale;
  bool _isLanguageLoaded = false;

  @override
  void initState() {
    globalSettingsProvider = SettingProvider(widget.sharedPreferences);
    super.initState();
  }

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
  void didChangeDependencies() {
    if (!_isLanguageLoaded) {
      context.read<LanguageCubit>().loadCurrentLanguage();
      _isLanguageLoaded = true;
    }
    // getLocale().then(
    //   (locale) {
    //     if (mounted) {
    //       setState(
    //         () {
    //           _locale = locale;
    //         },
    //       );
    //     }
    //   },
    // );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder:
          (
            final BuildContext context,
            final LanguageState languageState,
          ) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MaterialApp(
               builder: (context, child) {
                return ScrollConfiguration(
                  behavior: GlobalScrollBehavior(),
                  child: AnnotatedRegion<SystemUiOverlayStyle>(
                    value: const SystemUiOverlayStyle(
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
              navigatorKey: rootNavigatorKey,
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
              home: const SplashScreen(),
            ),
          ),
    );
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
