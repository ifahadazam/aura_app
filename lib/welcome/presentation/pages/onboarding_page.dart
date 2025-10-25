import 'package:flutter/material.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/shared/buttons/action_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamyWhiteColor,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/welcome_image.jpg'),
                    ),
                  ),
                ),
              ),
              Expanded(flex: 4, child: SizedBox()),
            ],
          ),
          Column(
            children: [
              Expanded(flex: 2, child: SizedBox()),
              Expanded(
                flex: 4,
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppColors.creamyWhiteColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: AppConstants.widgetInternalPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppConstants.defaultDoubleSpace,
                        Text(
                          'iGoal',
                          style: TextStyle(
                            fontFamily: 'Valty DEMO',
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                        AppConstants.defaultDoubleSpace,
                        AppConstants.defaultDoubleSpace,
                        OnBoardingTile(
                          title: 'Remove Distractions',
                          iconColor: AppColors.themeBlack,
                          iconData: Icons.block,
                          subTitle: 'Eradicate bad habits & boost Time',
                        ),
                        OnBoardingTile(
                          title: 'Practice Good Habits',
                          iconColor: AppColors.themeBlack,
                          iconData: Icons.thumb_up_alt_rounded,
                          subTitle:
                              'Boost Productivity by performing Daily Good Habits',
                        ),
                        OnBoardingTile(
                          title: 'Perform Related Tasks',
                          iconColor: AppColors.themeBlack,
                          iconData: Icons.task_rounded,
                          subTitle:
                              'Schedule Tasks & achieve your goals timely.',
                        ),
                        OnBoardingTile(
                          title: 'Track Your Progress',
                          iconColor: AppColors.themeBlack,
                          iconData: Icons.bar_chart_rounded,
                          subTitle:
                              'Stay ahead of the curve by tracking your activities.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.kMediumPadding,
          vertical: AppConstants.kMediumPadding,
        ),
        child: SizedBox(
          height: 50,
          width: double.maxFinite,
          child: ActionButton(
            onTap: () {},
            title: 'Continue',
            buttonColor: AppColors.themeBlack,
          ),
        ),
      ),
    );
  }
}

// class OnBoardingDetails extends StatelessWidget {
//   const OnBoardingDetails({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           boardingData.topTitle,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 32,
//             fontFamily: 'Valty DEMO',
//             fontWeight: FontWeight.bold,
//             color: AppColors.themeWhite,
//           ),
//         ),
//         30.height,
//       Column(children: [
//         OnBoardingTile(title: 'Remove Distraction & Time Wasters', iconColor: AppColors.themeBlack, iconData: Icons.add, subTitle: 'Removing distractions and other time wasters will improve your focus',)

//       ],)
//       ],
//     );
//   }
// }

class OnBoardingTile extends StatelessWidget {
  const OnBoardingTile({
    super.key,
    required this.title,
    required this.iconColor,
    required this.iconData,
    required this.subTitle,
  });
  final String title;
  final String subTitle;
  final IconData iconData;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      leading: Container(
        height: 40,
        width: 40,

        decoration: BoxDecoration(
          color: AppColors.xtraLightGreyColor,
          shape: BoxShape.circle,
        ),
        child: Icon(iconData, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        textAlign: TextAlign.start,
        style: TypographyTheme.simpleTitleStyle(
          fontSize: 16,
        ).copyWith(color: iconColor),
      ),
      subtitle: Text(
        subTitle,
        textAlign: TextAlign.start,
        style: TypographyTheme.simpleSubTitleStyle(fontSize: 14),
      ),
    );
  }
}
