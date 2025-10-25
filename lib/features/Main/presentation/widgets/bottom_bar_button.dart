import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/features/Main/presentation/bloc/bottom_bar_bloc/bottom_bar_bloc.dart';

class BottomBarButton extends StatelessWidget {
  const BottomBarButton({
    super.key,
    this.iconSize,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.tag,
  });
  final double? iconSize;
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final int tag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.transparentColor,
      onTap: onTap,
      child: BlocBuilder<BottomBarBloc, BottomBarState>(
        builder: (context, state) {
          final index = state.index;
          return SizedBox(
            //color: AppColors.plainGreen,
            height: double.maxFinite,
            // width: 54,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: iconSize ?? 19,
                  color: index == tag
                      ? AppColors.themeBlack
                      : AppColors.themeBlack.withAlpha(128),
                ),
                AppConstants.defualtHalfSpace,

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: index == tag
                        ? AppColors.themeBlack
                        : AppColors.themeBlack.withAlpha(128),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
