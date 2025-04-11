import 'package:flutter/material.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class CustomDropdownWithoutIcon extends StatelessWidget {
  final List<String> items;
  final String? value;
  final String hint;
  final Function(String?) onChanged;

  const CustomDropdownWithoutIcon({
    super.key,
    required this.items,
    this.value,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      dropdownColor: AppColors.white,
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xffEDEDED)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: context.colorScheme.secondary),
        ),
      ),
      icon: const SizedBox.shrink(),
      isExpanded: true,
      hint: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Text(
          hint,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff9E9E9E),
            fontSize: 14,
          ),
        ),
      ),
      selectedItemBuilder: (context) {
        return items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(item,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                )),
          );
        }).toList();
      },
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}
