import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:life_goal/config/routes/app_route_constants.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/constants/app_gradients.dart';
import 'package:life_goal/core/shared/buttons/icon_tap_button.dart';
import 'package:life_goal/features/Home/presentation/pages/home_page.dart';
import 'package:life_goal/features/Main/presentation/bloc/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:life_goal/features/Main/presentation/widgets/bottom_bar_button.dart';
import 'package:life_goal/features/Settings/presentation/pages/settings_page.dart';
import 'package:life_goal/features/goals/presentation/pages/create_task.dart';
import 'package:life_goal/features/progress/presentation/pages/progress_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: AppColors.transparentColor,
        title: BlocBuilder<BottomBarBloc, BottomBarState>(
          builder: (context, state) {
            final pageIndex = state.index;
            return Row(
              children: [
                if (pageIndex == 0)
                  Image(
                    height: 25,
                    width: 25,
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/icon.png'),
                  ),
                AppConstants.singleWidth,
                Text(
                  pageIndex == 0
                      ? 'iGoal'
                      : pageIndex == 1
                      ? 'Progress'
                      : 'Settings',
                  style: TypographyTheme.homeAppBarTitleStyle(),
                ),
              ],
            );
          },
        ),

        actions: [
          IconTapButton(
            onTap: () {
              context.pushNamed(RouteConstants.settingsPageName);
            },
            iconDta: Icons.diamond_rounded,
            iconColor: AppColors.themeBlack,
            iconSize: 24,
          ),
          AppConstants.singleWidth,
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: BoxDecoration(gradient: AppGradients.scaffolfGradient),
          ),
          Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white24, AppColors.themeWhite],
              ),
            ),
          ),
          BlocBuilder<BottomBarBloc, BottomBarState>(
            builder: (context, state) {
              final pageIndex = state.index;
              final List<Widget> pages = [
                HomePage(),
                ProgressPage(),
                SettingsPage(),
              ];
              return SafeArea(child: pages[pageIndex]);
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: AppColors.themeBlack,
        onPressed: () {
          showModalBottomSheet(
            showDragHandle: true,
            elevation: 30,
            isDismissible: true,
            backgroundColor: AppColors.creamyWhiteColor,
            context: context,
            builder: (context) {
              return Wrap(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      context.pushNamed(RouteConstants.newHabitPageName);
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.xtraLightGreyColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          HugeIcons.strokeRoundedMedal05,
                          color: AppColors.themeBlack,
                          size: 23,
                        ),
                      ),
                    ),

                    title: Text(
                      'Habit',
                      style: TypographyTheme.simpleTitleStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      'Activity that repeats it over time',
                      style: TypographyTheme.simpleSubTitleStyle(fontSize: 14),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.themeBlack,
                      size: 20,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        useSafeArea: true,
                        showDragHandle: true,
                        elevation: 30,
                        isScrollControlled: true,
                        backgroundColor: AppColors.creamyWhiteColor,
                        context: context,
                        builder: (context) {
                          return CreateTask();
                        },
                      );
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.xtraLightGreyColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          HugeIcons.strokeRoundedTick01,
                          color: AppColors.themeBlack,
                          size: 23,
                        ),
                      ),
                    ),

                    title: Text(
                      'Task',
                      style: TypographyTheme.simpleTitleStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      'Single Instance activity.',
                      style: TypographyTheme.simpleSubTitleStyle(fontSize: 14),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.themeBlack,
                      size: 20,
                    ),
                  ),
                  AppConstants.defaultSpace,
                ],
              );
            },
          );
        },
        child: Icon(Icons.add, size: 26, color: AppColors.themeWhite),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        elevation: 50.0,
        color: AppColors.transparentColor,
        height: 60,
        child: Container(
          alignment: Alignment.center,
          width: double.maxFinite,

          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: AppConstants.bottomBarBorderRadius,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BottomBarButton(
                tag: 0,
                onTap: () {
                  context.read<BottomBarBloc>().add(
                    const GetPageIndexEvent(index: 0),
                  );
                },
                title: 'Home',
                icon: Icons.home_filled,
              ),
              BottomBarButton(
                tag: 1,
                onTap: () {
                  context.read<BottomBarBloc>().add(
                    const GetPageIndexEvent(index: 1),
                  );
                },
                title: 'Progress',
                icon: Icons.bar_chart_rounded,
              ),
              BottomBarButton(
                tag: 2,
                onTap: () {
                  context.read<BottomBarBloc>().add(
                    const GetPageIndexEvent(index: 2),
                  );
                },
                title: 'Settings',
                icon: Icons.settings,
              ),
              SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
