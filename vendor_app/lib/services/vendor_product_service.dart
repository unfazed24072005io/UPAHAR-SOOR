import 'package:flutter/material.dart';
import 'package:shared_models/models/product.dart';

class VendorProductService with ChangeNotifier {
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
  ];

  List<Product> get products => _products;

  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(String productId, Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  double get totalRevenue {
    return _products.fold(0, (sum, product) {
      final price = product.customerPrice ?? product.basePrice;
      return sum + price;
    });
  }

  int get totalProducts => _products.length;

  int get productsWithCustomPrice {
    return _products.where((p) => p.customerPrice != null).length;
  }
}