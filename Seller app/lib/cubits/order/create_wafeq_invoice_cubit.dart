import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sellermultivendor/Model/order/order_model.dart';
import 'package:sellermultivendor/Model/wafeq/wafeq_invoice_request.dart' show WafeqInvoiceResponse;
import 'package:sellermultivendor/Repository/wafeq_invoice_repository.dart';
import 'package:sellermultivendor/Services/wafeq_service.dart';

// ── States ──────────────────────────────────────────────────────────────────

abstract class CreateWafeqInvoiceState {}

class CreateWafeqInvoiceInitial extends CreateWafeqInvoiceState {}

class CreateWafeqInvoiceInProgress extends CreateWafeqInvoiceState {}

class CreateWafeqInvoiceSuccess extends CreateWafeqInvoiceState {
  /// null when the invoice already existed (duplicate — not an error).
  final WafeqInvoiceResponse? invoice;
  CreateWafeqInvoiceSuccess({this.invoice});
}

class CreateWafeqInvoiceFailed extends CreateWafeqInvoiceState {
  final String errorMessage;
  CreateWafeqInvoiceFailed(this.errorMessage);
}

// ── Cubit ────────────────────────────────────────────────────────────────────

/// Triggers ZATCA-compliant e-invoice creation on Wafeq for a given order.
///
/// A failed invoice creation NEVER blocks the order flow — errors are logged
/// and exposed via [CreateWafeqInvoiceFailed] so the UI can flag them without
/// preventing other order operations from proceeding.
class CreateWafeqInvoiceCubit extends Cubit<CreateWafeqInvoiceState> {
  CreateWafeqInvoiceCubit() : super(CreateWafeqInvoiceInitial());

  Future<void> createInvoice(OrderModel order) async {
    if (state is CreateWafeqInvoiceInProgress) {
      debugPrint('🧾 WAFEQ | [Cubit] already in progress, skipping');
      return;
    }

    debugPrint('🧾 WAFEQ | [Cubit] createInvoice called for order #${order.id} | customer=${order.name} | total=${order.finalTotal}');

    try {
      emit(CreateWafeqInvoiceInProgress());

      final response =
          await WafeqInvoiceRepository.instance.createInvoiceForOrder(order);

      debugPrint('🧾 WAFEQ | [Cubit] SUCCESS — invoiceNumber=${response?.invoiceNumber ?? "already existed"}');
      emit(CreateWafeqInvoiceSuccess(invoice: response));
    } on WafeqServiceException catch (e) {
      debugPrint('🧾 WAFEQ | [Cubit] FAILED — ${e.message}');
      emit(CreateWafeqInvoiceFailed(e.message));
    } catch (e) {
      debugPrint('🧾 WAFEQ | [Cubit] UNEXPECTED ERROR — $e');
      emit(CreateWafeqInvoiceFailed(e.toString()));
    }
  }
}
