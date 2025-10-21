import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_models/models/app_config.dart';
import 'screens/home_screen.dart';
import 'services/product_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductService()),
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
      title: 'Upahar - Customer',
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
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppConfig.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
