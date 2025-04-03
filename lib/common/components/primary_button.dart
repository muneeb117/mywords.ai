import 'package:flutter/material.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

enum ButtonType { filled, outlined, gradient }

class PrimaryButton extends StatelessWidget {
  const PrimaryButton.filled({
    super.key,
    required this.onTap,
    required this.title,
    this.textColor = Colors.white,
    this.backgroundColor = const Color(0xffCE4AEF),
    this.fontWeight = FontWeight.w500,
  })  : buttonType = ButtonType.filled,
        gradientColors = null;

  const PrimaryButton.outlined({
    super.key,
    required this.onTap,
    required this.title,
    this.textColor = const Color(0xffCE4AEF),
    this.backgroundColor = Colors.transparent,
    this.fontWeight = FontWeight.w500,
  })  : buttonType = ButtonType.outlined,
        gradientColors = null;

  const PrimaryButton.gradient({
    super.key,
    required this.onTap,
    required this.title,
    this.textColor = Colors.white,
    this.gradientColors = const [Color(0xffCE4AEF), Color(0xff601FBE)],
    this.fontWeight = FontWeight.w500,
  })  : buttonType = ButtonType.gradient,
        backgroundColor = Colors.transparent;

  final String title;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final FontWeight fontWeight;
  final List<Color>? gradientColors;
  final ButtonType buttonType;

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration;

    // Determine Decoration Based on Button Type
    switch (buttonType) {
      case ButtonType.filled:
        decoration = BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
        );
        break;
      case ButtonType.outlined:
        decoration = BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: textColor, width: 2),
          borderRadius: BorderRadius.circular(6),
        );
        break;
      case ButtonType.gradient:
        decoration = BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors!,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(6),
        );
        break;
    }

    return Ink(
      decoration: decoration,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: context.textTheme.bodyMedium?.copyWith(
              color: buttonType == ButtonType.filled ? textColor : textColor,
              fontSize: 16,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
