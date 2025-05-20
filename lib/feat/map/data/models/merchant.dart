class Merchant {
  final String guid;
  final String name;
  final String logo;
  final String phoneNumber;
  final AddressModel address;

  Merchant({
    required this.guid,
    required this.name,
    required this.logo,
    required this.phoneNumber,
    required this.address,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      guid: json['guid'],
      name: json['name'],
      logo: json['logo'],
      phoneNumber: json['phone_number'],
      address: AddressModel.fromJson(json['address']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guid': guid,
      'name': name,
      'logo': logo,
      'phone_number': phoneNumber,
      'address': address.toJson(),
    };
  }
}

class AddressModel {
  final String guid;
  final String city;
  final String district;
  final String address;
  final double latitude;
  final double longitude;
   double distance;

  AddressModel({
    required this.guid,
    required this.city,
    required this.district,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      guid: json['guid'],
      city: json['city'],
      district: json['district'],
      address: json['address'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'guid': guid,
      'city': city,
      'district': district,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
    };
  }
}
