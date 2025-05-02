import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class AppleAuthButton extends StatelessWidget {
  final VoidCallback onTap;

  const AppleAuthButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffEDF1F3)),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SvgPicture.asset('assets/images/svg/ic_apple.svg'),
              ),
            ),
          ),
          Text('Continue with Apple', style: context.textTheme.titleMedium)
        ],
      ),
    );
  }
} 