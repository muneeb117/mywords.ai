import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/common/components/loading_indicator.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';

enum ButtonType { filled, outlined, gradient }

class PrimaryButton extends StatelessWidget {
  const PrimaryButton.filled({
    super.key,
    required this.onTap,
    required this.title,
    this.textColor = Colors.white,
    this.isLoading = false,
    this.iconPath,
    this.backgroundColor = const Color(0xffCE4AEF),
    this.enableShrinkAnimation = false,
    this.indicatorColor = AppColors.white,
    this.fontWeight = FontWeight.w500,
  })  : buttonType = ButtonType.filled,
        gradientColors = null;

  const PrimaryButton.outlined({
    super.key,
    required this.onTap,
    required this.title,
    this.isLoading = false,
    this.iconPath,
    this.textColor = const Color(0xffCE4AEF),
    this.backgroundColor = Colors.transparent,
    this.enableShrinkAnimation = false,
    this.fontWeight = FontWeight.w500,
    this.indicatorColor = AppColors.white,
  })  : buttonType = ButtonType.outlined,
        gradientColors = null;

  const PrimaryButton.gradient({
    super.key,
    required this.onTap,
    required this.title,
    this.textColor = Colors.white,
    this.isLoading = false,
    this.iconPath,
    this.gradientColors = const [Color(0xffCE4AEF), Color(0xff601FBE)],
    this.enableShrinkAnimation = false,
    this.indicatorColor = AppColors.white,
    this.fontWeight = FontWeight.w500,
  })  : buttonType = ButtonType.gradient,
        backgroundColor = Colors.transparent;

  final String title;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  final Color? indicatorColor;
  final bool isLoading;
  final bool enableShrinkAnimation;
  final FontWeight fontWeight;
  final List<Color>? gradientColors;
  final ButtonType buttonType;
  final String? iconPath;

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration;
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
    Widget button = Ink(
      decoration: decoration,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(6),
        child: AnimatedContainer(
          width: isLoading && enableShrinkAnimation ? 56 : MediaQuery.of(context).size.width,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: isLoading
              ? LoadingIndicator(bgColor: indicatorColor)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (iconPath != null)
                      Flexible(
                        child: Padding(
                          padding:  EdgeInsets.only(right: 8.cw, top: 1.ch),
                          child: SvgPicture.asset(iconPath!),
                        ),
                      ),
                    Flexible(
                      child: Text(
                        title,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: buttonType == ButtonType.filled ? textColor : textColor,
                          fontSize: 16.csp,
                          fontWeight: fontWeight,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );

    return enableShrinkAnimation ? Center(child: button) : button;
  }
}
