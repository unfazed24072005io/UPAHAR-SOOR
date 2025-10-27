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
            .map((doc) {
              print('🟢 Firestore Product Data: ${doc.data()}');
              return Product.fromMap(doc.id, doc.data() as Map<String, dynamic>);
            })
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
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addProduct(Product product) async {
    try {
      print('🟡 Starting to add product: ${product.name}');
      
      final productData = {
        'name': product.name,
        'description': product.description,
        'basePrice': product.basePrice,
        'customerPrice': product.customerPrice ?? product.basePrice,
        'imageUrls': product.imageUrls,
        'category': product.category,
        'vendorId': product.vendorId,
        'vendorName': product.vendorName,
        'rating': product.rating,
        'reviewCount': product.reviewCount,
        'stockQuantity': product.stockQuantity,
        'isActive': true,
        'isFeatured': product.isFeatured,
        'tags': product.tags,
        'specifications': product.specifications,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      print('🟡 Firestore data: $productData');
      
      await _productsRef.add(productData);
      print('✅ Product added to Firestore!');
      
    } catch (e) {
      print('❌ Firestore error: $e');
      rethrow;
    }
  }

  Future<void> updateCustomerPrice(String productId, double customerPrice) async {
    await _productsRef.doc(productId).update({
      'customerPrice': customerPrice,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteProduct(String productId) async {
    await _productsRef.doc(productId).update({
      'isActive': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
