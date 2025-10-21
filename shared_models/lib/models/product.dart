import 'dart:convert';

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

  double get displayPrice => customerPrice ?? basePrice;
  double get discountPercent => ((basePrice - displayPrice) / basePrice) * 100;
  bool get hasDiscount => displayPrice < basePrice;
  bool get inStock => stockQuantity > 0;

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

  String toJson() => json.encode(toMap());
  factory Product.fromJson(String source) => Product.fromMap('', json.decode(source));
}

class CartItem {
  final Product product;
  int quantity;
  final Map<String, dynamic>? selectedVariants;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedVariants,
  });

  double get totalPrice => product.displayPrice * quantity;

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'selectedVariants': selectedVariants,
    };
  }
}

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final double shippingFee;
  final double taxAmount;
  final String status;
  final String paymentMethod;
  final String shippingAddress;
  final DateTime orderDate;
  final DateTime? deliveryDate;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.shippingFee = 0,
    this.taxAmount = 0,
    required this.status,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.orderDate,
    this.deliveryDate,
  });

  double get grandTotal => totalAmount + shippingFee + taxAmount;
}

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
   Product copyWith({
    String? id,
    String? name,
    String? description,
    double? basePrice,
    double? customerPrice,
    List<String>? imageUrls,
    String? category,
    String? vendorId,
    String? vendorName,
    double? rating,
    int? reviewCount,
    int? stockQuantity,
    bool? isActive,
    bool? isFeatured,
    List<String>? tags,
    Map<String, dynamic>? specifications,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      customerPrice: customerPrice ?? this.customerPrice,
      imageUrls: imageUrls ?? this.imageUrls,
      category: category ?? this.category,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      tags: tags ?? this.tags,
      specifications: specifications ?? this.specifications,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

