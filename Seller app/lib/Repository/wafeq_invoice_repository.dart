import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Model/wafeq/wafeq_invoice_request.dart';
import 'package:sellermultivendor/Services/wafeq_service.dart';
import 'package:sellermultivendor/appConstants.dart';

/// Maps [OrderModel] → ZATCA-compliant Wafeq invoice.
class WafeqInvoiceRepository {
  WafeqInvoiceRepository._();
  static final WafeqInvoiceRepository instance = WafeqInvoiceRepository._();

  // Wafeq tax ID for 15% Saudi VAT (not the percentage — Wafeq uses string IDs)
  static String get _vatTaxId => AppConstants.wafeqVatTaxId;

  /// Creates an e-invoice for [order] on Wafeq.
  /// Returns null silently if invoice already exists (duplicate).
  Future<WafeqInvoiceResponse?> createInvoiceForOrder(OrderModel order) async {
    try {
      debugPrint('🧾 WAFEQ | [Repository] start for order #${order.id}');

      // Step 1: get or create the Wafeq contact
      final contactId = await _getOrCreateContact(order);
      debugPrint('🧾 WAFEQ | [Repository] using contactId=$contactId');

      // Step 2: build and send the invoice
      final request = _buildInvoiceRequest(order, contactId);
      debugPrint('🧾 WAFEQ | [Repository] invoice payload = ${request.toJson()}');

      final response = await WafeqService.instance.createInvoice(request);
      debugPrint('🧾 WAFEQ | [Repository] invoice created id=${response.id} num=${response.invoiceNumber}');
      return response;
    } on WafeqDuplicateInvoiceException catch (e) {
      debugPrint('🧾 WAFEQ | [Repository] duplicate, skipping — $e');
      return null;
    }
    // WafeqServiceException propagates up to the cubit.
  }

  // ── Contact ─────────────────────────────────────────────────────────────────

  Future<String> _getOrCreateContact(OrderModel order) async {
    final name = _safe(order.name).isNotEmpty ? _safe(order.name) : 'Customer';

    // Search by name first
    debugPrint('🧾 WAFEQ | [Repository] searching contact name="$name"');
    final results = await WafeqService.instance.searchContacts(name);
    if (results.isNotEmpty) {
      debugPrint('🧾 WAFEQ | [Repository] found existing contact id=${results.first.id}');
      return results.first.id;
    }

    // Not found — create new contact
    debugPrint('🧾 WAFEQ | [Repository] no contact found, creating new one');
    final contactRequest = WafeqContactRequest(
      name: name,
      phone: _formatPhone(order.mobile, order.countryCode),
      address: _safe(order.address),
      district: _safe(order.areaName),
      city: _safe(order.cityName),
      postalCode: _safe(order.postalCode),
      country: 'SA',
    );

    final created = await WafeqService.instance.createContact(contactRequest);
    debugPrint('🧾 WAFEQ | [Repository] contact created id=${created.id}');
    return created.id;
  }

  // ── Invoice ──────────────────────────────────────────────────────────────────

  WafeqInvoiceRequest _buildInvoiceRequest(OrderModel order, String contactId) {
    final dateStr = _formatDate(order.dateAdded);
    return WafeqInvoiceRequest(
      invoiceNumber: 'ORD-${order.id}',
      invoiceDate: dateStr,
      invoiceDueDate: dateStr,
      contact: contactId,
      lineItems: _buildLineItems(order),
      notes: _buildNotes(order),
    );
  }

  List<WafeqLineItem> _buildLineItems(OrderModel order) {
    final items = <WafeqLineItem>[];

    for (final item in order.orderItems) {
      final isPriceInclusive = item.isPricesInclusiveTax == '1';
      final rawUnit = _parseDouble(item.discountedPrice) ??
          _parseDouble(item.price) ??
          0.0;
      final qty = _parseDouble(item.quantity) ?? 1.0;

      // ZATCA requires unit price EXCLUDING VAT (15%)
      final unitExclVat = isPriceInclusive
          ? rawUnit / 1.15
          : rawUnit;

      final desc = [
        item.productName ?? item.name,
        if (item.variantName != null && item.variantName!.isNotEmpty)
          item.variantName,
      ].whereType<String>().join(' — ');

      items.add(WafeqLineItem(
        account: AppConstants.wafeqSalesAccountId,
        description: desc,
        quantity: qty,
        unitAmount: double.parse(unitExclVat.toStringAsFixed(2)),
        taxRate: _vatTaxId,
      ));
    }

    // Delivery charge as a separate taxable line
    final delivery = _parseDouble(order.sellerDeliveryCharge) ??
        _parseDouble(order.deliveryCharge) ??
        0.0;
    if (delivery > 0) {
      items.add(WafeqLineItem(
        account: AppConstants.wafeqSalesAccountId,
        description: 'Delivery Charge',
        quantity: 1,
        unitAmount: double.parse(delivery.toStringAsFixed(2)),
        taxRate: _vatTaxId,
      ));
    }

    return items;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  String _buildStreetAddress(OrderModel order) {
    return [
      if (order.areaName != null && order.areaName!.isNotEmpty) order.areaName!,
      if (order.address != null && order.address!.isNotEmpty) order.address!,
    ].join(', ');
  }

  String _buildNotes(OrderModel order) {
    return [
      'Order #${order.id}',
      if (order.paymentMethod != null && order.paymentMethod!.isNotEmpty)
        'Payment: ${order.paymentMethod}',
      if (order.areaName != null && order.areaName!.isNotEmpty)
        'Area: ${order.areaName}',
      if (order.cityName != null && order.cityName!.isNotEmpty)
        'City: ${order.cityName}',
      if (order.postalCode != null && order.postalCode!.isNotEmpty)
        'Postal Code: ${order.postalCode}',
    ].join(' | ');
  }

  String _formatPhone(String? mobile, String? countryCode) {
    if (mobile == null || mobile.isEmpty) return '';
    if (mobile.startsWith('+')) return mobile;
    final code = countryCode?.replaceAll('+', '') ?? '966';
    return '+$code${mobile.replaceAll(RegExp(r'^0'), '')}';
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) {
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    try {
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(raw));
    } catch (_) {
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
  }

  double? _parseDouble(String? v) => v == null ? null : double.tryParse(v);
  String _safe(String? v) => v ?? '';
}
