import 'package:flutter/material.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';

class EachPackage extends StatelessWidget {
  const EachPackage({
    super.key,
    required this.duration,
    required this.price,
    required this.discountedPrice,
    required this.discount,
    required this.isSelected,
    required this.dealText,
  });
  final String duration;
  final String price;
  final String discountedPrice;
  final String discount;
  final bool isSelected;
  final String dealText;

  @override
  Widget build(BuildContext context) {
    final bool isDiscountNotEmpty = discount != '';
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.lightBlackColor,
        borderRadius: AppConstants.widgetBorderRadius,
      ),
      foregroundDecoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? AppColors.mainColorStrongOrange
              : AppColors.transparentColor,
          width: 1.2,
        ),
        borderRadius: AppConstants.widgetBorderRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppConstants.defaultSpace,
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.kMediumPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      duration,
                      style: TypographyTheme.themeTitleStyle(18).copyWith(
                        color: AppColors.mainColorLightOrange,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    isDiscountNotEmpty
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.kMediumPadding,
                              vertical: AppConstants.kSmallPadding,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.mainColorLightOrange,
                              borderRadius: AppConstants.widgetBorderRadius,
                            ),
                            child: Text(
                              discount,
                              style: TypographyTheme.simpleSubTitleStyle(
                                fontSize: 10,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                // AppConstants.defualtDoubleHalfSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      price,
                      style:
                          TypographyTheme.simpleSubTitleStyle(
                            fontSize: isDiscountNotEmpty ? 13 : 17,
                          ).copyWith(
                            decoration: isDiscountNotEmpty
                                ? TextDecoration.lineThrough
                                : null,
                            fontWeight: isDiscountNotEmpty
                                ? FontWeight.w400
                                : FontWeight.w700,
                            color: AppColors.themeWhite,
                          ),
                    ),
                    AppConstants.halfWidth,
                    if (isDiscountNotEmpty)
                      Text(
                        discountedPrice,
                        style: TypographyTheme.themeSubTitleStyle(
                          17,
                        ).copyWith(fontWeight: FontWeight.w700),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.kLargePadding,
                  vertical: AppConstants.kSmallPadding,
                ),
                decoration: BoxDecoration(
                  color: AppColors.themeWhite,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    dealText,
                    style: TypographyTheme.primarySubTitleStyle(
                      10,
                    ).copyWith(color: AppColors.blackColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
