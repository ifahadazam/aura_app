import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/shared/internal_page_app_bar.dart';
import 'package:life_goal/features/Settings/presentation/pages/settings_page.dart';

class ManageSubscriptionPage extends StatelessWidget {
  const ManageSubscriptionPage({super.key});

  /// Returns: 'Weekly', 'Monthly', 'Annual' or 'None'
  // Future<String> getActiveSubscriptionType() async {
  //   try {
  //     final customerInfo = await Purchases.getCustomerInfo();
  //     const entitlementId =
  //         RevenueCatConstants.entitlementId; // Replace with your entitlement ID

  //     final entitlement = customerInfo.entitlements.all[entitlementId];

  //     if (entitlement != null && entitlement.isActive) {
  //       final productId = entitlement.productIdentifier;

  //       if (productId.contains('weekly')) return 'Weekly';
  //       if (productId.contains('monthly')) return 'Monthly';
  //       if (productId.contains('annual') || productId.contains('yearly')) {
  //         return 'Yearly';
  //       }

  //       // If product doesn't match known types
  //     }

  //     return 'None'; // No active entitlement
  //   } catch (e) {
  //     log('❌ Error fetching subscription type: $e');
  //     return 'Error';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.themeBlack,
      appBar: InternalPageAppBar(
        title: 'Manage Subscription',
        themeColor: AppColors.themeWhite,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.kMediumPadding,
          horizontal: AppConstants.kMediumPadding,
        ),
        child: Column(
          children: [
            SettingTile(iconData: Icons.watch_later_rounded, title: 'Duration'),
            AppConstants.defaultSpace,
            SettingTile(iconData: Icons.close, title: 'Cancel Now'),
            AppConstants.defaultDoubleSpace,
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.kMediumPadding,
              ),
              child: Text(
                'The Guide is Here',
                style: TypographyTheme.themeSubTitleStyle(
                  16,
                ).copyWith(color: AppColors.mainColorLightOrange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
