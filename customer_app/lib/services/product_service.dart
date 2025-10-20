import 'package:flutter/material.dart';
import 'package:shared_models/models/product.dart';

class ProductService with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Wireless Headphones',
      description: 'Premium noise-cancelling wireless headphones with superior sound quality.',
      basePrice: 199.99,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
      category: 'Electronics',
      vendorId: 'vendor1',
      vendorName: 'TechGadgets',
      rating: 4.5,
      reviewCount: 128,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Product(
      id: '2',
      name: 'Smart Watch',
      description: 'Feature-rich smartwatch with health monitoring and notifications.',
      basePrice: 299.99,
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
      category: 'Electronics',
      vendorId: 'vendor1',
      vendorName: 'TechGadgets',
      rating: 4.2,
      reviewCount: 89,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Product(
      id: '3',
      name: 'Running Shoes',
      description: 'Comfortable running shoes with advanced cushioning technology.',
      basePrice: 129.99,
      imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500',
      category: 'Sports',
      vendorId: 'vendor2',
      vendorName: 'SportZone',
      rating: 4.7,
      reviewCount: 256,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<Product> get products => _products;

  void updateCustomerPrice(String productId, double customerPrice) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index] = _products[index].copyWith(customerPrice: customerPrice);
      notifyListeners();
    }
  }

  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  List<String> get categories {
    return _products.map((product) => product.category).toSet().toList();
  }
}