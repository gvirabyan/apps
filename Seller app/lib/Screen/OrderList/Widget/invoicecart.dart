import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Provider/ProfileProvider.dart';
import 'package:sellermultivendor/Services/invoice_html_service.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';

class InvoiceCard extends StatefulWidget {
  final OrderModel order;
  const InvoiceCard({super.key, required this.order});

  @override
  State<InvoiceCard> createState() => _InvoiceCardState();
}

class _InvoiceCardState extends State<InvoiceCard> {
  bool _loading = false;

  Future<bool> _checkPermission() async {
    final status = await Permission.storage.status;
    if (status.isGranted) return true;
    final result = await Permission.storage.request();
    return result.isGranted;
  }

  Future<void> _downloadInvoice() async {
    if (_loading) return;
    setState(() => _loading = true);
    debugPrint('📄 INVOICE | [InvoiceCard] tapped — order=#${widget.order.id}');
    try {
      final profile =
          Provider.of<ProfileProvider>(context, listen: false);

      debugPrint(
          '📄 INVOICE | [InvoiceCard] seller="${profile.storename}" vat="${profile.taxnumber}"');

      final html = InvoiceHtmlService.generateInvoiceHtml(
        order: widget.order,
        sellerName: profile.storename ?? '',
        sellerVatNumber: profile.taxnumber ?? '',
      );

      debugPrint('📄 INVOICE | [InvoiceCard] HTML generated, length=${html.length}');

      final hasPermission = await _checkPermission();
      debugPrint('📄 INVOICE | [InvoiceCard] storagePermission=$hasPermission');

      final targetDir = Platform.isAndroid && hasPermission
          ? await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOAD)
          : (await getApplicationDocumentsDirectory()).path;

      final fileName = 'Invoice_Order_${widget.order.id}';
      debugPrint('📄 INVOICE | [InvoiceCard] converting to PDF → $targetDir/$fileName.pdf');

      final pdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
          html, targetDir, fileName);

      debugPrint('📄 INVOICE | [InvoiceCard] PDF saved → ${pdfFile.path}');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '${'INVOICE_PATH'.translate(context: context)} $fileName.pdf',
          textAlign: TextAlign.center,
          style: const TextStyle(color: black),
        ),
        action: SnackBarAction(
          label: 'VIEW'.translate(context: context),
          textColor: black,
          onPressed: () async => OpenFile.open(pdfFile.path),
        ),
        backgroundColor: white,
        elevation: 1.0,
      ));
    } catch (e, st) {
      debugPrint('📄 INVOICE | [InvoiceCard] ERROR: $e\n$st');
      if (mounted) setSnackbar(e.toString(), context);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: InkWell(
        onTap: _downloadInvoice,
        child: ListTile(
          dense: true,
          trailing: _loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primary,
                  ),
                )
              : const Icon(Icons.keyboard_arrow_right, color: primary),
          leading: const Icon(Icons.receipt, color: primary),
          title: Text(
            'Download Invoice'.translate(context: context),
            style:
                Theme.of(context).textTheme.titleSmall!.copyWith(color: black),
          ),
        ),
      ),
    );
  }
}