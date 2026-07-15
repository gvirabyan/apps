
class ReturnOrderModel {
  String? id;
  String? orderId;
  String? orderItemId;
  String? userId;
  String? sellerId;
  String? addressId;
  String? userAddress;
  String? userLatitude;
  String? userLongitude;
  String? adminAddress;
  String? adminLatitude;
  String? adminLongitude;
  String? adminMobile;
  String? notes;
  String? username;
  String? sellerName;
  String? isCredited;
  String? productName;
  String? productImage;
  String? mobile;
  String? subTotal;
  String? quantity;
  String? deliveryBoy;
  String? paymentMethod;
  String? deliveryBoyId;
  String? productVariantId;
  String? deliveryDate;
  String? deliveryTime;
  String? courierAgency;
  String? trackingId;
  String? url;
  String? updatedBy;
  String? status;
  String? transactionStatus;
  String? activeStatus;
  String? mailStatus;
  String? dateAdded;
  String? operate;

  ReturnOrderModel({
    this.id,
    this.orderId,
    this.orderItemId,
    this.userId,
    this.sellerId,
    this.addressId,
    this.userAddress,
    this.userLatitude,
    this.userLongitude,
    this.adminAddress,
    this.adminLatitude,
    this.adminLongitude,
    this.adminMobile,
    this.notes,
    this.username,
    this.sellerName,
    this.isCredited,
    this.productName,
    this.productImage,
    this.mobile,
    this.subTotal,
    this.quantity,
    this.deliveryBoy,
    this.paymentMethod,
    this.deliveryBoyId,
    this.productVariantId,
    this.deliveryDate,
    this.deliveryTime,
    this.courierAgency,
    this.trackingId,
    this.url,
    this.updatedBy,
    this.status,
    this.transactionStatus,
    this.activeStatus,
    this.mailStatus,
    this.dateAdded,
    this.operate,
  });

  //for update order

  void changeValures(ReturnOrderModel order) {
    id = order.id;
    orderId = order.orderId;
    orderItemId = order.orderItemId;
    userId = order.userId;
    sellerId = order.sellerId;
    addressId = order.addressId;
    userAddress = order.userAddress;
    userLatitude = order.userLatitude;
    userLongitude = order.userLongitude;
    adminAddress = order.adminAddress;
    adminLatitude = order.adminLatitude;
    adminLongitude = order.adminLongitude;
    adminMobile = order.adminMobile;
    notes = order.notes;
    username = order.username;
    sellerName = order.sellerName;
    isCredited = order.isCredited;
    productName = order.productName;
    productImage = order.productImage;
    mobile = order.mobile;
    subTotal = order.subTotal;
    quantity = order.quantity;
    deliveryBoy = order.deliveryBoy;
    paymentMethod = order.paymentMethod;
    deliveryBoyId = order.deliveryBoyId;
    productVariantId = order.productVariantId;
    deliveryDate = order.deliveryDate;
    deliveryTime = order.deliveryTime;
    courierAgency = order.courierAgency;
    trackingId = order.trackingId;
    url = order.url;
    updatedBy = order.updatedBy;
    status = order.status;
    transactionStatus = order.transactionStatus;
    activeStatus = order.activeStatus;
    mailStatus = order.mailStatus;
    dateAdded = order.dateAdded;
    operate = order.operate;
  }

  ReturnOrderModel copyWith({
    String? id,
    String? orderId,
    String? orderItemId,
    String? userId,
    String? sellerId,
    String? addressId,
    String? userAddress,
    String? userLatitude,
    String? userLongitude,
    String? adminAddress,
    String? adminLatitude,
    String? adminLongitude,
    String? notes,
    String? username,
    String? sellerName,
    String? isCredited,
    String? productName,
    String? productImage,
    String? mobile,
    String? subTotal,
    String? quantity,
    String? deliveryBoy,
    String? paymentMethod,
    String? deliveryBoyId,
    String? productVariantId,
    String? deliveryDate,
    String? deliveryTime,
    String? courierAgency,
    String? trackingId,
    String? url,
    String? updatedBy,
    String? status,
    String? transactionStatus,
    String? activeStatus,
    String? mailStatus,
    String? dateAdded,
    String? operate,
  }) {
    return ReturnOrderModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      orderItemId: orderItemId ?? this.orderItemId,
      userId: userId ?? this.userId,
      sellerId: sellerId ?? this.sellerId,
      addressId: addressId ?? this.addressId,
      userAddress: userAddress ?? this.userAddress,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      adminAddress: adminAddress ?? this.adminAddress,
      adminLatitude: adminLatitude ?? this.adminLatitude,
      adminLongitude: adminLongitude ?? this.adminLongitude,
      adminMobile: adminMobile ?? this.adminMobile,
      notes: notes ?? this.notes,
      username: username ?? this.username,
      sellerName: sellerName ?? this.sellerName,
      isCredited: isCredited ?? this.isCredited,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      mobile: mobile ?? this.mobile,
      subTotal: subTotal ?? this.subTotal,
      quantity: quantity ?? this.quantity,
      deliveryBoy: deliveryBoy ?? this.deliveryBoy,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryBoyId: deliveryBoyId ?? this.deliveryBoyId,
      productVariantId: productVariantId ?? this.productVariantId,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      courierAgency: courierAgency ?? this.courierAgency,
      trackingId: trackingId ?? this.trackingId,
      url: url ?? this.url,
      updatedBy: updatedBy ?? this.updatedBy,
      status: status ?? this.status,
      transactionStatus: transactionStatus ?? this.transactionStatus,
      activeStatus: activeStatus ?? this.activeStatus,
      mailStatus: mailStatus ?? this.mailStatus,
      dateAdded: dateAdded ?? this.dateAdded,
      operate: operate ?? this.operate,
    );
  }

  ReturnOrderModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        orderId = json['order_id'] as String?,
        orderItemId = json['order_item_id'] as String?,
        userId = json['user_id'] as String?,
        sellerId = json['seller_id'] as String?,
        addressId = json['address_id'] as String?,
        userAddress = json['user_address'] as String?,
        userLatitude = json['user_latitude'] as String?,
        userLongitude = json['user_longitude'] as String?,
        adminAddress = json['admin_address'] as String?,
        adminLatitude = json['admin_latitude'] as String?,
        adminLongitude = json['admin_longitude'] as String?,
        adminMobile = json['admin_mobile'] as String?,
        notes = json['notes'] as String?,
        username = json['username'] as String?,
        sellerName = json['seller_name'] as String?,
        isCredited = json['is_credited'] as String?,
        productName = json['product_name'] as String?,
        productImage = json['product_image'] as String?,
        mobile = json['mobile'] as String?,
        subTotal = json['sub_total'] as String?,
        quantity = json['quantity'] as String?,
        deliveryBoy = json['delivery_boy'] as String?,
        paymentMethod = json['payment_method'] as String?,
        deliveryBoyId = json['delivery_boy_id'] as String?,
        productVariantId = json['product_variant_id'] as String?,
        deliveryDate = json['delivery_date'] as String?,
        deliveryTime = json['delivery_time'] as String?,
        courierAgency = json['courier_agency'] as String?,
        trackingId = json['tracking_id'] as String?,
        url = json['url'] as String?,
        updatedBy = json['updated_by'] as String?,
        status = json['status'] as String?,
        transactionStatus = json['transaction_status'] as String?,
        activeStatus = json['active_status'] as String?,
        mailStatus = json['mail_status'] as String?,
        dateAdded = json['date_added'] as String?,
        operate = json['operate'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'order_id': orderId,
        'order_item_id': orderItemId,
        'user_id': userId,
        'seller_id': sellerId,
        'address_id': addressId,
        'user_address': userAddress,
        'user_latitude': userLatitude,
        'user_longitude': userLongitude,
        'admin_address': adminAddress,
        'admin_latitude': adminLatitude,
        'admin_longitude': adminLongitude,
        'notes': notes,
        'username': username,
        'seller_name': sellerName,
        'is_credited': isCredited,
        'product_name': productName,
        'product_image': productImage,
        'mobile': mobile,
        'sub_total': subTotal,
        'quantity': quantity,
        'delivery_boy': deliveryBoy,
        'payment_method': paymentMethod,
        'delivery_boy_id': deliveryBoyId,
        'product_variant_id': productVariantId,
        'delivery_date': deliveryDate,
        'delivery_time': deliveryTime,
        'courier_agency': courierAgency,
        'tracking_id': trackingId,
        'url': url,
        'updated_by': updatedBy,
        'status': status,
        'transaction_status': transactionStatus,
        'active_status': activeStatus,
        'mail_status': mailStatus,
        'date_added': dateAdded,
        'operate': operate
      };
}
