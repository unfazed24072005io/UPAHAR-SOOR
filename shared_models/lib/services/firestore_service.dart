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
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addProduct(Product product) async {
    try {
      print('🟡 Starting to add product: ${product.name}');
      
      // Convert to map and ensure field names match Firestore
      final productData = product.toMap();
      
      // Ensure field names match your Firestore document structure
      final firestoreData = {
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
        'isActive': product.isActive,
        'isFeatured': product.isFeatured,
        'tags': product.tags,
        'specifications': product.specifications,
        'createdAt': FieldValue.serverTimestamp(), // Use server timestamp
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      print('🟡 Firestore data to be saved: $firestoreData');
      
      if (product.id.isEmpty) {
        // Auto-generate ID
        final docRef = await _productsRef.add(firestoreData);
        print('✅ Product added with ID: ${docRef.id}');
      } else {
        // Use provided ID
        await _productsRef.doc(product.id).set(firestoreData);
        print('✅ Product added with provided ID: ${product.id}');
      }
      
      print('✅ Product added successfully!');
    } catch (e) {
      print('❌ Error adding product: $e');
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
