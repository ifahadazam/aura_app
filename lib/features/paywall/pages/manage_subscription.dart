// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:quranic_influence/config/theme/typography/typography_theme.dart';
// import 'package:quranic_influence/core/constants/app_constants.dart';
// import 'package:quranic_influence/core/constants/strings/snack_bar_strings.dart';
// import 'package:quranic_influence/core/extensions/theme_getter.dart';
// import 'package:quranic_influence/core/shared/app_alert_dialogs.dart';
// import 'package:quranic_influence/core/shared/internal_page_app_bar.dart';
// import 'package:quranic_influence/core/extensions/app_theme_extension.dart';
// import 'package:quranic_influence/features/settings/presentation/widgets/setting_button.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ManageSubscription extends StatelessWidget {
//   const ManageSubscription({super.key, required this.subscriptionDuration});
//   final String subscriptionDuration;

//   @override
//   Widget build(BuildContext context) {
//     final colorTheme = context.theme.appColors;
//     return Scaffold(
//       appBar: InternalPageAppBar(
//           title: 'Manage Premium', themeColor: colorTheme.primaryColor),
//       body: Padding(
//         padding: AppConstants.pagesInternalPadding,
//         child: Column(
//           children: [
//             SettingButton(
//               isLeadingTrue: false,
//               title: 'Expiry Date',
//               settingAction: Padding(
//                 padding: const EdgeInsets.only(right: 6.0),
//                 child: Text(
//                   subscriptionDuration == 'null' ? 'Nil' : subscriptionDuration,
//                   style: TypographyTheme.primaryTitleStyle(14, context),
//                 ),
//               ),
//             ),
//             AppConstants.defaultSpace,
//             SettingButton(
//               onTap: () async {
//                 try {
//                   final customerInfo = await Purchases.getCustomerInfo();
//                   final playConsoleUrl = customerInfo.managementURL;
//                   if (playConsoleUrl != null) {
//                     log('Url: $playConsoleUrl');
//                     final Uri url = Uri.parse(playConsoleUrl);
//                     if (await launchUrl(url)) {
//                       await launchUrl(url);
//                     } else {
//                       if (context.mounted) {
//                         AppAlertDialogs.messageDialog(
//                           context,
//                           message: MessageStrings.error,
//                           isSuccess: false,
//                         );
//                       }
//                     }
//                   } else {
//                     log('Url: $playConsoleUrl');
//                     if (context.mounted) {
//                       AppAlertDialogs.messageDialog(
//                         context,
//                         message: 'Lifetime Purchase cannot be cancelled',
//                         isSuccess: false,
//                       );
//                     }
//                   }
//                 } catch (e) {
//                   if (context.mounted) {
//                     AppAlertDialogs.messageDialog(
//                       context,
//                       message: MessageStrings.error,
//                       isSuccess: false,
//                     );
//                   }
//                 }
//               },
//               isLeadingTrue: false,
//               title: 'Cancel Subscription',
//             ),
//             AppConstants.defaultSpace,
//           ],
//         ),
//       ),
//     );
//   }
// }
