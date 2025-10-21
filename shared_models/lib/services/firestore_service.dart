import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  CollectionReference get _productsRef => _firestore.collection('products');
  
  // Get all active products for customers
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
    if (product.id.isEmpty) {
      // Auto-generate ID
      await _productsRef.add(product.toMap());
    } else {
      // Use provided ID
      await _productsRef.doc(product.id).set(product.toMap());
    }
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
}
