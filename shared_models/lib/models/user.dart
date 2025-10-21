class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final List<String> addresses;
  final List<String> wishlist;
  final DateTime joinedDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.addresses = const [],
    this.wishlist = const [],
    required this.joinedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'addresses': addresses,
      'wishlist': wishlist,
      'joinedDate': joinedDate.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(String id, Map<String, dynamic> map) {
    return User(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      addresses: List<String>.from(map['addresses'] ?? []),
      wishlist: List<String>.from(map['wishlist'] ?? []),
      joinedDate: DateTime.fromMillisecondsSinceEpoch(map['joinedDate'] ?? 0),
    );
  }
}
