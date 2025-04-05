import 'package:flutter/material.dart';
import 'package:mywords/constants/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key, this.bgColor}) : super(key: key);
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(
        backgroundColor: bgColor ?? AppColors.white,
        valueColor: AlwaysStoppedAnimation<Color>(bgColor ?? Colors.white),
      ),
    );
  }
}
