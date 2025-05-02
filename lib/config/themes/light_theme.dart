import 'package:flutter/material.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/utils/extensions/size_extension.dart';

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
        error: AppColors.error),
    textTheme: _getTextTheme(),
  );
}

/// ---------------------------- ColorScheme ----------------------------

TextTheme _getTextTheme() {
  final _textTheme = TextTheme(
    headlineLarge: TextStyle(color: AppColors.textPrimary),
    headlineMedium: TextStyle(color: AppColors.textPrimary),
    headlineSmall: TextStyle(color: AppColors.textPrimary),
    titleLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16.ch),
    titleMedium: TextStyle(color: AppColors.textPrimary, fontSize: 14.ch),
    titleSmall: TextStyle(color: AppColors.textPrimary, fontSize: 12.ch),
    bodyLarge: TextStyle(color: AppColors.textSecondary, fontSize: 16.ch),
    bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14.ch),
    bodySmall: TextStyle(color: AppColors.textSecondary, fontSize: 12.ch),
    labelLarge: TextStyle(color: AppColors.textPrimary),
    labelMedium: TextStyle(color: AppColors.textPrimary),
    displayLarge: TextStyle(color: AppColors.textPrimary),
  );
  return _textTheme;
}
