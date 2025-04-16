

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final bool showLeading;
  final Widget? leading;
  final double elevation;
  final Color? backgroundColor;
  final TextStyle? titleStyle;

  CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showLeading = true,
    this.centerTitle = true,
    this.leading,
    this.elevation = 0,
    this.backgroundColor,
    this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: elevation,
      centerTitle: centerTitle,
      automaticallyImplyLeading: showLeading,
      leading: showLeading ? leading : null,
      actions: actions,
      title: Text(
        title,
        style: titleStyle ?? Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

