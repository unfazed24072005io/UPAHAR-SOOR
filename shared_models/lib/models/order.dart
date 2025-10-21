import 'cart_item.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final double shippingFee;
  final double taxAmount;
  final String status;
  final String paymentMethod;
  final String shippingAddress;
  final DateTime orderDate;
  final DateTime? deliveryDate;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.shippingFee = 0,
    this.taxAmount = 0,
    required this.status,
    required this.paymentMethod,
    required this.shippingAddress,
    required this.orderDate,
    this.deliveryDate,
  });

  double get grandTotal => totalAmount + shippingFee + taxAmount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'shippingFee': shippingFee,
      'taxAmount': taxAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'shippingAddress': shippingAddress,
      'orderDate': orderDate.millisecondsSinceEpoch,
      'deliveryDate': deliveryDate?.millisecondsSinceEpoch,
    };
  }

  factory Order.fromMap(String id, Map<String, dynamic> map) {
    return Order(
      id: id,
      userId: map['userId'] ?? '',
      items: List<Map<String, dynamic>>.from(map['items'] ?? [])
          .map((itemMap) => CartItem.fromMap(itemMap))
          .toList(),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      shippingFee: (map['shippingFee'] ?? 0).toDouble(),
      taxAmount: (map['taxAmount'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      paymentMethod: map['paymentMethod'] ?? '',
      shippingAddress: map['shippingAddress'] ?? '',
      orderDate: DateTime.fromMillisecondsSinceEpoch(map['orderDate'] ?? 0),
      deliveryDate: map['deliveryDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['deliveryDate'])
          : null,
    );
  }
}
