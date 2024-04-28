class CustomerDetailsModel {
  final String name;
  final String sqrts;
  final String address;
  final String city;

  const CustomerDetailsModel({
    required this.name,
    required this.sqrts,
    required this.address,
    required this.city,
  });
  factory CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsModel(
      name: json['name'],
      sqrts: json['sqrts'],
      address: json['address'],
      city: json['city'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sqrts': sqrts.toString(),
      'address': address,
      'city': city,
    };
  }
}
