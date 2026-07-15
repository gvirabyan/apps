// Models for the Wafeq REST API — field names verified from live API responses.

// ── Contact ──────────────────────────────────────────────────────────────────

class WafeqContactRequest {
  final String name;
  final String phone;
  final String address;
  final String district; // area / neighbourhood
  final String city;
  final String postalCode;
  final String country;

  const WafeqContactRequest({
    required this.name,
    required this.phone,
    required this.address,
    required this.district,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'address': address,
        'district': district,
        'city': city,
        'postal_code': postalCode,
        'country': country,
      };
}

class WafeqContactResponse {
  final String id; // e.g. "co_WDUpsEYMLMrBBMARssoAr2"
  final String name;

  const WafeqContactResponse({required this.id, required this.name});

  factory WafeqContactResponse.fromJson(Map<String, dynamic> json) {
    return WafeqContactResponse(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

// ── Line Item ─────────────────────────────────────────────────────────────────

class WafeqLineItem {
  final String account; // Chart of Accounts string ID
  final String description;
  final double quantity;
  final double unitAmount; // EXCLUDING VAT
  final String taxRate;    // Wafeq tax ID (not percentage), e.g. 'tax_NaNjXPpwbUoVDGhwgvEjFj'

  const WafeqLineItem({
    required this.account,
    required this.description,
    required this.quantity,
    required this.unitAmount,
    required this.taxRate,
  });

  Map<String, dynamic> toJson() => {
        'account': account,
        'description': description,
        'quantity': quantity,
        'unit_amount': unitAmount,
        'tax_rate': taxRate,
      };
}

// ── Invoice ───────────────────────────────────────────────────────────────────

class WafeqInvoiceRequest {
  final String type;
  final String invoiceNumber;
  final String invoiceDate;    // YYYY-MM-DD
  final String invoiceDueDate; // YYYY-MM-DD
  final String currency;       // 'SAR'
  final String contact;        // Wafeq contact string ID
  final List<WafeqLineItem> lineItems;
  final String notes;

  const WafeqInvoiceRequest({
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.invoiceDueDate,
    required this.contact,
    required this.lineItems,
    required this.notes,
    this.type = 'invoice',
    this.currency = 'SAR',
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'invoice_number': invoiceNumber,
        'invoice_date': invoiceDate,
        'invoice_due_date': invoiceDueDate,
        'currency': currency,
        'contact': contact,
        'line_items': lineItems.map((l) => l.toJson()).toList(),
        'notes': notes,
      };
}

// ── Invoice Response ──────────────────────────────────────────────────────────

class WafeqInvoiceResponse {
  final String id;
  final String invoiceNumber;
  final String status;

  const WafeqInvoiceResponse({
    required this.id,
    required this.invoiceNumber,
    required this.status,
  });

  factory WafeqInvoiceResponse.fromJson(Map<String, dynamic> json) {
    return WafeqInvoiceResponse(
      id: json['id']?.toString() ?? '',
      invoiceNumber: json['invoice_number']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}
