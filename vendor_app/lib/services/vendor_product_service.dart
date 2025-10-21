import 'package:flutter/material.dart';
import 'package:shared_models/models/product.dart';
import 'package:shared_models/models/order.dart';
import 'package:shared_models/services/firestore_service.dart';

class VendorProductService with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final String vendorId = 'vendor1';
  final String vendorName = 'My Store';
  
  List<Order> _orders = [];
  double _totalRevenue = 0;
  int _totalOrders = 0;
  int _activeProducts = 0;

  // Getters
  List<Order> get orders => _orders;
  double get totalRevenue => _totalRevenue;
  int get totalOrders => _totalOrders;
  int get activeProducts => _activeProducts;

  // Product Methods
  Stream<List<Product>> getVendorProducts() {
    return _firestoreService.getVendorProducts(vendorId);
  }

  Future<void> addProduct(Product product) async {
    final newProduct = Product(
      id: '',
      name: product.name,
      description: product.description,
      basePrice: product.basePrice,
      customerPrice: product.basePrice,
      imageUrls: product.imageUrls,
      category: product.category,
      vendorId: vendorId,
      vendorName: vendorName,
      stockQuantity: product.stockQuantity,
      isFeatured: product.isFeatured,
      tags: product.tags,
      specifications: product.specifications,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await _firestoreService.addProduct(newProduct);
  }

  Future<void> updateProduct(Product product) async {
    final updatedProduct = product.copyWith(
      updatedAt: DateTime.now(),
    );
    await _firestoreService.updateProduct(updatedProduct);
  }

  Future<void> deleteProduct(String productId) async {
    await _firestoreService.deleteProduct(productId);
  }

  // Order Methods
  Stream<List<Order>> getVendorOrders() {
    return _firestoreService.getVendorOrders(vendorId);
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    // Implementation for order status update
  }

  // Analytics Methods
  void updateAnalytics(List<Product> products, List<Order> orders) {
    _activeProducts = products.where((p) => p.isActive).length;
    _totalOrders = orders.length;
    _totalRevenue = orders.fold(0, (sum, order) => sum + order.totalAmount);
    notifyListeners();
  }
}
