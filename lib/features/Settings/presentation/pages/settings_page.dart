import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:life_goal/config/routes/app_route_constants.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/shared/custom_text_field.dart';
import 'package:life_goal/core/shared/new_leveL_unlock_popup.dart';
import 'dart:math' as math;

import 'package:life_goal/core/utils/hive_db/hive_constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: AppConstants.pagesInternalPadding,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpgradeNowWidget(),

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
                        onTap: () {
                          final String? futureGoalValue = Hive.box(
                            HiveConstants.futureGoalBox,
                          ).get(HiveConstants.futureGoalBoxValue);
                          //context.pushNamed(RouteConstants.onboardingPageName);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return UpdateGoalDialog(
                                futureGoal: futureGoalValue,
                              );
                            },
                          );
                        },
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
                        onTap: () {
                          // showDialog(
                          //   context: context,
                          //   builder: (context) {
                          //     return StreakStatusDialog(
                          //       streakCount: 4,
                          //       todayIndex: 2,
                          //     );
                          //   },
                          // );

                          showDialog(
                            context: context,
                            builder: (context) {
                              return NewLevelUnlockPopup(
                                userName: 'Fahad',
                                badgeTitle: 'Advanced',
                                auraPoints: 2459,
                              );
                            },
                          );
                        },
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
                      SettingTile(iconData: Icons.share, title: 'Share App'),
                      SettingTile(
                        iconData: Icons.send,
                        title: 'Send Suggestion',
                      ),
                      SettingTile(iconData: Icons.star, title: 'Rate App'),
                      SettingTile(
                        iconData: Icons.file_copy_outlined,
                        title: 'Privacy policy',
                      ),
                      SettingTile(iconData: Icons.phone, title: 'Contact Us'),
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
    );
  }
}

class UpgradeNowWidget extends StatefulWidget {
  const UpgradeNowWidget({super.key});

  @override
  State<UpgradeNowWidget> createState() => _UpgradeNowWidgetState();
}

class _UpgradeNowWidgetState extends State<UpgradeNowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // continuous animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: GradientBorderPainter(rotation: _controller.value),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.themeWhite,
              // border: Border.all(color: AppColors.greyColor),
              borderRadius: AppConstants.widgetBorderRadius,
            ),
            child: ListTile(
              onTap: () {
                context.pushNamed(RouteConstants.paywallPageName);
              },
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
        );
      },
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

class GradientBorderPainter extends CustomPainter {
  final double rotation;

  GradientBorderPainter({required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    double borderWidth = 4;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // rotating sweep gradient
    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: math.pi * 2,
      transform: GradientRotation(rotation * 2 * math.pi),
      colors: const [
        Colors.blue,
        Colors.purple,
        Colors.greenAccent,
        Colors.orange,
        Colors.pink,
        Colors.blue,
      ],
      stops: const [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(20));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant GradientBorderPainter oldDelegate) =>
      oldDelegate.rotation != rotation;
}

class UpdateGoalDialog extends StatefulWidget {
  const UpdateGoalDialog({super.key, this.futureGoal});
  final String? futureGoal;

  @override
  State<UpdateGoalDialog> createState() => _UpdateGoalDialogState();
}

class _UpdateGoalDialogState extends State<UpdateGoalDialog> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.futureGoal);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.creamyWhiteColor,

      title: Text(
        'Update Goal',
        style: TypographyTheme.simpleTitleStyle(fontSize: 16),
      ),
      content: TextInputField(
        isBorderVisible: false,
        textController: controller,
        hintText: 'Your Goal',
        obscureText: false,
        keyboardType: TextInputType.text,
        themeColor: AppColors.themeBlack,
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(
            'Cancel',
            style: TypographyTheme.simpleTitleStyle(fontSize: 14),
          ),
        ),
        TextButton(
          onPressed: () {
            Hive.box(
              HiveConstants.futureGoalBox,
            ).put(HiveConstants.futureGoalBoxValue, controller.text);
            context.pop();
          },
          child: Text(
            'Update',
            style: TypographyTheme.simpleTitleStyle(
              fontSize: 14,
            ).copyWith(color: AppColors.greenColor),
          ),
        ),
      ],
    );
  }
}
