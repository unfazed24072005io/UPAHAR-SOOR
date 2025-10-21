import 'package:flutter/material.dart';
import 'package:shared_models/models/product.dart';
import 'package:shared_models/models/user.dart';
import 'package:shared_models/models/order.dart';
import 'package:shared_models/models/cart_item.dart';
import 'package:shared_models/services/firestore_service.dart';

class ProductService with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final List<CartItem> _cartItems = [];
  final List<String> _wishlist = [];
  User? _currentUser;

  // Getters
  List<CartItem> get cartItems => _cartItems;
  List<String> get wishlist => _wishlist;
  User? get currentUser => _currentUser;
  
  double get cartTotal => _cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  int get cartItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  // Product Methods
  Stream<List<Product>> getProducts() => _firestoreService.getProducts();
  Stream<List<Product>> getFeaturedProducts() => _firestoreService.getFeaturedProducts();
  Stream<List<Product>> getProductsByCategory(String category) => _firestoreService.getProductsByCategory(category);
  Stream<List<Product>> searchProducts(String query) => _firestoreService.searchProducts(query);

  // Cart Methods
  void addToCart(Product product, {int quantity = 1, Map<String, dynamic>? variants}) {
    final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItem(
        product: product,
        quantity: quantity,
        selectedVariants: variants,
      ));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateCartQuantity(String productId, int quantity) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = quantity;
      }
      notifyListeners();
    }
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

  // User Methods
  void setUser(User user) {
    _currentUser = user;
    _wishlist.clear();
    _wishlist.addAll(user.wishlist);
    notifyListeners();
  }

  // Order Methods
  Future<void> createOrder(Order order) async {
    await _firestoreService.createOrder(order);
    clearCart();
  }

  Stream<List<Order>> getUserOrders() {
    if (_currentUser == null) return Stream.value([]);
    return _firestoreService.getUserOrders(_currentUser!.id);
  }

  // Price Methods
  Future<void> updateCustomerPrice(String productId, double customerPrice) async {
    await _firestoreService.updateCustomerPrice(productId, customerPrice);
  }
}
