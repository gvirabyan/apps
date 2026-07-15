class AppSettingsModel {
  bool isSMSGatewayOn;
  bool isCityWiseDeliveribility;
  bool isShiprocketOn;
  String defaultCountryCode;
  String productDeliverabilityType;
  AppSettingsModel({
    required this.isSMSGatewayOn,
    required this.isCityWiseDeliveribility,
    required this.isShiprocketOn,
    required this.defaultCountryCode,
    required this.productDeliverabilityType,
  });

  factory AppSettingsModel.fromMap(Map<String, dynamic> data) {
    return AppSettingsModel(
      isSMSGatewayOn:
          data['authentication_settings'] != null &&
              data['authentication_settings'].isNotEmpty
          ? data['authentication_settings'][0]['authentication_method']
                    .toString()
                    .toLowerCase() ==
                'sms'
          : false,
      isCityWiseDeliveribility:
          data['shipping_method'] != null && data['shipping_method'].isNotEmpty
          ? data['shipping_method'][0]['city_wise_deliverability'].toString() ==
                "1"
          : false,
      isShiprocketOn:
          data['shipping_method'] != null && data['shipping_method'].isNotEmpty
          ? data['shipping_method'][0]['shiprocket_shipping_method']
                    .toString() ==
                "1"
          : false,
      defaultCountryCode:
          data['system_settings'] != null && data['system_settings'].isNotEmpty
          ? (data['system_settings'][0]['default_country_code'] ?? 'IN').toString()
          : 'IN',
      productDeliverabilityType:
          data['shipping_method'] != null && data['shipping_method'].isNotEmpty
          ? (data['shipping_method'][0]['product_deliverability_type'] ?? '1').toString()
          : '1',
    );
  }
}
