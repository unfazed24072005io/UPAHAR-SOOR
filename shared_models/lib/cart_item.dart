import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  final Map<String, dynamic>? selectedVariants;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedVariants,
  });

  double get totalPrice => product.displayPrice * quantity;

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'selectedVariants': selectedVariants,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(map['product']['id'] ?? '', map['product']),
      quantity: map['quantity'] ?? 1,
      selectedVariants: map['selectedVariants'],
    );
  }
}
