import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class IconTapButton extends StatelessWidget {
  const IconTapButton({
    super.key,
    required this.onTap,
    required this.iconDta,
    this.iconSize,
    this.iconColor,
    this.backColor,
  });
  final VoidCallback onTap;
  final IconData iconDta;
  final double? iconSize;
  final Color? iconColor;
  final Color? backColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.kSmallPadding),
      child: IconButton.filled(
        style: IconButton.styleFrom(
          backgroundColor: backColor ?? AppColors.transparentColor,
        ),
        //  focusColor: AppColors.lightWhiteColor,
        onPressed: onTap,
        icon: Icon(
          iconDta,
          color: iconColor ?? AppColors.themeWhite,
          size: iconSize ?? 32,
        ),
      ),
    );
  }
}
