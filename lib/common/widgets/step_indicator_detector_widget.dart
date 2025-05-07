import 'package:flutter/material.dart';
import 'package:mywords/constants/app_colors.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class StepIndicatorDetector extends StatelessWidget {
  StepIndicatorDetector({super.key, required this.activeSteps});

  final List<int> activeSteps;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: context.colorScheme.secondary.withOpacity(0.05), border: Border.all(color: Color(0xffEAECF0))),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Spacer(),
          StepIndicatorRoundedComponent(isActive: activeSteps.contains(1), stepNumber: '1', stepTitle: 'Input'),
          SizedBox(width: 6),
          Expanded(child: Padding(padding: const EdgeInsets.only(top: 2.0), child: Divider(thickness: 1, color: Color(0xff94A3B8)))),
          SizedBox(width: 6),
          StepIndicatorRoundedComponent(isActive: activeSteps.contains(2), stepNumber: '2', stepTitle: 'Output'),
          Spacer(),
        ],
      ),
    );
  }
}

class StepIndicatorRoundedComponent extends StatelessWidget {
  const StepIndicatorRoundedComponent({super.key, required this.isActive, required this.stepNumber, required this.stepTitle});

  final bool isActive;
  final String stepNumber;
  final String stepTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 27,
          width: 27,
          decoration: BoxDecoration(color: isActive ? context.colorScheme.secondary : AppColors.white, shape: BoxShape.circle),
          child: Center(
            child: Text(
              stepNumber,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isActive ? context.theme.scaffoldBackgroundColor : context.colorScheme.secondary,
              ),
            ),
          ),
        ),
        SizedBox(width: 7),
        Text(stepTitle, style: context.textTheme.titleSmall?.copyWith(fontWeight: isActive ? FontWeight.bold : FontWeight.w400)),
      ],
    );
  }
}
