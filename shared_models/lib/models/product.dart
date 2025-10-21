class Product {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final double? customerPrice;
  final List<String> imageUrls;
  final String category;
  final String vendorId;
  final String vendorName;
  final double rating;
  final int reviewCount;
  final int stockQuantity;
  final bool isActive;
  final bool isFeatured;
  final List<String> tags;
  final Map<String, dynamic> specifications;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    this.customerPrice,
    required this.imageUrls,
    required this.category,
    required this.vendorId,
    required this.vendorName,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.stockQuantity = 0,
    this.isActive = true,
    this.isFeatured = false,
    this.tags = const [],
    this.specifications = const {},
    required this.createdAt,
    required this.updatedAt,
  });

  // ADD THESE GETTERS BACK:
  double get displayPrice => customerPrice ?? basePrice;
  double get discountPercent => ((basePrice - displayPrice) / basePrice) * 100;
  bool get hasDiscount => displayPrice < basePrice;
  bool get inStock => stockQuantity > 0;

  Product copyWith({
    double? customerPrice,
  }) {
    return Product(
      id: id,
      name: name,
      description: description,
      basePrice: basePrice,
      customerPrice: customerPrice ?? this.customerPrice,
      imageUrls: imageUrls,
      category: category,
      vendorId: vendorId,
      vendorName: vendorName,
      rating: rating,
      reviewCount: reviewCount,
      stockQuantity: stockQuantity,
      isActive: isActive,
      isFeatured: isFeatured,
      tags: tags,
      specifications: specifications,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'customerPrice': customerPrice,
      'imageUrls': imageUrls,
      'category': category,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'rating': rating,
      'reviewCount': reviewCount,
      'stockQuantity': stockQuantity,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'tags': tags,
      'specifications': specifications,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Product.fromMap(String id, Map<String, dynamic> map) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      basePrice: (map['basePrice'] ?? 0).toDouble(),
      customerPrice: map['customerPrice']?.toDouble(),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      category: map['category'] ?? '',
      vendorId: map['vendorId'] ?? '',
      vendorName: map['vendorName'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      stockQuantity: map['stockQuantity'] ?? 0,
      isActive: map['isActive'] ?? true,
      isFeatured: map['isFeatured'] ?? false,
      tags: List<String>.from(map['tags'] ?? []),
      specifications: Map<String, dynamic>.from(map['specifications'] ?? {}),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
    );
  }
}
