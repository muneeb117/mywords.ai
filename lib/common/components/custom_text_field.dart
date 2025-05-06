import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';

enum InputFieldType { regular, email, password }

class InputField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool autofocus;
  final String hintText;
  final String prefixIconPath;
  final String? suffixIconPath;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool hasPrefixIcon;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onSuffixIconTap;
  final InputFieldType inputFieldType;

  const InputField({
    Key? key,
    this.controller,
    this.onChanged,
    this.validator,
    this.obscureText = false,
    this.autofocus = false,
    required this.hintText,
    required this.prefixIconPath,
    this.suffixIconPath,
    this.onSuffixIconTap,
    this.keyboardType,
    this.textInputAction,
    this.enabled,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.hasPrefixIcon = true,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  })  : inputFieldType = InputFieldType.regular,
        super(key: key);

  // Email field constructor
  const InputField.email({
    Key? key,
    this.controller,
    this.onChanged,
    this.validator,
    this.autofocus = false,
    this.enabled,
    String this.hintText = 'Email Address',
    this.hasPrefixIcon = true,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
  })  : prefixIconPath = 'assets/images/svg/ic_email.svg',
        suffixIconPath = null,
        onSuffixIconTap = null,
        keyboardType = TextInputType.emailAddress,
        obscureText = false,
        autocorrect = false,
        enableSuggestions = true,
        textCapitalization = TextCapitalization.none,
        inputFieldType = InputFieldType.email,
        super(key: key);

  // Password field constructor
  const InputField.password({
    Key? key,
    this.controller,
    this.onChanged,
    this.validator,
    this.autofocus = false,
    this.enabled,
    String this.hintText = 'Password',
    this.suffixIconPath,
    this.onSuffixIconTap,
    this.textInputAction = TextInputAction.done,
    this.obscureText = true,
    this.inputFormatters,
  })  : hasPrefixIcon = true,
        prefixIconPath = 'assets/images/svg/ic_lock.svg',
        keyboardType = TextInputType.visiblePassword,
        autocorrect = false,
        enableSuggestions = false,
        textCapitalization = TextCapitalization.none,
        inputFieldType = InputFieldType.password,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      autofocus: autofocus,

      autocorrect: autocorrect,
      enabled: enabled,
      enableSuggestions: enableSuggestions,
      textCapitalization: textCapitalization,
      validator: validator,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0xff9E9E9E),
          fontSize: 14.csp,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: hasPrefixIcon
            ? Padding(
                padding: EdgeInsets.only(left: 20.cw, right: 12.cw),
                child: SvgPicture.asset(prefixIconPath),
              )
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: 16.ch, horizontal: 20.cw),
        suffixIcon: suffixIconPath == null || suffixIconPath == ''
            ? null
            : InkWell(
                onTap: () {
                  onSuffixIconTap?.call();
                },
                child: Container(
                  padding: EdgeInsets.only(right: 14.cw, left: 14.cw),
                  child: SvgPicture.asset(
                    suffixIconPath!,
                    colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcIn),
                  ),
                ),
              ),
        suffixIconConstraints: suffixIconPath == null || suffixIconPath == ''
            ? null
            : BoxConstraints(minHeight: 46.ch, minWidth: 46.cw, maxWidth: 46.cw, maxHeight: 46.ch),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.cr),
          borderSide: BorderSide(
            color: Color(0xffEAECF0),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.cr),
          borderSide: BorderSide(
            color: Color(0xffEAECF0),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.cr),
          borderSide: BorderSide(
            color: context.colorScheme.secondary,
            width: 1,
          ),
        ),
      ),
    );
  }
}
