import 'package:flutter/material.dart';
import 'package:shared_models/models/product.dart';

class ProductService with ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;
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

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
