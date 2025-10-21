import 'package:flutter/material.dart';
import 'package:shared_models/models/product.dart';

class ProductService with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Wireless Headphones',
      description: 'Premium noise-cancelling headphones with superior sound quality',
      basePrice: 199.99,
      customerPrice: 199.99,
      imageUrls: ['https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500'],
      category: 'Electronics',
      vendorId: 'vendor1',
      vendorName: 'TechGadgets',
      rating: 4.5,
      reviewCount: 128,
      stockQuantity: 50,
      isFeatured: true,
      tags: ['wireless', 'premium'],
      specifications: {
        'Color': 'Black',
        'Battery': '30 hours',
        'Connectivity': 'Bluetooth 5.0'
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Product(
      id: '2',
      name: 'Smart Watch',
      description: 'Feature-rich smartwatch with health monitoring',
      basePrice: 299.99,
      customerPrice: 299.99,
      imageUrls: ['https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500'],
      category: 'Electronics',
      vendorId: 'vendor1',
      vendorName: 'TechGadgets',
      rating: 4.2,
      reviewCount: 89,
      stockQuantity: 30,
      isFeatured: true,
      tags: ['smartwatch', 'fitness'],
      specifications: {
        'Display': '1.7" AMOLED',
        'Battery': '7 days',
        'Water Resistance': '50m'
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    Product(
      id: '3',
      name: 'Running Shoes',
      description: 'Comfortable running shoes with advanced cushioning',
      basePrice: 129.99,
      customerPrice: 129.99,
      imageUrls: ['https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500'],
      category: 'Sports',
      vendorId: 'vendor2',
      vendorName: 'SportZone',
      rating: 4.7,
      reviewCount: 256,
      stockQuantity: 100,
      isFeatured: false,
      tags: ['running', 'sports'],
      specifications: {
        'Size': 'US 7-12',
        'Material': 'Mesh & Rubber',
        'Weight': '280g'
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  final List<Product> _cartItems = [];
  final List<String> _wishlist = [];

  List<Product> get products => _products;
  List<Product> get cartItems => _cartItems;
  List<String> get wishlist => _wishlist;
  
  double get cartTotal => _cartItems.fold(0, (sum, item) => sum + item.displayPrice);
  int get cartItemCount => _cartItems.length;

  void addToCart(Product product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void addToWishlist(String productId) {
    if (!_wishlist.contains(productId)) {
      _wishlist.add(productId);
      notifyListeners();
    }
  }

  void removeFromWishlist(String productId) {
    _wishlist.remove(productId);
    notifyListeners();
  }

  bool isInWishlist(String productId) => _wishlist.contains(productId);

  Future<void> updateCustomerPrice(String productId, double customerPrice) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index] = _products[index].copyWith(customerPrice: customerPrice);
      notifyListeners();
    }
  }
}
