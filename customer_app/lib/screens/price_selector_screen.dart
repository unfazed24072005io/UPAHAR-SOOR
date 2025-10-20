import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_models/models/product.dart';
import 'package:shared_models/models/app_config.dart';
import '../services/product_service.dart';

class PriceSelectorScreen extends StatefulWidget {
  final Product product;

  const PriceSelectorScreen({super.key, required this.product});

  @override
  State<PriceSelectorScreen> createState() => _PriceSelectorScreenState();
}

class _PriceSelectorScreenState extends State<PriceSelectorScreen> {
  double _selectedPrice = 0.0;
  double _priceMultiplier = 1.0;

  @override
  void initState() {
    super.initState();
    _selectedPrice = widget.product.customerPrice ?? widget.product.basePrice;
    _priceMultiplier = _selectedPrice / widget.product.basePrice;
  }

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    final minPrice = widget.product.basePrice * AppConfig.minPriceMultiplier;
    final maxPrice = widget.product.basePrice * AppConfig.maxPriceMultiplier;

    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: Text('Set Your Price'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConfig.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(widget.product.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.product.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConfig.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Base Price
            Center(
              child: Text(
                'Base Price: \$${widget.product.basePrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  color: AppConfig.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Price Slider
            Text(
              'Set Your Price:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConfig.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Slider(
              value: _priceMultiplier,
              min: AppConfig.minPriceMultiplier,
              max: AppConfig.maxPriceMultiplier,
              divisions: ((AppConfig.maxPriceMultiplier - AppConfig.minPriceMultiplier) / AppConfig.priceStep).round(),
              onChanged: (value) {
                setState(() {
                  _priceMultiplier = value;
                  _selectedPrice = widget.product.basePrice * value;
                });
              },
              activeColor: AppConfig.primaryColor,
              inactiveColor: AppConfig.primaryColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            // Price Display
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConfig.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppConfig.primaryColor),
              ),
              child: Center(
                child: Text(
                  '\$${_selectedPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Price Range Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Min: \$${minPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConfig.textSecondary,
                  ),
                ),
                Text(
                  'Max: \$${maxPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConfig.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Save Button
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
                  productService.updateCustomerPrice(widget.product.id, _selectedPrice);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Price set to \$${_selectedPrice.toStringAsFixed(2)}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'CONFIRM PRICE',
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