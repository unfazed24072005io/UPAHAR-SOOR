import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_models/models/app_config.dart';
import '../services/vendor_product_service.dart';
import 'vendor_product_card.dart';
import 'add_product_screen.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<VendorProductService>(context);

    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // App Bar
            SliverAppBar(
              backgroundColor: AppConfig.backgroundColor,
              elevation: 0,
              title: Column(
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.primaryColor,
                    ),
                  ),
                ],
              ),
              actions: [
                Container(
                  width: 45,
                  height: 45,
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
                const SizedBox(width: 16),
              ],
              pinned: true,
              floating: true,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: AppConfig.primaryColor,
                labelColor: AppConfig.primaryColor,
                unselectedLabelColor: AppConfig.textSecondary,
                tabs: const [
                  Tab(text: 'Dashboard'),
                  Tab(text: 'Products'),
                  Tab(text: 'Orders'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildDashboardTab(productService),
            _buildProductsTab(productService),
            _buildOrdersTab(productService),
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

  Widget _buildDashboardTab(VendorProductService productService) {
    return StreamBuilder<List<Product>>(
      stream: productService.getVendorProducts(),
      builder: (context, productsSnapshot) {
        return StreamBuilder<List<Order>>(
          stream: productService.getVendorOrders(),
          builder: (context, ordersSnapshot) {
            if (productsSnapshot.hasData && ordersSnapshot.hasData) {
              productService.updateAnalytics(
                productsSnapshot.data!,
                ordersSnapshot.data!,
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Stats Cards
                  _buildStatsCards(productService),
                  const SizedBox(height: 24),
                  
                  // Recent Orders
                  _buildRecentOrders(ordersSnapshot),
                  const SizedBox(height: 24),
                  
                  // Top Products
                  _buildTopProducts(productsSnapshot),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatsCards(VendorProductService productService) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Total Revenue', '₹${productService.totalRevenue.toStringAsFixed(0)}', Icons.attach_money, Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Total Orders', productService.totalOrders.toString(), Icons.shopping_cart, Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Active Products', productService.activeProducts.toString(), Icons.inventory_2, Colors.orange)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
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

  Widget _buildRecentOrders(AsyncSnapshot<List<Order>> snapshot) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConfig.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConfig.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (snapshot.connectionState == ConnectionState.waiting)
            const Center(child: CircularProgressIndicator()),
          if (snapshot.hasError)
            Center(child: Text('Error: ${snapshot.error}')),
          if (snapshot.hasData && snapshot.data!.isEmpty)
            const Center(child: Text('No orders yet')),
          if (snapshot.hasData && snapshot.data!.isNotEmpty)
            ...snapshot.data!.take(5).map((order) => _buildOrderItem(order)),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConfig.cardColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppConfig.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.shopping_bag, color: AppConfig.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.id.substring(0, 8)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppConfig.textPrimary,
                  ),
                ),
                Text(
                  '₹${order.totalAmount.toStringAsFixed(0)} • ${order.items.length} items',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConfig.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(order.status),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              order.status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return Colors.orange;
      case 'confirmed': return Colors.blue;
      case 'shipped': return Colors.purple;
      case 'delivered': return Colors.green;
      default: return Colors.grey;
    }
  }

  Widget _buildTopProducts(AsyncSnapshot<List<Product>> snapshot) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConfig.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConfig.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (snapshot.connectionState == ConnectionState.waiting)
            const Center(child: CircularProgressIndicator()),
          if (snapshot.hasError)
            Center(child: Text('Error: ${snapshot.error}')),
          if (snapshot.hasData && snapshot.data!.isEmpty)
            const Center(child: Text('No products yet')),
          if (snapshot.hasData && snapshot.data!.isNotEmpty)
            ...snapshot.data!.take(3).map((product) => _buildTopProductItem(product)),
        ],
      ),
    );
  }

  Widget _buildTopProductItem(Product product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(product.imageUrls.isNotEmpty 
                    ? product.imageUrls.first 
                    : 'https://via.placeholder.com/50'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppConfig.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '₹${product.displayPrice.toStringAsFixed(0)} • ${product.rating} ⭐',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConfig.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTab(VendorProductService productService) {
    return StreamBuilder<List<Product>>(
      stream: productService.getVendorProducts(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(24),
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
                    '${snapshot.hasData ? snapshot.data!.length : 0} items',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConfig.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildProductsList(snapshot, productService),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductsList(AsyncSnapshot<List<Product>> snapshot, VendorProductService productService) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No products yet',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Add your first product to get started',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final product = snapshot.data![index];
        return VendorProductCard(
          product: product,
          onEdit: () => _editProduct(context, product),
          onDelete: () => productService.deleteProduct(product.id),
        );
      },
    );
  }

  Widget _buildOrdersTab(VendorProductService productService) {
    return StreamBuilder<List<Order>>(
      stream: productService.getVendorOrders(),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConfig.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildOrdersList(snapshot, productService),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrdersList(AsyncSnapshot<List<Order>> snapshot, VendorProductService productService) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No orders yet'));
    }

    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        final order = snapshot.data![index];
        return _buildOrderCard(order, productService);
      },
    );
  }

  Widget _buildOrderCard(Order order, VendorProductService productService) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id.substring(0, 8)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '₹${order.grandTotal.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppConfig.primaryColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${order.items.length} items • ${order.orderDate.toString().substring(0, 10)}',
              style: TextStyle(color: AppConfig.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: order.status,
                    items: ['Pending', 'Confirmed', 'Shipped', 'Delivered']
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        productService.updateOrderStatus(order.id, value);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editProduct(BuildContext context, Product product) {
    // Navigate to edit product screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Product'),
        content: const Text('Edit product functionality coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
