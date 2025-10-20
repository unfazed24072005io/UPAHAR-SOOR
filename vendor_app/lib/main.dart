import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_models/models/app_config.dart';
import 'screens/vendor_home_screen.dart';
import 'services/vendor_product_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VendorProductService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upahar - Vendor',
      theme: ThemeData(
        primaryColor: AppConfig.primaryColor,
        scaffoldBackgroundColor: AppConfig.backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConfig.backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: AppConfig.textPrimary),
          titleTextStyle: TextStyle(
            color: AppConfig.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: AppConfig.cardColor,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppConfig.textPrimary,
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppConfig.textPrimary,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: AppConfig.textPrimary,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: AppConfig.textSecondary,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const VendorHomeScreen(),
    );
  }
}