import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sellermultivendor/Model/wafeq/wafeq_invoice_request.dart';
import 'package:sellermultivendor/appConstants.dart';

/// Low-level HTTP client for the Wafeq REST API.
class WafeqService {
  WafeqService._();
  static final WafeqService instance = WafeqService._();

  Dio get _dio => Dio(
        BaseOptions(
          baseUrl: AppConstants.wafeqBaseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Authorization': 'Api-Key ${AppConstants.wafeqApiKey}',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

  // ── Contacts ───────────────────────────────────────────────────────────────

  /// Search contacts by name. Returns list of matches.
  Future<List<WafeqContactResponse>> searchContacts(String name) async {
    debugPrint('🧾 WAFEQ | [Service] GET contacts/?search=$name');
    try {
      final response = await _dio.get(
        'contacts/',
        queryParameters: {'search': name},
      );
      debugPrint('🧾 WAFEQ | [Service] contacts HTTP ${response.statusCode} — ${response.data}');
      final results = response.data['results'] as List? ?? [];
      return results
          .map((e) => WafeqContactResponse.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      final body = e.response?.data?.toString() ?? '';
      debugPrint('🧾 WAFEQ | [Service] contacts search ERROR ${e.response?.statusCode} — $body');
      throw WafeqServiceException('Contact search failed: $body');
    }
  }

  /// Creates a new contact. Returns the created contact with its ID.
  Future<WafeqContactResponse> createContact(
      WafeqContactRequest contact) async {
    debugPrint('🧾 WAFEQ | [Service] POST contacts/ — ${contact.toJson()}');
    try {
      final response = await _dio.post('contacts/', data: contact.toJson());
      debugPrint('🧾 WAFEQ | [Service] contact created HTTP ${response.statusCode} — ${response.data}');
      return WafeqContactResponse.fromJson(
          Map<String, dynamic>.from(response.data));
    } on DioException catch (e) {
      final body = e.response?.data?.toString() ?? '';
      debugPrint('🧾 WAFEQ | [Service] contact create ERROR ${e.response?.statusCode} — $body');
      throw WafeqServiceException('Contact creation failed: $body');
    }
  }

  // ── Invoices ───────────────────────────────────────────────────────────────

  /// Creates an invoice. Throws [WafeqDuplicateInvoiceException] if
  /// invoice_number already exists. Throws [WafeqServiceException] on other errors.
  Future<WafeqInvoiceResponse> createInvoice(
      WafeqInvoiceRequest request) async {
    debugPrint('🧾 WAFEQ | [Service] POST invoices/');
    debugPrint('🧾 WAFEQ | [Service] payload = ${request.toJson()}');
    try {
      final response = await _dio.post('invoices/', data: request.toJson());
      debugPrint('🧾 WAFEQ | [Service] HTTP ${response.statusCode} — ${response.data}');
      return WafeqInvoiceResponse.fromJson(
          Map<String, dynamic>.from(response.data));
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final body = e.response?.data?.toString() ?? '';
      debugPrint('🧾 WAFEQ | [Service] HTTP ERROR $statusCode — $body');

      if (statusCode == 400 && body.contains('invoice_number')) {
        debugPrint('🧾 WAFEQ | [Service] duplicate invoice_number ${request.invoiceNumber}');
        throw WafeqDuplicateInvoiceException(request.invoiceNumber);
      }

      final message = _errorMessage(statusCode, body, e.message);
      throw WafeqServiceException(message);
    } catch (e) {
      debugPrint('🧾 WAFEQ | [Service] unexpected: $e');
      throw WafeqServiceException(e.toString());
    }
  }

  String _errorMessage(int? code, String body, String? dio) {
    if (code == 401) return 'Wafeq: invalid API key (401)';
    if (code == 403) return 'Wafeq: forbidden (403)';
    if (code != null) return 'Wafeq: HTTP $code — $body';
    return 'Wafeq: network error — $dio';
  }
}

class WafeqServiceException implements Exception {
  final String message;
  WafeqServiceException(this.message);
  @override
  String toString() => message;
}

class WafeqDuplicateInvoiceException implements Exception {
  final String invoiceNumber;
  WafeqDuplicateInvoiceException(this.invoiceNumber);
  @override
  String toString() => 'Wafeq: invoice already exists: $invoiceNumber';
}
