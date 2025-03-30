import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool autofocus;
  final String hintText;
  final String prefixIconPath;
  final TextInputType? keyboardType;
  final bool hasPrefixIcon;

  const CustomTextFormField({
    Key? key,
    this.controller,
    this.onChanged,
    this.validator,
    this.autofocus = false,
    required this.hintText,
    required this.prefixIconPath,
    this.keyboardType,
    this.hasPrefixIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      autofocus: autofocus,
      keyboardType: keyboardType,
      style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0xff9E9E9E),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: hasPrefixIcon
            ? Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 12),
                child: SvgPicture.asset(prefixIconPath),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 16,horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
    );
  }
}
