import 'package:flutter/material.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/extensions/sized_box.dart';
import 'package:life_goal/core/shared/buttons/action_button.dart';
import 'package:life_goal/core/shared/internal_page_app_bar.dart';

class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamyWhiteColor,
      appBar: InternalPageAppBar(
        title: 'Go Premium',
        themeColor: AppColors.themeBlack,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Restore',
              style: TypographyTheme.simpleSubTitleStyle(fontSize: 15),
            ),
          ),
          AppConstants.singleWidth,
        ],
      ),

      body: Padding(
        padding: AppConstants.pagesInternalPadding,
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppConstants.kLargePadding),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.xtraLightGreyColor,
                    ),
                    child: Icon(
                      Icons.key_rounded,
                      color: AppColors.themeBlack,
                      size: 45,
                    ),
                  ),
                  Text(
                    'Remove Distractions',
                    style: TypographyTheme.simpleTitleStyle(fontSize: 16),
                  ),
                  Text(
                    'Eradicat Bad Habits & Time Wasters from your life permanently',
                    textAlign: TextAlign.center,
                    style: TypographyTheme.simpleSubTitleStyle(fontSize: 14),
                  ),

                  Row(
                    spacing: 7,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Icon(
                        Icons.circle,
                        size: 10,
                        color: AppColors.lightBlackColor,
                      );
                    }),
                  ),
                ],
              ),

              Column(
                children: [
                  AppConstants.defaultDoubleSpace,
                  AppConstants.defaultDoubleSpace,
                  ListTile(
                    tileColor: AppColors.themeWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppConstants.widgetBorderRadius,
                      side: BorderSide(color: AppColors.themeBlack),
                    ),
                    leading: Icon(
                      Icons.done,
                      size: 22,
                      color: AppColors.themeBlack,
                    ),
                    title: Text(
                      'Yearly Plan',
                      style: TypographyTheme.simpleTitleStyle(fontSize: 18),
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          '\$ 99.9',
                          style: TypographyTheme.simpleSubTitleStyle(
                            fontSize: 14,
                          ).copyWith(decoration: TextDecoration.lineThrough),
                        ),
                        5.width,
                        Text(
                          '\$49.9',
                          style: TypographyTheme.simpleTitleStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    trailing: Text(
                      '\$4.17/month',
                      style: TypographyTheme.simpleSubTitleStyle(fontSize: 13),
                    ),
                  ),
                  AppConstants.defaultSpace,
                  ListTile(
                    tileColor: AppColors.themeWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppConstants.widgetBorderRadius,
                      side: BorderSide(color: AppColors.lightGreyColor),
                    ),
                    leading: Icon(
                      Icons.circle_outlined,
                      size: 22,
                      color: AppColors.themeBlack,
                    ),
                    title: Text(
                      'Monthly Plan',
                      style: TypographyTheme.simpleTitleStyle(fontSize: 18),
                    ),
                    trailing: Text(
                      '\$4.17/month',
                      style: TypographyTheme.simpleSubTitleStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SizedBox(
        height: 115,
        width: double.maxFinite,
        child: Padding(
          padding: EdgeInsetsGeometry.all(AppConstants.kLargePadding),
          child: Column(
            children: [
              Expanded(
                child: ActionButton(
                  onTap: () {},
                  title: 'Start 3 Day Free Trial',
                  buttonColor: AppColors.themeBlack,
                ),
              ),
              AppConstants.defualtHalfSpace,
              Text(
                'Recurring Billing, Cancel Anytime',
                style: TypographyTheme.simpleSubTitleStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
