import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class InternalPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const InternalPageAppBar({
    super.key,
    required this.title,
    this.actions,
    required this.themeColor,
    this.backColor,
    this.isTitleCentered,
  });
  final String title;
  final List<Widget>? actions;
  final Color themeColor;
  final Color? backColor;
  final bool? isTitleCentered;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 50,
      iconTheme: IconThemeData(color: themeColor),
      centerTitle: isTitleCentered ?? true,
      backgroundColor: backColor ?? AppColors.transparentColor,
      surfaceTintColor: AppColors.transparentColor,
      title: Text(
        title,
        style: TypographyTheme.internalAppBarTitleStyle(themeColor),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
