import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:qr/qr.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/appConstants.dart';

/// Generates a fully self-contained HTML invoice (no external resources)
/// that can be converted to PDF via flutter_html_to_pdf.
///
/// Includes:
///   • Customer name, phone number
///   • City (required — logistics)
///   • Neighborhood/district (required — logistics)
///   • Order details (ID, date, payment)
///   • Product table (name, variant, qty, price, line total)
///   • Price summary: subtotal, delivery, promo, wallet, VAT, total payable
///   • Postal code (informational)
///   • ZATCA-compliant QR code as inline SVG
class InvoiceHtmlService {
  InvoiceHtmlService._();

  /// Generates invoice HTML for [order].
  ///
  /// [sellerName] and [sellerVatNumber] come from the seller's profile.
  /// If empty, [AppConstants.app_name] / blank are used.
  static String generateInvoiceHtml({
    required OrderModel order,
    String sellerName = '',
    String sellerVatNumber = '',
  }) {
    final resolvedSellerName =
        sellerName.isNotEmpty ? sellerName : AppConstants.app_name;

    final customerName =
        (order.name?.isNotEmpty == true ? order.name : order.username) ??
            'Customer';
    final phone = _formatPhone(order.mobile, order.countryCode);
    final city = order.cityName ?? '';
    final neighborhood = order.areaName ?? '';
    final postalCode = order.postalCode ?? '';
    final address = order.address ?? '';

    final invoiceDateRaw = order.dateAdded ?? '';
    final invoiceDateDisplay = _formatDateDisplay(invoiceDateRaw);
    final invoiceDateZatca = _formatDateZatca(invoiceDateRaw);

    final totalPayable =
        double.tryParse(order.totalPayable ?? '0') ?? 0.0;
    final vatAmount =
        double.tryParse(order.totalTaxAmount ?? '0') ?? 0.0;

    // ── ZATCA QR code (TLV → base64 → QR SVG → base64 img) ──────────────────
    debugPrint('📄 INVOICE | order=#${order.id} seller="$resolvedSellerName" vat="$sellerVatNumber"');
    debugPrint('📄 INVOICE | totalPayable=$totalPayable vatAmount=$vatAmount invoiceDate=$invoiceDateZatca');

    final zatcaBase64 = _buildZatcaTlv(
      sellerName: resolvedSellerName,
      vatNumber: sellerVatNumber,
      invoiceDate: invoiceDateZatca,
      totalInclVat: totalPayable,
      vatAmount: vatAmount,
    );
    debugPrint('📄 INVOICE | zatcaBase64 length=${zatcaBase64.length} value=$zatcaBase64');

    final qrSvgInline = _qrToSvgInline(zatcaBase64, size: 160);
    debugPrint('📄 INVOICE | qrSvgInline length=${qrSvgInline.length}');

    // Embed SVG as base64 data URI inside <img> tag.
    // This is more reliable in WebView-based PDF renderers than raw inline SVG.
    final svgBase64 = base64Encode(utf8.encode(qrSvgInline));
    final qrImgTag = '<img src="data:image/svg+xml;base64,$svgBase64" '
        'width="160" height="160" alt="QR Code" />';
    debugPrint('📄 INVOICE | qrImgTag data-uri length=${svgBase64.length}');

    // ── Product rows ─────────────────────────────────────────────────────────
    final productRows = _buildProductRows(order);

    // ── Price rows ───────────────────────────────────────────────────────────
    final subtotal = double.tryParse(order.total ?? '0') ?? 0.0;
    final delivery = double.tryParse(
            order.sellerDeliveryCharge ?? order.deliveryCharge ?? '0') ??
        0.0;
    final promo = double.tryParse(order.promoDiscount ?? '0') ?? 0.0;
    final wallet = double.tryParse(order.walletBalance ?? '0') ?? 0.0;
    final vatPct = order.totalTaxPercent ?? '';

    String priceRow(String label, String value, {bool bold = false}) {
      final style = bold ? 'style="font-weight:bold;"' : '';
      return '<tr $style><td>$label</td><td class="amt">$value SAR</td></tr>';
    }

    final priceRows = StringBuffer();
    priceRows.write(priceRow('Subtotal / المجموع الفرعي', _fmt(subtotal)));
    if (delivery > 0) {
      priceRows.write(priceRow('Delivery / الشحن', _fmt(delivery)));
    }
    if (promo > 0) {
      priceRows
          .write(priceRow('Promo Discount / خصم البروموكود', '-${_fmt(promo)}'));
    }
    if (wallet > 0) {
      priceRows.write(
          priceRow('Wallet Balance / رصيد المحفظة', '-${_fmt(wallet)}'));
    }
    if (vatAmount > 0) {
      final vatLabel =
          vatPct.isNotEmpty ? 'VAT $vatPct% / ضريبة القيمة المضافة' : 'VAT / ضريبة القيمة المضافة';
      priceRows.write(priceRow(vatLabel, _fmt(vatAmount)));
    }
    priceRows.write(priceRow(
        'Total Payable / الإجمالي المستحق', _fmt(totalPayable),
        bold: true));

    // ── Optional fields ───────────────────────────────────────────────────────
    String infoRow(String label, String value, {String? badge}) {
      if (value.isEmpty) return '';
      final badgeHtml =
          badge != null ? ' <span class="badge">$badge</span>' : '';
      return '<tr><td>$label$badgeHtml</td><td>$value</td></tr>';
    }

    final customerRows = StringBuffer();
    customerRows.write(infoRow('Customer / العميل', customerName));
    customerRows.write(infoRow('Phone / الهاتف', phone));
    customerRows.write(
        infoRow('City / المدينة', city, badge: city.isNotEmpty ? '★' : null));
    customerRows.write(infoRow('Neighborhood / الحي', neighborhood,
        badge: neighborhood.isNotEmpty ? '★' : null));
    if (address.isNotEmpty) {
      customerRows.write(infoRow('Address / العنوان', address));
    }
    if (postalCode.isNotEmpty) {
      customerRows
          .write(infoRow('Postal Code / الرمز البريدي', postalCode));
    }

    final orderRows = StringBuffer();
    orderRows.write(infoRow('Order ID / رقم الطلب', '#${order.id ?? "-"}'));
    orderRows.write(infoRow('Date / التاريخ', invoiceDateDisplay));
    orderRows.write(
        infoRow('Payment / طريقة الدفع', order.paymentMethod ?? '-'));
    if ((order.notes ?? '').isNotEmpty) {
      orderRows.write(infoRow('Notes / ملاحظات', order.notes!));
    }

    return '''<!DOCTYPE html>
<html lang="ar" dir="ltr">
<head>
<meta charset="UTF-8">
<style>
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: Arial, Helvetica, sans-serif; font-size: 13px;
         color: #333; padding: 24px; background: #fff; }

  /* ── Header ── */
  .header { display: flex; justify-content: space-between;
            align-items: flex-start; border-bottom: 2px solid #e87e7b;
            padding-bottom: 12px; margin-bottom: 20px; }
  .header-left h1 { font-size: 20px; color: #e87e7b; }
  .header-left p  { font-size: 11px; color: #888; margin-top: 2px; }
  .header-right   { text-align: right; }
  .header-right .inv-num { font-size: 16px; font-weight: bold; }
  .header-right .inv-date { font-size: 11px; color: #888; margin-top: 2px; }

  /* ── Section ── */
  .section { margin-bottom: 18px; }
  .section-title { font-size: 12px; font-weight: bold; text-transform: uppercase;
                   letter-spacing: 0.5px; background: #f7f7f7;
                   border-left: 3px solid #e87e7b; padding: 5px 8px;
                   margin-bottom: 8px; }

  /* ── Info tables ── */
  .info-table { width: 100%; border-collapse: collapse; }
  .info-table td { padding: 5px 6px; border-bottom: 1px solid #f0f0f0;
                   vertical-align: top; }
  .info-table td:first-child { color: #666; width: 45%; }
  .badge { font-size: 10px; color: #e87e7b; }

  /* ── Products table ── */
  .prod-table { width: 100%; border-collapse: collapse; }
  .prod-table th { background: #f7f7f7; padding: 7px 8px;
                   text-align: left; font-size: 12px;
                   border-bottom: 2px solid #ddd; }
  .prod-table td { padding: 7px 8px; border-bottom: 1px solid #f0f0f0;
                   font-size: 12px; }
  .prod-table .num { text-align: right; }

  /* ── Price table ── */
  .price-table { width: 100%; border-collapse: collapse; }
  .price-table td { padding: 5px 6px; border-bottom: 1px solid #f0f0f0; }
  .price-table .amt { text-align: right; }
  .price-table tr:last-child td { border-top: 2px solid #333;
                                   border-bottom: none; font-size: 14px; }

  /* ── QR ── */
  .qr-section { text-align: center; margin-top: 24px; padding: 16px;
                border: 1px solid #eee; border-radius: 4px; }
  .qr-section p { font-size: 10px; color: #999; margin-top: 8px; }

  /* ── Footer ── */
  .footer { margin-top: 20px; text-align: center; font-size: 10px;
            color: #bbb; border-top: 1px solid #eee; padding-top: 10px; }
</style>
</head>
<body>

<!-- Header -->
<div class="header">
  <div class="header-left">
    <h1>Tax Invoice / فاتورة ضريبية</h1>
    <p>$resolvedSellerName${sellerVatNumber.isNotEmpty ? ' &nbsp;|&nbsp; VAT: $sellerVatNumber' : ''}</p>
  </div>
  <div class="header-right">
    <div class="inv-num">#${order.id ?? '-'}</div>
    <div class="inv-date">$invoiceDateDisplay</div>
  </div>
</div>

<!-- Customer Details -->
<div class="section">
  <div class="section-title">Customer Details / بيانات العميل</div>
  <table class="info-table">
    $customerRows
  </table>
</div>

<!-- Order Details -->
<div class="section">
  <div class="section-title">Order Details / تفاصيل الطلب</div>
  <table class="info-table">
    $orderRows
  </table>
</div>

<!-- Products -->
<div class="section">
  <div class="section-title">Products / المنتجات</div>
  <table class="prod-table">
    <thead>
      <tr>
        <th>Product / المنتج</th>
        <th class="num">Qty</th>
        <th class="num">Price</th>
        <th class="num">Total</th>
      </tr>
    </thead>
    <tbody>
      $productRows
    </tbody>
  </table>
</div>

<!-- Price Summary -->
<div class="section">
  <div class="section-title">Price Summary / ملخص الأسعار</div>
  <table class="price-table">
    $priceRows
  </table>
</div>

<!-- QR Code -->
<div class="qr-section">
  $qrImgTag
  <p>Scan to verify · امسح للتحقق الضريبي (ZATCA)</p>
</div>

<div class="footer">
  Generated by ${AppConstants.app_name} &nbsp;·&nbsp; $invoiceDateDisplay
</div>

</body>
</html>''';
  }

  // ── Product rows ─────────────────────────────────────────────────────────────

  static String _buildProductRows(OrderModel order) {
    final buf = StringBuffer();
    for (final item in order.orderItems) {
      final name = item.productName ?? item.name ?? '-';
      final variant = (item.variantName?.isNotEmpty == true)
          ? ' <span style="font-size:11px;color:#888;">(${item.variantName})</span>'
          : '';
      final qty = item.quantity ?? '1';
      final unitPrice =
          double.tryParse(item.discountedPrice ?? item.price ?? '0') ?? 0.0;
      final lineTotal = unitPrice * (double.tryParse(qty) ?? 1.0);
      buf.write('''
      <tr>
        <td>$name$variant</td>
        <td class="num">$qty</td>
        <td class="num">${_fmt(unitPrice)}</td>
        <td class="num">${_fmt(lineTotal)}</td>
      </tr>''');
    }
    return buf.toString();
  }

  // ── ZATCA TLV ────────────────────────────────────────────────────────────────

  /// Encodes fields as ZATCA TLV (Tag-Length-Value) then base64.
  static String _buildZatcaTlv({
    required String sellerName,
    required String vatNumber,
    required String invoiceDate,
    required double totalInclVat,
    required double vatAmount,
  }) {
    final builder = BytesBuilder();

    void tlv(int tag, String value) {
      final bytes = utf8.encode(value);
      builder.addByte(tag);
      builder.addByte(bytes.length);
      builder.add(bytes);
    }

    tlv(1, sellerName);
    tlv(2, vatNumber.isNotEmpty ? vatNumber : '0000000000');
    tlv(3, invoiceDate.isNotEmpty ? invoiceDate : DateTime.now().toIso8601String());
    tlv(4, totalInclVat.toStringAsFixed(2));
    tlv(5, vatAmount.toStringAsFixed(2));

    return base64Encode(builder.toBytes());
  }

  // ── QR code → SVG string ─────────────────────────────────────────────────────

  /// Returns a pure SVG string. Caller embeds it as base64 data URI in <img>.
  static String _qrToSvgInline(String data, {int size = 160}) {
    debugPrint('📄 INVOICE | _qrToSvgInline: dataLen=${data.length}');

    final qr = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.M,
    );
    final img = QrImage(qr);
    final n = qr.moduleCount;
    final m = size / n;

    debugPrint('📄 INVOICE | QR moduleCount=$n pixelPerModule=${m.toStringAsFixed(2)}');

    int darkCount = 0;
    final buf = StringBuffer();
    buf.write('<svg xmlns="http://www.w3.org/2000/svg" '
        'width="$size" height="$size" viewBox="0 0 $size $size">');
    buf.write('<rect width="$size" height="$size" fill="white"/>');

    for (int y = 0; y < n; y++) {
      for (int x = 0; x < n; x++) {
        if (img.isDark(y, x)) {
          darkCount++;
          final px = (x * m).toStringAsFixed(2);
          final py = (y * m).toStringAsFixed(2);
          final ms = m.toStringAsFixed(2);
          buf.write(
              '<rect x="$px" y="$py" width="$ms" height="$ms" fill="black"/>');
        }
      }
    }

    buf.write('</svg>');
    debugPrint('📄 INVOICE | SVG dark=$darkCount svgLen=${buf.length}');
    return buf.toString();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  static String _formatPhone(String? mobile, String? countryCode) {
    if (mobile == null || mobile.isEmpty) return '-';
    if (mobile.startsWith('+')) return mobile;
    final code = countryCode?.replaceAll('+', '') ?? '966';
    return '+$code${mobile.replaceAll(RegExp(r'^0+'), '')}';
  }

  static String _formatDateDisplay(String? raw) {
    if (raw == null || raw.isEmpty) {
      return DateFormat('dd MMM yyyy').format(DateTime.now());
    }
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(raw));
    } catch (_) {
      return raw;
    }
  }

  static String _formatDateZatca(String? raw) {
    if (raw == null || raw.isEmpty) return DateTime.now().toIso8601String();
    try {
      return DateTime.parse(raw).toIso8601String();
    } catch (_) {
      return DateTime.now().toIso8601String();
    }
  }

  static String _fmt(double v) => v.toStringAsFixed(2);
}