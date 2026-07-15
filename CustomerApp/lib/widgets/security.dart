import 'package:eshop_multivendor/main.dart';
import 'package:eshop_multivendor/repository/hiveRepository.dart';

Map<String, String> get headers {
  final Map<String, String> result = {};
  final String? token = globalSettingsProvider?.token;
  if (token != null && token.toString().trim().isNotEmpty) {
    result['Authorization'] = 'Bearer $token';
  }
  // Multilingual: tell the backend which language to return dynamic
  // content (products, categories, brands, attributes, zipcodes, …) in.
  // Backend falls back to the default language when a translation is missing.
  try {
    final String code = HiveRepository.getSelectedLanguageCode;
    if (code.trim().isNotEmpty) {
      result['Language'] = code;
    }
  } catch (_) {
    // Hive box not ready yet — backend uses the default language.
  }
  return result;
}
