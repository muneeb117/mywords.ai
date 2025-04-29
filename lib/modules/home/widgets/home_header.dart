import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/png/img_app_icon.png', height: 45, width: 45),
              SizedBox(width: 4),
              Text(
                'MyWords.AI',
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pushNamed(context, RouteManager.setting);
            },
            child: Padding(padding: const EdgeInsets.only(left: 4.0), child: SvgPicture.asset('assets/images/svg/ic_settings_nav.svg')),
          ),
        ],
      ),
    );
  }
}
