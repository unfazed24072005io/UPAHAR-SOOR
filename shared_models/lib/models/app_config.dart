import 'package:flutter/material.dart';

class AppConfig {
  static const Color primaryColor = Color(0xFFFFD700);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFF8F9FA);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  
  // Pricing settings
  static const double minPriceMultiplier = 0.5;
  static const double maxPriceMultiplier = 2.0;
  static const double priceStep = 0.1;
  
  // Categories
  static const List<String> categories = ['Pets', 'Others'];
}
