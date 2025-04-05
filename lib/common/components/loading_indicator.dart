import 'package:flutter/material.dart';
import 'package:mywords/constants/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: const CircularProgressIndicator.adaptive(
        backgroundColor: AppColors.white,
      ),
    );
  }
}
