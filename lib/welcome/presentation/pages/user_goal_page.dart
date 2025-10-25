import 'package:flutter/material.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/extensions/sized_box.dart';
import 'package:life_goal/core/shared/buttons/action_button.dart';
import 'package:life_goal/core/shared/custom_text_field.dart';

class UserGoalPage extends StatefulWidget {
  const UserGoalPage({super.key});

  @override
  State<UserGoalPage> createState() => _UserGoalPageState();
}

class _UserGoalPageState extends State<UserGoalPage> {
  late TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamyWhiteColor,
      body: SafeArea(
        child: Padding(
          padding: AppConstants.pagesInternalPadding,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                50.height,
                Align(
                  alignment: Alignment.topCenter,
                  child: Image(
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/goal.png'),
                  ),
                ),
                AppConstants.defaultDoubleSpace,
                AppConstants.defaultDoubleSpace,
                Text(
                  'What is Your Primary Life Goal?',
                  style: TypographyTheme.simpleTitleStyle(fontSize: 20),
                ),
                AppConstants.defaultSpace,

                Text(
                  'What do you want to become/achieve in your life such as Business-man, Doctor, Lawyer, Entreprneur etc...',
                  style: TypographyTheme.simpleSubTitleStyle(fontSize: 15),
                ),
                AppConstants.defaultDoubleSpace,
                TextInputField(
                  themeColor: AppColors.themeBlack,
                  textController: controller,

                  hintText: 'Goal in 2 Words (20 Chars)',
                  obscureText: false,
                  keyboardType: TextInputType.text,
                ),
                Spacer(),
                ActionButton(
                  onTap: () {},
                  title: 'Continue',
                  buttonColor: AppColors.themeBlack,
                ),
                AppConstants.defaultSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
