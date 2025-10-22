import 'package:flutter/material.dart';
import 'package:shared_models/models/product.dart';
import 'package:shared_models/models/app_config.dart';

class PaymentScreen extends StatelessWidget {
  final Product product;
  final double selectedPrice;
  final int quantity;

  const PaymentScreen({
    super.key,
    required this.product,
    required this.selectedPrice,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = selectedPrice * quantity;

    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppConfig.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            // Product Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConfig.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Product Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(product.imageUrls.isNotEmpty 
                            ? product.imageUrls.first 
                            : 'https://via.placeholder.com/60'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Qty: $quantity',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConfig.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Price
                  Text(
                    '₹${selectedPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Payment Methods
            Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppConfig.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            // Payment Options
            _buildPaymentOption('Credit/Debit Card', Icons.credit_card),
            const SizedBox(height: 12),
            _buildPaymentOption('UPI Payment', Icons.payment),
            const SizedBox(height: 12),
            _buildPaymentOption('Net Banking', Icons.account_balance),
            const SizedBox(height: 12),
            _buildPaymentOption('Cash on Delivery', Icons.local_shipping),
            
            const Spacer(),
            
            // Total Amount
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConfig.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.textPrimary,
                    ),
                  ),
                  Text(
                    '₹${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Pay Now Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppConfig.primaryColor, Colors.orange],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppConfig.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  // Handle payment processing
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Payment functionality coming soon...'),
                      backgroundColor: AppConfig.primaryColor,
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'PAY NOW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConfig.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConfig.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppConfig.primaryColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppConfig.textPrimary,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.radio_button_unchecked,
            color: AppConfig.primaryColor,
          ),
        ],
      ),
    );
  }
}
