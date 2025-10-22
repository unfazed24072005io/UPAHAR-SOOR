import 'package:flutter/material.dart';
import 'package:shared_models/models/product.dart';
import 'package:shared_models/models/app_config.dart';
import 'home_screen.dart';

class PaymentScreen extends StatefulWidget {
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
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'Razorpay Card';
  final double _shippingFee = 50.0;
  final double _taxAmount = 0.0;

  void _processPayment() {
    final totalAmount = (widget.selectedPrice * widget.quantity) + _shippingFee + _taxAmount;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Successful! ₹${totalAmount.toStringAsFixed(2)} paid via $_selectedPaymentMethod'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
    
    // Navigate to order confirmation
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OrderConfirmationScreen(
          product: widget.product,
          totalAmount: totalAmount,
          paymentMethod: _selectedPaymentMethod,
        )),
        (route) => false,
      );
    });
  }

  void _showPaymentMethodInfo(String method) {
    String info = '';
    switch (method) {
      case 'Razorpay Card':
        info = 'Pay securely with your Credit/Debit card';
        break;
      case 'Razorpay UPI':
        info = 'Instant payment using UPI apps';
        break;
      case 'Razorpay Net Banking':
        info = 'Transfer directly from your bank';
        break;
      case 'Cash on Delivery':
        info = 'Pay when your order is delivered';
        break;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(info),
        backgroundColor: AppConfig.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = widget.selectedPrice * widget.quantity;
    final totalAmount = subtotal + _shippingFee + _taxAmount;

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
                        image: NetworkImage(widget.product.imageUrls.isNotEmpty 
                            ? widget.product.imageUrls.first 
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
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Qty: ${widget.quantity}',
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
                    '₹${widget.selectedPrice.toStringAsFixed(2)}',
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
            _buildPaymentOption('Razorpay Card', Icons.credit_card, _selectedPaymentMethod == 'Razorpay Card'),
            const SizedBox(height: 12),
            _buildPaymentOption('Razorpay UPI', Icons.payment, _selectedPaymentMethod == 'Razorpay UPI'),
            const SizedBox(height: 12),
            _buildPaymentOption('Razorpay Net Banking', Icons.account_balance, _selectedPaymentMethod == 'Razorpay Net Banking'),
            const SizedBox(height: 12),
            _buildPaymentOption('Cash on Delivery', Icons.local_shipping, _selectedPaymentMethod == 'Cash on Delivery'),
            
            const Spacer(),
            
            // Order Breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConfig.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildAmountRow('Subtotal', '₹${subtotal.toStringAsFixed(2)}'),
                  _buildAmountRow('Shipping', '₹${_shippingFee.toStringAsFixed(2)}'),
                  _buildAmountRow('Tax', '₹${_taxAmount.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  Container(
                    height: 1,
                    color: AppConfig.primaryColor.withOpacity(0.3),
                  ),
                  const SizedBox(height: 8),
                  _buildAmountRow(
                    'Total Amount',
                    '₹${totalAmount.toStringAsFixed(2)}',
                    isTotal: true,
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
                onPressed: _processPayment,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'PAY ₹${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
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

  Widget _buildPaymentOption(String title, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = title;
        });
        _showPaymentMethodInfo(title);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConfig.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppConfig.primaryColor : AppConfig.primaryColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppConfig.primaryColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppConfig.textPrimary,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: AppConfig.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: AppConfig.textPrimary,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: isTotal ? AppConfig.primaryColor : AppConfig.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// Order Confirmation Screen
class OrderConfirmationScreen extends StatelessWidget {
  final Product product;
  final double totalAmount;
  final String paymentMethod;

  const OrderConfirmationScreen({
    super.key,
    required this.product,
    required this.totalAmount,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 60,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 32),
            
            // Success Message
            Text(
              'Order Confirmed!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppConfig.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              'Thank you for your purchase',
              style: TextStyle(
                fontSize: 16,
                color: AppConfig.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            
            // Order Details
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConfig.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '₹${totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Paid via: $paymentMethod',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConfig.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Continue Shopping Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: AppConfig.primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainNavigationScreen()),
                    (route) => false,
                  );
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'CONTINUE SHOPPING',
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
}
