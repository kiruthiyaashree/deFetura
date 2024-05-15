class CustomerDetailsModel {
  final String name;
  final String? sqrts; // Change to nullable
  final String address;
  final String city;
  final String? phonenumber; // Change to nullable

  const CustomerDetailsModel({
    required this.name,
    required this.sqrts,
    required this.address,
    required this.city,
    required this.phonenumber,
  });

  factory CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsModel(
      name: json['name'] ?? '', // Provide default value if null
      sqrts: json['sqrts'], // No need for toString() as sqrts is already a String
      address: json['address'] ?? '', // Provide default value if null
      city: json['city'] ?? '',
      phonenumber: json['phonenumber'] ?? null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sqrts': sqrts,
      'address': address,
      'city': city,
      'phonenumber': phonenumber,
    };
  }
}
