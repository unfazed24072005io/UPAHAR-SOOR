import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  CollectionReference get _productsRef => _firestore.collection('products');
  
  // Get all active products for customers
  Stream<List<Product>> getProducts() {
    return _productsRef
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
  
  // Get products by vendor
  Stream<List<Product>> getVendorProducts(String vendorId) {
    return _productsRef
        .where('vendorId', isEqualTo: vendorId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }
  
  // Add new product
  Future<void> addProduct(Product product) async {
    await _productsRef.add(product.toMap());
  }
  
  // Update customer price
  Future<void> updateCustomerPrice(String productId, double customerPrice) async {
    await _productsRef.doc(productId).update({
      'customerPrice': customerPrice,
    });
  }
  
  // Delete product (soft delete)
  Future<void> deleteProduct(String productId) async {
    await _productsRef.doc(productId).update({
      'isActive': false,
    });
  }
}