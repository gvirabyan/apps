import 'package:sellermultivendor/Widget/parameterString.dart';

class CityGroupModel {
  String? id, groupName, deliveryCharge;
  List<CityListModel> cities;

  CityGroupModel({
    this.id,
    this.groupName,
    this.deliveryCharge,
    this.cities = const [],
  });

  factory CityGroupModel.fromJson(Map<String, dynamic> json) {
    return CityGroupModel(
      id: json[Id],
      groupName: json['group_name'],
      deliveryCharge: json['delivery_charges'],
      cities: json['cities'] != null
          ? List<CityListModel>.from(
              json['cities'].map((x) => CityListModel.fromJson(x)),
            )
          : [],
    );
  }
}

class CityListModel {
  String? cityId, cityName;

  CityListModel({this.cityId, this.cityName});

  factory CityListModel.fromJson(Map<String, dynamic> json) {
    return CityListModel(cityId: json['city_id'], cityName: json['city_name']);
  }
}
