class Area {
  String id;
  String name;
  String cityId;

  Area({
    required this.id,
    required this.name,
    required this.cityId,
  });

  factory Area.fromMap(Map<String, dynamic> map) {
    return Area(
      id: map['id'].toString(),
      name: map['name'] ?? "",
      cityId: map['city_id']?.toString() ?? "",
    );
  }

  @override
  bool operator ==(Object o) => o is Area && id == o.id;

  @override
  int get hashCode => id.hashCode;
}
