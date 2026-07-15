import 'package:sellermultivendor/main.dart';
import 'package:sellermultivendor/Repository/hiveRepository.dart';

Map<String, String> get headers {
  final Map<String, String> result = {};
  final String? token = globalSettingsProvider?.token;
  if (token != null && token.toString().trim().isNotEmpty) {
    result['Authorization'] = 'Bearer $token';
  }
  // Multilingual: tell the backend which language to return dynamic
  // content (categories, brands, attributes, …) in. Backend falls back
  // to the default language when a translation is missing.
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
