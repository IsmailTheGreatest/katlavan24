class User {
  int id;
  int user;
  String? firstName;
  String? lastName;
  String? phone;
  double rating;
  String status;
  String? avatarUrl;

  User({
    required this.rating,
    required this.status,
    required this.user,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.avatarUrl,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}';

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"] as int,
    status: json['status'] as String,
    rating: json['rating'] as double,
    firstName: json["first_name"] as String?,
    lastName: json["last_name"] as String?,
    phone: json["phone"] as String?,
    avatarUrl: json["avatar_url"] as String?,
    user: json['user'] as int,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    'user': user,
    'status': status,
    'rating': rating,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "avatar_url": avatarUrl,
  };

  bool get isAuthenticated => firstName != null && lastName != null;

  @override
  bool operator ==(Object other) {
    return other is User && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
