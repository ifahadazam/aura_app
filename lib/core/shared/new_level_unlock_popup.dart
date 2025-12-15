import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/shared/buttons/action_button.dart';

class NewLevelUnlockPopup extends StatelessWidget {
  final String userName;
  final String badgeTitle;
  final int auraPoints;

  const NewLevelUnlockPopup({
    super.key,
    required this.userName,
    required this.badgeTitle,
    required this.auraPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Title
            const Text(
              "New Level Unlocked",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),

            AppConstants.defaultSpace,

            /// Message
            Text(
              "Congrats, $userName! You earned a new level in your journey.",
              textAlign: TextAlign.center,
              style: TypographyTheme.simpleSubTitleStyle(
                fontSize: 14,
              ).copyWith(color: AppColors.lightBlackColor),
            ),

            AppConstants.defaultDoubleSpace,
            AppConstants.defaultDoubleSpace,
            // AppConstants.defaultDoubleSpace,

            /// Badge Icon (Centered)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.lightGreyColor,
              ),
              child: Icon(
                CupertinoIcons.flame_fill,
                size: 35,
                color: AppColors.themeBlack,
              ),
            ),

            AppConstants.defaultDoubleSpace,

            /// Badge Title
            Text(
              badgeTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            AppConstants.defaultSpace,

            Text(
              auraPoints.toString(),
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            AppConstants.defaultDoubleSpace,
            AppConstants.defaultDoubleSpace,
            // AppConstants.defaultDoubleSpace,

            /// Button
            ActionButton(
              onTap: () {},
              title: 'Continue',
              buttonColor: AppColors.themeBlack,
            ),
          ],
        ),
      ),
    );
  }
}
