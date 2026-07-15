import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
import 'package:sellermultivendor/Widget/api.dart';

class AIDescriptionRepository {
  /// Generate product description using AI
  ///
  /// Parameters:
  /// - title: Product title
  /// - fieldType: Type of description field ('description', 'short_description', 'extra_description')
  /// - customPrompt: Optional custom prompt (default: empty string)
  /// - useCustomPrompt: Whether to use custom prompt (0 = no, 1 = yes)
  Future<Map<String, dynamic>> generateProductDescription({
    required String title,
    required String fieldType,
    String customPrompt = '',
    String useCustomPrompt = '0',
  }) async {
    try {
      Map<String, String> parameter = {
        'title': title,
        'field_type': fieldType,
        'custom_prompt': customPrompt,
        'use_custom_prompt': useCustomPrompt,
      };

      final result = await ApiBaseHelper().postAPICall(
        generateProductDescriptionApi,
        parameter,
      );

      if (result['error']) {
        throw ApiException(result['message']);
      }

      return {
        'error': false,
        'message': result['message'],
        'data': result['data'] ?? {},
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  /// Get AI prompt suggestions for product
  ///
  /// Parameters:
  /// - title: Product title
  Future<Map<String, dynamic>> suggestProductPrompts({
    required String title,
  }) async {
    try {
      Map<String, String> parameter = {'title': title};

      final result = await ApiBaseHelper().postAPICall(
        suggestProductPromptsApi,
        parameter,
      );

      if (result['error']) {
        throw ApiException(result['message']);
      }

      return {
        'error': false,
        'message': result['message'] ?? 'Prompts generated successfully',
        'prompts': result['data']?['prompts'] ?? [],
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
