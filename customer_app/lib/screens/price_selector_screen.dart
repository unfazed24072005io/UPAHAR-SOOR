import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_models/models/product.dart';
import 'package:shared_models/models/app_config.dart';
import '../services/product_service.dart';

class PriceSelectorScreen extends StatefulWidget {
  final Product product;

  const PriceSelectorScreen({super.key, required this.product});

  @override
  State<PriceSelectorScreen> createState() => _PriceSelectorScreenState();
}

class _PriceSelectorScreenState extends State<PriceSelectorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _selectedPrice = 0.0;
  double _priceMultiplier = 1.0;
  int _selectedQuantity = 1;
  int _selectedImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedPrice = widget.product.customerPrice ?? widget.product.basePrice;
    _priceMultiplier = _selectedPrice / widget.product.basePrice;
  }

  @override
  Widget build(BuildContext context) {
    final minPrice = widget.product.basePrice * AppConfig.minPriceMultiplier;
    final maxPrice = widget.product.basePrice * AppConfig.maxPriceMultiplier;

    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: AppConfig.backgroundColor,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(widget.product.name),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: _shareProduct,
                  ),
                  Consumer<ProductService>(
                    builder: (context, productService, child) {
                      return IconButton(
                        icon: Icon(
                          productService.isInWishlist(widget.product.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: productService.isInWishlist(widget.product.id)
                              ? Colors.red
                              : null,
                        ),
                        onPressed: () {
                          if (productService.isInWishlist(widget.product.id)) {
                            productService.removeFromWishlist(widget.product.id);
                          } else {
                            productService.addToWishlist(widget.product.id);
                          }
                        },
                      );
                    },
                  ),
                ],
                pinned: true,
                expandedHeight: 300.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildImageGallery(),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Details'),
                    Tab(text: 'Set Price'),
                    Tab(text: 'Reviews'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildDetailsTab(),
              _buildPriceTab(minPrice, maxPrice),
              _buildReviewsTab(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildImageGallery() {
    return Stack(
      children: [
        PageView.builder(
          itemCount: widget.product.imageUrls.length,
          onPageChanged: (index) {
            setState(() {
              _selectedImageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Image.network(
              widget.product.imageUrls[index],
              fit: BoxFit.cover,
              width: double.infinity,
            );
          },
        ),
        if (widget.product.imageUrls.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.product.imageUrls.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedImageIndex == index
                        ? AppConfig.primaryColor
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              RatingBar.builder(
                initialRating: widget.product.rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20,
                itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: AppConfig.primaryColor,
                ),
                onRatingUpdate: (rating) {},
                ignoreGestures: true,
              ),
              const SizedBox(width: 8),
              Text(
                '${widget.product.rating} (${widget.product.reviewCount} reviews)',
                style: TextStyle(
                  color: AppConfig.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.product.description,
            style: TextStyle(
              fontSize: 16,
              color: AppConfig.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          if (widget.product.specifications.isNotEmpty) ...[
            const Text(
              'Specifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.product.specifications.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(
                      '${entry.key}: ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(entry.value.toString()),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceTab(double minPrice, double maxPrice) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Base Price Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Base Price',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppConfig.textSecondary,
                    ),
                  ),
                  Text(
                    '₹${widget.product.basePrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

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

          // Selected Price Display
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppConfig.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppConfig.primaryColor),
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Your Selected Price',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppConfig.textSecondary,
                    ),
                  ),
                  Text(
                    '₹${_selectedPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppConfig.primaryColor,
                    ),
                  ),
                  Text(
                    '${((_priceMultiplier - 1) * 100).toStringAsFixed(0)}% ${_priceMultiplier > 1 ? 'above' : 'below'} base price',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConfig.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Price Range Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Min: ₹${minPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConfig.textSecondary,
                ),
              ),
              Text(
                'Max: ₹${maxPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConfig.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Quantity Selector
          Text(
            'Quantity:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConfig.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                onPressed: _selectedQuantity > 1
                    ? () => setState(() => _selectedQuantity--)
                    : null,
                icon: const Icon(Icons.remove),
              ),
              Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: AppConfig.primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _selectedQuantity.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _selectedQuantity < widget.product.stockQuantity
                    ? () => setState(() => _selectedQuantity++)
                    : null,
                icon: const Icon(Icons.add),
              ),
              const Spacer(),
              Text(
                'Stock: ${widget.product.stockQuantity}',
                style: TextStyle(
                  color: AppConfig.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Customer Reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text('Reviews functionality coming soon...'),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Price Display
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConfig.textSecondary,
                  ),
                ),
                Text(
                  '₹${(_selectedPrice * _selectedQuantity).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            children: [
              // Set Price Button
              OutlinedButton(
                onPressed: _setPrice,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  side: BorderSide(color: AppConfig.primaryColor),
                ),
                child: Text(
                  'SET PRICE',
                  style: TextStyle(
                    color: AppConfig.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Add to Cart Button
              ElevatedButton(
                onPressed: _addToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'ADD TO CART',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _setPrice() {
    final productService = Provider.of<ProductService>(context, listen: false);
    productService.updateCustomerPrice(widget.product.id, _selectedPrice);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Price set to ₹${_selectedPrice.toStringAsFixed(2)}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _addToCart() {
    final productService = Provider.of<ProductService>(context, listen: false);
    productService.addToCart(widget.product, quantity: _selectedQuantity);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart'),
        backgroundColor: Colors.green,
      ),
    );
    
    Navigator.pop(context);
  }

  void _shareProduct() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon...')),
    );
  }
}
