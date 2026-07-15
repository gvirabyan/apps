import 'dart:ui';
import 'package:deliveryboy_multivendor/Model/appLanguageModel.dart';
import 'package:deliveryboy_multivendor/appConstants.dart';

final String appName = AppConstants.app_name;

const String baseUrl = AppConstants.baseUrl;

//this is for codecanyon demo mode, please do not change
const bool isDemoApp = false;

// String defaultLanguage = AppConstants.defaultLanguage;

bool allowOnlySingleCountry = false;

//Set labguage
String defaultLanguageCode = AppConstants.defaultLanguageCode;
String defaultLanguageName = AppConstants.defaultLanguageName;

const List<AppLanguage> appLanguages = [
  //Please add language code here and language name
  AppLanguage(
    languageCode: 'en',
    languageName: 'English',
    subLanguageName: 'English',
  ),
  AppLanguage(
    languageCode: 'hi',
    languageName: 'हिन्दी',
    subLanguageName: 'Hindi',
  ),
  AppLanguage(
    languageCode: 'ar',
    languageName: 'عربى',
    subLanguageName: 'Arabic',
  ),
  AppLanguage(
    languageCode: 'de',
    languageName: 'Deutsch',
    subLanguageName: 'German',
  ),
  AppLanguage(
    languageCode: 'es',
    languageName: 'Española',
    subLanguageName: 'Spanish',
  ),
  AppLanguage(
    languageCode: 'ja',
    languageName: '日本',
    subLanguageName: 'Japanese',
  ),
  AppLanguage(
    languageCode: 'ru',
    languageName: 'Русский',
    subLanguageName: 'Russian',
  ),
  AppLanguage(
    languageCode: 'zh',
    languageName: 'Chinese',
    subLanguageName: 'Chinese',
  ),
];

Locale getLocaleFromLanguageCode(final String languageCode) {
  final result = languageCode.split('-');
  return result.length == 1
      ? Locale(result.first)
      : Locale(result.first, result.last);
}

const int minimumMobileNumberDigit = 6;
const int maximumMobileNumberDigit = 15;

final int timeOut = 50;
const int perPage = 10;
String? supportedLocale;
String? IS_APP_UNDER_MAINTENANCE;
String? MAINTENANCE_MESSAGE;
String? IS_DELIVERY_BOY_OTP_IS_ON;

//FontSize
const double textFontSize10 = 10;
const double textFontSize12 = 12;
const double textFontSize13 = 13;
const double textFontSize14 = 14;
const double textFontSize15 = 15;
const double textFontSize16 = 16;
const double textFontSize18 = 18;
const double textFontSize20 = 20;
const double textFontSize23 = 23;

//Radius
const double circularBorderRadius3 = 3;
const double circularBorderRadius5 = 5;
const double circularBorderRadius7 = 7;
const double circularBorderRadius10 = 10;
const double circularBorderRadius12 = 12;
const double circularBorderRadius13 = 13;
const double circularBorderRadius15 = 15;
const double circularBorderRadius100 = 100;
