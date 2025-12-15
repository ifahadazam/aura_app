import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';

class StreakStatusDialog extends StatelessWidget {
  final int streakCount; // e.g., 4
  final int todayIndex; // Monday = 0, Sunday = 6

  const StreakStatusDialog({
    super.key,
    required this.streakCount,
    required this.todayIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Confetti Image (use your decoration image)
            // SizedBox(
            //   height: 80,
            //   child: Icon(
            //     CupertinoIcons.flame_fill,
            //     size: 50,
            //     color: AppColors.mainColorLightOrange,
            //   ),
            // ),

            // const SizedBox(height: 8),

            /// Center Fire Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffFFF4E5),
              ),
              child: const Icon(
                CupertinoIcons.flame_fill,
                color: Colors.orange,
                size: 48,
              ),
            ),

            const SizedBox(height: 16),

            /// Streak Text
            Text(
              "$streakCount Day Streak!",
              style: TypographyTheme.simpleTitleStyle(fontSize: 22),
            ),

            AppConstants.defualtHalfSpace,

            Text(
              "You are doing a really Nice Progress !",
              textAlign: TextAlign.center,
              style: TypographyTheme.simpleSubTitleStyle(fontSize: 13),
            ),

            AppConstants.defaultDoubleSpace,
            AppConstants.defaultDoubleSpace,

            /// Week Streak Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final isFilled = index <= streakCount - 1;

                return Column(
                  children: [
                    Text(
                      ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][index],
                      style: const TextStyle(fontSize: 12),
                    ),
                    AppConstants.defaultSpace,
                    Icon(
                      Icons.local_fire_department,
                      size: 28,
                      color: isFilled ? Colors.orange : Colors.grey.shade300,
                    ),
                  ],
                );
              }),
            ),

            AppConstants.defaultDoubleSpace,
            AppConstants.defaultDoubleSpace,

            /// Take Quiz Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppConstants.widgetBorderRadius,
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Back To Home",
                  style: TypographyTheme.themeSubTitleStyle(14),
                ),
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
