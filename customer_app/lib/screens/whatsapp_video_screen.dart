import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_models/models/product.dart';
import 'package:shared_models/models/app_config.dart';
import 'payment_screen.dart';

class WhatsAppVideoScreen extends StatelessWidget {
  final Product product;
  final double selectedPrice;
  final int quantity;

  const WhatsAppVideoScreen({
    super.key,
    required this.product,
    required this.selectedPrice,
    required this.quantity,
  });

  Future<void> _launchWhatsApp() async {
    final phoneNumber = '919937191669'; // Your WhatsApp number
    final message = 'Hello! I would like to schedule a video call for ${product.name} (₹${selectedPrice.toStringAsFixed(2)})';
    final url = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
    
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  void _proceedToPayment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(
          product: product,
          selectedPrice: selectedPrice,
          quantity: quantity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Video Call Verification'),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppConfig.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.video_call,
                size: 60,
                color: AppConfig.primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            
            // Title
            Text(
              'Video Call Verification Required',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConfig.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // Description
            Text(
              'For pet products, we require a video call verification to ensure the well-being of the animal and your satisfaction.',
              style: TextStyle(
                fontSize: 16,
                color: AppConfig.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Steps
            _buildStep('1. Schedule WhatsApp Video Call', Icons.schedule),
            const SizedBox(height: 16),
            _buildStep('2. Verify Product Condition', Icons.verified),
            const SizedBox(height: 16),
            _buildStep('3. Proceed to Payment', Icons.payment),
            const SizedBox(height: 40),
            
            // WhatsApp Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: _launchWhatsApp,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.whatsapp, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      'SCHEDULE WHATSAPP CALL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Skip to Payment Button
            OutlinedButton(
              onPressed: () => _proceedToPayment(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                side: BorderSide(color: AppConfig.primaryColor),
              ),
              child: Text(
                'SKIP TO PAYMENT',
                style: TextStyle(
                  color: AppConfig.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConfig.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppConfig.primaryColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppConfig.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
