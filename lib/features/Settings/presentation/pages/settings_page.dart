import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/shared/internal_page_app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamyWhiteColor,
      extendBodyBehindAppBar: true,
      appBar: InternalPageAppBar(
        title: 'Settings',
        themeColor: AppColors.themeBlack,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.kMediumPadding,
          ),
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    // color: AppColors.mainColorLightBlue,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color.fromARGB(255, 240, 228, 233),
                        Color.fromARGB(255, 243, 255, 251),

                        Color.fromARGB(255, 252, 248, 245),
                        //  Color.fromARGB(255, 239, 239, 251),
                      ],
                    ),
                    border: Border.all(color: AppColors.greyColor),
                    borderRadius: AppConstants.widgetBorderRadius,
                  ),
                  child: ListTile(
                    onTap: () {},
                    trailing: const Icon(
                      CupertinoIcons.rocket_fill,
                      color: AppColors.blackColor,
                    ),
                    leading: const SizedBox(
                      height: 50,
                      width: 50,
                      child: Icon(
                        Icons.diamond_rounded,
                        size: 34,
                        color: AppColors.themeBlack,
                      ),
                    ),
                    title: Text(
                      'Upgrade Now !',
                      style: TypographyTheme.simpleTitleStyle(
                        fontSize: 19,
                      ).copyWith(color: AppColors.blackColor),
                    ),
                    subtitle: Text(
                      'Click to see Premium features',
                      style: TypographyTheme.simpleSubTitleStyle(
                        fontSize: 12,
                      ).copyWith(color: AppColors.blackColor),
                    ),
                  ),
                ),

                AppConstants.defaultSpace,
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '    App',
                          style: TypographyTheme.themeTitleStyle(
                            13,
                          ).copyWith(color: AppColors.lightBlackColor),
                        ),
                      ],
                    ),
                    AppConstants.defaultSpace,

                    Container(
                      padding: AppConstants.widgetInternalPadding,
                      decoration: BoxDecoration(
                        borderRadius: AppConstants.widgetBorderRadius,
                        color: AppColors.themeWhite,
                        border: Border.all(color: AppColors.lightGreyColor),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SettingTile(
                            iconData: CupertinoIcons.pin_fill,
                            title: 'Update Goal',
                          ),
                          SettingTile(
                            iconData: CupertinoIcons.moon_fill,
                            title: 'Theme',
                          ),

                          SettingTile(
                            iconData: Icons.download,
                            title: 'Data Import/Export',
                          ),
                          SettingTile(
                            onTap: () {},
                            iconData: Icons.delete,
                            title: 'Delete Data',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppConstants.defaultSpace,
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '    General',
                          style: TypographyTheme.themeTitleStyle(
                            13,
                          ).copyWith(color: AppColors.lightBlackColor),
                        ),
                      ],
                    ),
                    AppConstants.defaultSpace,

                    Container(
                      padding: AppConstants.widgetInternalPadding,
                      decoration: BoxDecoration(
                        borderRadius: AppConstants.widgetBorderRadius,
                        color: AppColors.themeWhite,
                        border: Border.all(color: AppColors.lightGreyColor),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SettingTile(
                            iconData: Icons.share,
                            title: 'Share App',
                          ),
                          SettingTile(
                            iconData: Icons.send,
                            title: 'Send Suggestion',
                          ),
                          SettingTile(iconData: Icons.star, title: 'Rate App'),
                          SettingTile(
                            iconData: Icons.file_copy_outlined,
                            title: 'Privacy policy',
                          ),
                          SettingTile(
                            iconData: Icons.phone,
                            title: 'Contact Us',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // AppConstants.defaultSpace,
                // Container(
                //   // padding: AppConstants.widgetInternalPadding,
                //   decoration: BoxDecoration(
                //     borderRadius: AppConstants.widgetBorderRadius,
                //     color: const Color.fromARGB(255, 252, 204, 201),
                //   ),
                //   child: Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 12),
                //     child: SettingTile(
                //       themeColor: AppColors.redColor,
                //       iconData: Icons.delete_forever_rounded,
                //       title: 'Delete Account',
                //     ),
                //   ),
                // ),
                AppConstants.defaultDoubleSpace,

                Text(
                  'iGoal : 1.0.0+1',
                  style: TypographyTheme.simpleSubTitleStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  const SettingTile({
    super.key,
    required this.iconData,
    required this.title,
    this.onTap,
    this.themeColor,
  });
  final String title;
  final IconData iconData;
  final VoidCallback? onTap;
  final Color? themeColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 45,
        width: double.maxFinite,
        child: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: AppColors.xtraLightGreyColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: themeColor ?? AppColors.themeBlack,
                size: 17,
              ),
            ),
            AppConstants.singleWidth,
            Text(
              title,
              style: TypographyTheme.simpleSubTitleStyle(
                fontSize: 13,
              ).copyWith(color: themeColor ?? AppColors.themeBlack),
            ),
            Spacer(),
            Icon(
              Icons.keyboard_arrow_right,
              color: themeColor ?? AppColors.themeBlack,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
