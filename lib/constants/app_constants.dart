import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'ATU Attendance';
  static const String appVersion = '1.0.0';
  
  static const Duration splashDelay = Duration(seconds: 2);
  static const Duration scannerDelay = Duration(milliseconds: 1500);
  
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets defaultMargin = EdgeInsets.all(8.0);
  
  static const double borderRadius = 12.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  
  static const List<String> supportedBarcodeFormats = [
    'CODE_128',
    'QR_CODE',
    'EAN_13',
    'EAN_8',
    'CODE_39',
    'CODE_93',
  ];
}

class AppColors {
  static const Color primary = Color(0xFF1976D2);
  static const Color primaryVariant = Color(0xFF1565C0);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color secondaryVariant = Color(0xFF018786);
  
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F5F5);
  static const Color error = Color(0xFFB00020);
  
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);
  
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFBDBDBD);
}