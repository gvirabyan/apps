import 'package:sellermultivendor/Widget/parameterString.dart';

class ZipcodeGroupModel {
  String? id, groupName, deliveryCharge;
  List<ZipCodeListModel> zipcodes;

  ZipcodeGroupModel({
    this.id,
    this.groupName,
    this.deliveryCharge,
    this.zipcodes = const [],
  });

  factory ZipcodeGroupModel.fromJson(Map<String, dynamic> json) {
    return ZipcodeGroupModel(
      id: json[Id],
      groupName: json['group_name'],
      deliveryCharge: json['delivery_charges'],
      zipcodes: List<ZipCodeListModel>.from(
        json['zipcodes'].map((x) => ZipCodeListModel.fromJson(x)),
      ),
    );
  }
}

class ZipCodeListModel {
  String? zipcodeId, zipcode;

  ZipCodeListModel({this.zipcodeId, this.zipcode});

  factory ZipCodeListModel.fromJson(Map<String, dynamic> json) {
    return ZipCodeListModel(
      zipcodeId: json['zipcode_id'],
      zipcode: json['zipcode'],
    );
  }
}
