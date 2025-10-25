import 'package:flutter/material.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';

class PremiumBenefit extends StatelessWidget {
  const PremiumBenefit({
    super.key,
    required this.title,
    required this.subTitle,
    required this.iconData,
  });
  final String title;
  final String subTitle;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppConstants.kSmallPadding / 2,
      ),
      child: SizedBox(
        width: double.maxFinite,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.darkGreyColor,
              ),
              child: Center(
                child: Icon(
                  size: 20,
                  iconData,
                  color: const Color.fromARGB(255, 187, 225, 225),
                ),
              ),
            ),
            AppConstants.singleWidth,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.themeWhite,
                    ),
                  ),
                  Text(
                    subTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 187, 225, 225),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
