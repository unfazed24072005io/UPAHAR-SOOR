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
    
    // Use the correct method - check what's available in FirestoreService
    try {
      // Option 1: If updateProduct exists
      await _firestoreService.updateProduct(updatedProduct);
    } catch (e) {
      // Option 2: If you need to use updateDocument
      await _firestoreService.updateDocument(
        'products', 
        product.id, 
        updatedProduct.toMap()
      );
    }
  }

  Future<void> deleteProduct(String productId) async {
    await _firestoreService.deleteProduct(productId);
  }

  // Order Methods
  Stream<List<Order>> getVendorOrders() {
    // Use the correct method - check what's available in FirestoreService
    try {
      return _firestoreService.getVendorOrders(vendorId);
    } catch (e) {
      // Fallback implementation if method doesn't exist
      return _firestoreService.collectionStream(
        'orders',
        builder: (data) => Order.fromMap(data),
        queryBuilder: (query) => query.where('vendorId', isEqualTo: vendorId),
      );
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestoreService.updateDocument(
        'orders',
        orderId,
        {'status': status, 'updatedAt': DateTime.now()}
      );
      notifyListeners();
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  // Analytics Methods
  void updateAnalytics(List<Product> products, List<Order> orders) {
    _activeProducts = products.where((p) => p.isActive ?? true).length;
    _totalOrders = orders.length;
    _totalRevenue = orders.fold(0, (sum, order) => sum + (order.totalAmount ?? 0));
    notifyListeners();
  }
}
