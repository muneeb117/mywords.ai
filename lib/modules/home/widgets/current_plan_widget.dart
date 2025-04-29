import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class CurrentPlanWidget extends StatelessWidget {
  const CurrentPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Color(0xffEEEEEE))),
      child: Row(
        children: [
          SvgPicture.asset('assets/images/svg/ic_current_plan.svg', height: 48, width: 48),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  'Current Plan',
                  style: context.textTheme.titleSmall?.copyWith(fontSize: 10, color: AppColors.green, fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(color: AppColors.greenBg, borderRadius: BorderRadius.circular(3)),
              ),
              Text('Free', style: context.textTheme.titleMedium),
            ],
          ),
        ],
      ),
    );
  }
}
