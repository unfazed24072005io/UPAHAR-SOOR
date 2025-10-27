import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    try {
      print('🟡 Starting to add product: ${product.name}');
      
      // Convert to Firestore data with proper timestamps
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
        'isActive': true, // CRITICAL: Make product visible
        'isFeatured': product.isFeatured ?? false,
        'tags': product.tags ?? [],
        'specifications': product.specifications ?? {},
        'createdAt': FieldValue.serverTimestamp(), // SERVER TIMESTAMP
        'updatedAt': FieldValue.serverTimestamp(), // SERVER TIMESTAMP
      };
      
      print('🟡 Firestore data to be saved: $firestoreData');
      
      // Add to Firestore
      await _productsRef.add(firestoreData);
      print('✅ Product added successfully to Firestore!');
      
      // Show success feedback
      _showSuccessMessage('Product "${product.name}" added successfully!');
      
    } catch (e) {
      print('❌ Error adding product to Firestore: $e');
      _showErrorMessage('Failed to add product: $e');
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
      _showSuccessMessage('Product deleted successfully!');
    } catch (e) {
      print('❌ Error deleting product: $e');
      _showErrorMessage('Failed to delete product: $e');
    }
  }

  // Order Methods
  Stream<List<Order>> getVendorOrders() {
    // TODO: Implement get vendor orders
    return Stream.value([]); // Temporary empty stream
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    // TODO: Implement update order status
    print('Update order $orderId to $status');
    notifyListeners();
  }

  // Analytics Methods
  void updateAnalytics(List<Product> products, List<Order> orders) {
    _activeProducts = products.where((p) => p.isActive ?? true).length;
    _totalOrders = orders.length;
    _totalRevenue = orders.fold(0, (sum, order) => sum + (order.totalAmount ?? 0));
    notifyListeners();
  }

  // Helper Methods
  CollectionReference get _productsRef => FirebaseFirestore.instance.collection('products');

  void _showSuccessMessage(String message) {
    // This would typically use a ScaffoldMessenger in the UI
    print('✅ $message');
  }

  void _showErrorMessage(String message) {
    // This would typically use a ScaffoldMessenger in the UI  
    print('❌ $message');
  }
}
