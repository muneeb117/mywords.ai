import 'package:flutter/material.dart';
import 'package:mywords/constants/app_colors.dart';

final lightTheme = _getTheme();

ThemeData _getTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
      outline: AppColors.textSecondary,
      error: AppColors.error,
    ),
    textTheme: _getTextTheme(),
  );
}

/// ---------------------------- ColorScheme ----------------------------

TextTheme _getTextTheme() {
  final _textTheme = TextTheme(
    headlineLarge: TextStyle(color: AppColors.textPrimary),
    headlineMedium: TextStyle(color: AppColors.textPrimary),
    headlineSmall: TextStyle(color: AppColors.textPrimary),
    titleLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16),
    titleMedium: TextStyle(color: AppColors.textPrimary, fontSize: 14),
    titleSmall: TextStyle(color: AppColors.textPrimary, fontSize: 12),
    bodyLarge: TextStyle(color: AppColors.textSecondary, fontSize: 16),
    bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
    bodySmall: TextStyle(color: AppColors.textSecondary, fontSize: 12),
    labelLarge: TextStyle(color: AppColors.textPrimary),
    labelMedium: TextStyle(color: AppColors.textPrimary),
    displayLarge: TextStyle(color: AppColors.textPrimary),
  );
  return _textTheme;
}
