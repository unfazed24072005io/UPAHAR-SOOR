import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_models/models/product.dart';
import 'package:shared_models/models/app_config.dart';
import '../services/vendor_product_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _selectedCategory = 'Electronics';

  final List<String> _categories = [
    'Electronics',
    'Fashion',
    'Home',
    'Sports',
    'Beauty',
    'Books'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Product Image Preview
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppConfig.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  image: _imageUrlController.text.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(_imageUrlController.text),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _imageUrlController.text.isEmpty
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: 50,
                        color: AppConfig.textSecondary,
                      )
                    : null,
              ),
              const SizedBox(height: 24),
              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Base Price
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Base Price',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product base price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Image URL
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  prefixIcon: Icon(Icons.image),
                ),
                onChanged: (value) => setState(() {}),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(height: 32),
              // Price Range Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConfig.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Pricing Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppConfig.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Customers can set their price between \$${(double.tryParse(_priceController.text) ?? 0) * AppConfig.minPriceMultiplier} and \$${(double.tryParse(_priceController.text) ?? 0) * AppConfig.maxPriceMultiplier}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConfig.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Add Product Button
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
                  onPressed: _addProduct,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'ADD PRODUCT',
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
      ),
    );
  }

  void _addProduct() {
  if (_formKey.currentState!.validate()) {
    final productService = Provider.of<VendorProductService>(context, listen: false);
    
    final newProduct = Product(
      id: '', // Let Firestore auto-generate or use proper ID generation
      name: _nameController.text,
      description: _descriptionController.text,
      basePrice: double.parse(_priceController.text),
      customerPrice: double.parse(_priceController.text),
      imageUrls: [_imageUrlController.text],
      category: _selectedCategory,
      vendorId: 'vendor1',
      vendorName: 'My Store',
      stockQuantity: 0,
      isFeatured: false,
      tags: [],
      specifications: {},
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(), // ADD THIS LINE
    );

    productService.addProduct(newProduct);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Product added successfully!'),
        backgroundColor: AppConfig.primaryColor,
      ),
    );
    
    Navigator.pop(context);
  }
}

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}

