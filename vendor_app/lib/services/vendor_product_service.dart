import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_models/models/product.dart';
// REMOVE this line: import 'package:shared_models/models/order.dart';
import 'package:shared_models/services/firestore_service.dart';

class VendorProductService with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final String vendorId = 'vendor1';
  final String vendorName = 'My Store';
  
  // Remove Order-related code temporarily
  // List<Order> _orders = [];
  double _totalRevenue = 0;
  int _totalOrders = 0;
  int _activeProducts = 0;

  // Getters
  // List<Order> get orders => _orders;
  double get totalRevenue => _totalRevenue;
  int get totalOrders => _totalOrders;
  int get activeProducts => _activeProducts;

  // Product Methods
  Stream<List<Product>> getVendorProducts() {
    return _firestoreService.getVendorProducts(vendorId);
  }

  Future<void> addProduct(Product product) async {
    try {
      print('🟡 Starting to add product: ${product.name}');
      
      final firestoreData = {
        'name': product.name,
        'description': product.description,
        'basePrice': product.basePrice,
        'customerPrice': product.customerPrice ?? product.basePrice,
        'imageUrls': product.imageUrls,
        'category': product.category,
        'vendorId': vendorId,
        'vendorName': vendorName,
        'rating': product.rating,
        'reviewCount': product.reviewCount,
        'stockQuantity': product.stockQuantity,
        'isActive': true,
        'isFeatured': product.isFeatured ?? false,
        'tags': product.tags ?? [],
        'specifications': product.specifications ?? {},
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      print('🟡 Firestore data to be saved: $firestoreData');
      
      await _productsRef.add(firestoreData);
      print('✅ Product added successfully to Firestore!');
      
    } catch (e) {
      print('❌ Error adding product to Firestore: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _productsRef.doc(product.id).update({
        'name': product.name,
        'description': product.description,
        'basePrice': product.basePrice,
        'customerPrice': product.customerPrice,
        'imageUrls': product.imageUrls,
        'category': product.category,
        'stockQuantity': product.stockQuantity,
        'isFeatured': product.isFeatured,
        'tags': product.tags,
        'specifications': product.specifications,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      print('✅ Product updated successfully!');
    } catch (e) {
      print('❌ Error updating product: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestoreService.deleteProduct(productId);
      print('✅ Product deleted successfully!');
    } catch (e) {
      print('❌ Error deleting product: $e');
    }
  }

  // Remove Order methods temporarily
  /*
  Stream<List<Order>> getVendorOrders() {
    return Stream.value([]);
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    print('Update order $orderId to $status');
    notifyListeners();
  }

  void updateAnalytics(List<Product> products, List<Order> orders) {
    _activeProducts = products.where((p) => p.isActive ?? true).length;
    _totalOrders = orders.length;
    _totalRevenue = orders.fold(0, (sum, order) => sum + (order.totalAmount ?? 0));
    notifyListeners();
  }
  */

  // Simple analytics without orders
  void updateAnalytics(List<Product> products) {
    _activeProducts = products.where((p) => p.isActive ?? true).length;
    // _totalOrders and _totalRevenue will be 0 for now
    notifyListeners();
  }

  // Helper Methods
  CollectionReference get _productsRef => FirebaseFirestore.instance.collection('products');
}
