import 'package:flutter/material.dart';
import 'package:shared_models/models/product.dart';
import 'package:shared_models/services/firestore_service.dart';

class ProductService with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final List<Product> _cartItems = [];
  final List<String> _wishlist = [];

  // Getters
  List<Product> get cartItems => _cartItems;
  List<String> get wishlist => _wishlist;
  
  double get cartTotal => _cartItems.fold(0, (sum, item) => sum + item.displayPrice);
  int get cartItemCount => _cartItems.length;

  // Product Stream Methods
  Stream<List<Product>> getProducts() {
    return _firestoreService.getProducts();
  }

  Stream<List<Product>> getFeaturedProducts() {
    return _firestoreService.getFeaturedProducts();
  }

  // Cart Methods
  void addToCart(Product product, {int quantity = 1}) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Wishlist Methods
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

  // Price Methods
  Future<void> updateCustomerPrice(String productId, double customerPrice) async {
    await _firestoreService.updateCustomerPrice(productId, customerPrice);
  }
}
