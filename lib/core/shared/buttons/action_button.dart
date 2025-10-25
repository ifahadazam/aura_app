import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:flutter/cupertino.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onTap,
    required this.title,
    required this.buttonColor,
    this.buttonState,
    this.isBorderEnabled,
    this.borderColor,
    this.borderButtonTextColor,
    this.buttonRadius,
    this.icon,
  });
  final VoidCallback onTap;
  final String title;
  final Color buttonColor;
  final bool? buttonState;
  final bool? isBorderEnabled;
  final Color? borderColor;
  final Color? borderButtonTextColor;
  final BorderRadius? buttonRadius;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: buttonRadius ?? AppConstants.widgetMediumBorderRadius,
          color: buttonColor,
          border: Border.all(
            width: isBorderEnabled ?? false ? 1 : 0,
            color: borderColor ?? AppColors.transparentColor,
          ),
        ),
        child: Center(
          child: buttonState ?? false
              ? CupertinoActivityIndicator(color: AppColors.themeWhite)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TypographyTheme.actionButtonTitleStyle(
                        borderButtonTextColor,
                      ),
                    ),
                    icon != null
                        ? AppConstants.singleWidth
                        : const SizedBox.shrink(),
                    icon ?? const SizedBox.shrink(),
                  ],
                ),
        ),
      ),
    );
  }
}
