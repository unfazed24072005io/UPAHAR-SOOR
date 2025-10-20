import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_models/models/app_config.dart';
import '../services/vendor_product_service.dart';
import 'add_product_screen.dart';
import 'vendor_product_card.dart';

class VendorHomeScreen extends StatelessWidget {
  const VendorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<VendorProductService>(context);

    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            const SizedBox(height: 20),
            // Stats Cards
            _buildStatsCards(productService),
            const SizedBox(height: 20),
            // Products Section
            _buildProductsSection(context, productService),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          );
        },
        backgroundColor: AppConfig.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vendor Dashboard',
                style: TextStyle(
                  fontSize: 16,
                  color: AppConfig.textSecondary,
                ),
              ),
              Text(
                'Upahar Store',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppConfig.primaryColor,
                ),
              ),
            ],
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppConfig.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.store,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(VendorProductService productService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Products', productService.totalProducts.toString(), Icons.inventory_2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Custom Prices', productService.productsWithCustomPrice.toString(), Icons.price_change),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Revenue', '\$${productService.totalRevenue.toStringAsFixed(0)}', Icons.attach_money),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConfig.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppConfig.primaryColor,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConfig.textPrimary,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppConfig.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection(BuildContext context, VendorProductService productService) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.textPrimary,
                  ),
                ),
                Text(
                  '${productService.products.length} items',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConfig.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: productService.products.length,
                itemBuilder: (context, index) {
                  final product = productService.products[index];
                  return VendorProductCard(product: product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}