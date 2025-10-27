import 'package:flutter/material.dart';
import 'package:shared_models/models/product.dart';
import 'package:shared_models/services/firestore_service.dart';

class ProductService with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final List<Product> _products = [];
  final List<Product> _cartItems = [];
  final List<String> _wishlist = [];

  List<Product> get products => _products;
  List<Product> get cartItems => _cartItems;
  List<String> get wishlist => _wishlist;
  
  double get cartTotal => _cartItems.fold(0, (sum, item) => sum + item.displayPrice);
  int get cartItemCount => _cartItems.length;

  // Stream for real-time products from Firestore
  Stream<List<Product>> getProductsStream() {
    print('🟡 Getting products from Firestore...');
    return _firestoreService.getProducts();
  }

  // Initialize - COMMENT OUT MOCK DATA TO FORCE FIRESTORE
  ProductService() {
    print('🟡 ProductService initialized');
    // _initializeMockData(); // ← COMMENT THIS OUT TO TEST FIRESTORE
    
    // Listen to Firestore stream
    getProductsStream().listen((firestoreProducts) {
      _updateProductsFromFirestore(firestoreProducts);
    }, onError: (error) {
      print('❌ Firestore stream error: $error');
      // Fallback to mock data if Firestore fails
      _initializeMockData();
    });
  }

  void _initializeMockData() {
    print('🟡 Loading mock data...');
    _products.addAll([
      Product(
        id: '1',
        name: 'Wireless Headphones',
        description: 'Premium noise-cancelling headphones with superior sound quality',
        basePrice: 199.99,
        customerPrice: 199.99,
        imageUrls: ['https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500'],
        category: 'Others',
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
        category: 'Others',
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
        category: 'Others',
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
    ]);
    print('✅ Mock data loaded: ${_products.length} products');
    notifyListeners();
  }

  void _updateProductsFromFirestore(List<Product> firestoreProducts) {
    if (firestoreProducts.isNotEmpty) {
      print('✅ Firestore data received: ${firestoreProducts.length} products');
      _products.clear();
      _products.addAll(firestoreProducts);
      notifyListeners();
    } else {
      print('🟡 No products from Firestore, using mock data');
      _initializeMockData();
    }
  }

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
    
    // Also update in Firestore
    await _firestoreService.updateCustomerPrice(productId, customerPrice);
  }
}
