class Product {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final double? customerPrice;
  final String imageUrl;
  final String category;
  final String vendorId;
  final String vendorName;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final bool isActive;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    this.customerPrice,
    required this.imageUrl,
    required this.category,
    required this.vendorId,
    required this.vendorName,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.createdAt,
    this.isActive = true,
  });

  double get displayPrice => customerPrice ?? basePrice;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'customerPrice': customerPrice,
      'imageUrl': imageUrl,
      'category': category,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      basePrice: map['basePrice'].toDouble(),
      customerPrice: map['customerPrice']?.toDouble(),
      imageUrl: map['imageUrl'],
      category: map['category'],
      vendorId: map['vendorId'],
      vendorName: map['vendorName'],
      rating: map['rating'].toDouble(),
      reviewCount: map['reviewCount'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      isActive: map['isActive'] ?? true,
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? basePrice,
    double? customerPrice,
    String? imageUrl,
    String? category,
    String? vendorId,
    String? vendorName,
    double? rating,
    int? reviewCount,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      customerPrice: customerPrice ?? this.customerPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}