import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  CollectionReference get _productsRef => _firestore.collection('products');
  CollectionReference get _usersRef => _firestore.collection('users');
  CollectionReference get _ordersRef => _firestore.collection('orders');
  CollectionReference get _categoriesRef => _firestore.collection('categories');

  // PRODUCT METHODS
  Stream<List<Product>> getProducts() {
    return _productsRef
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Product>> getFeaturedProducts() {
    return _productsRef
        .where('isActive', isEqualTo: true)
        .where('isFeatured', isEqualTo: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Product>> getProductsByCategory(String category) {
    return _productsRef
        .where('isActive', isEqualTo: true)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Product>> searchProducts(String query) {
    return _productsRef
        .where('isActive', isEqualTo: true)
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Product>> getVendorProducts(String vendorId) {
    return _productsRef
        .where('vendorId', isEqualTo: vendorId)
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addProduct(Product product) async {
    await _productsRef.add(product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    await _productsRef.doc(product.id).update(product.toMap());
  }

  Future<void> updateCustomerPrice(String productId, double customerPrice) async {
    await _productsRef.doc(productId).update({
      'customerPrice': customerPrice,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> deleteProduct(String productId) async {
    await _productsRef.doc(productId).update({
      'isActive': false,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // USER METHODS
  Future<void> addUser(User user) async {
    await _usersRef.doc(user.id).set(user.toMap());
  }

  Stream<User?> getUser(String userId) {
    return _usersRef.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return User.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    });
  }

  Future<void> updateUserWishlist(String userId, List<String> wishlist) async {
    await _usersRef.doc(userId).update({'wishlist': wishlist});
  }

  // ORDER METHODS
  Future<void> createOrder(Order order) async {
    await _ordersRef.doc(order.id).set(order.toMap());
  }

  Stream<List<Order>> getUserOrders(String userId) {
    return _ordersRef
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Order.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Stream<List<Order>> getVendorOrders(String vendorId) {
    return _ordersRef
        .where('vendorId', isEqualTo: vendorId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Order.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  // CATEGORY METHODS
  Stream<List<String>> getCategories() {
    return _categoriesRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => doc['name'] as String).toList());
  }
}
