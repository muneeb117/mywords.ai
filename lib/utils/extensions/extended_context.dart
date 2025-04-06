import 'package:flutter/material.dart';

extension ExtendedContext on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  ThemeData get theme => Theme.of(this);

  bool get isDark => Theme.of(this).colorScheme.brightness == Brightness.dark;

  void closeKeyboard() => FocusScope.of(this).unfocus();

  void showSnackBar(
    String message, {
    bool isError = false,
  }) {
    final theme = Theme.of(this);
    final Color? foregroundColor;
    final Color? backgroundColor;
    if (isError) {
      foregroundColor = theme.colorScheme.onError;
      backgroundColor = theme.colorScheme.error;
    } else {
      foregroundColor = null;
      backgroundColor = null;
    }
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor ?? Colors.black87,

        content: Text(
          message,
          style: TextStyle(color: foregroundColor),
        ),
      ),
    );
  }
}
