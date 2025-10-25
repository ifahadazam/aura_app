import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:life_goal/config/themes/typography/typography_theme.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';
import 'package:life_goal/core/extensions/sized_box.dart';
import 'package:life_goal/core/shared/buttons/action_button.dart';
import 'package:life_goal/core/shared/buttons/icon_tap_button.dart';
import 'package:life_goal/core/utils/models/premium_benefit_model.dart';
import 'package:life_goal/features/paywall/widgets/each_package.dart';
import 'package:life_goal/features/paywall/widgets/premium_benefit.dart';

class Paywall extends StatefulWidget {
  const Paywall({super.key});

  @override
  State<Paywall> createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  ValueNotifier buttonLoadingState = ValueNotifier(false);

  @override
  void dispose() {
    super.dispose();
    buttonLoadingState.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.transparentColor,
        actions: [
          IconTapButton(
            onTap: () {
              //MainPageUtils.showEnableNotificationPage(context);
            },
            iconDta: Icons.close,
            backColor: AppColors.lightWhiteColor,
            iconColor: AppColors.redColor,
            iconSize: 24,
          ),
          AppConstants.halfWidth,
        ],
      ),
      backgroundColor: AppColors.variantBlack,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenHeight * 0.25,
              width: double.maxFinite,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                image: DecorationImage(
                  fit: BoxFit.contain,
                  // colorFilter: ColorFilter.mode(
                  //   AppColors.blackColor.withOpacity(0.3),
                  //   BlendMode.darken,
                  // ),
                  image: AssetImage('assets/images/pay_wall.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.kMediumPadding,
              ),
              child: Column(
                children: [
                  AppConstants.defaultSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.diamond,
                        color: AppColors.themeWhite,
                        size: 24,
                      ),
                      AppConstants.singleWidth,
                      Text(
                        'Go Premium',
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'Valty DEMO',
                          color: AppColors.themeWhite,
                        ),
                      ),
                    ],
                  ),
                  AppConstants.defaultDoubleSpace,
                  PackagesWidgets(
                    weeklyPrice: 2.99,
                    monthlyPrice: 9.99,
                    yearlyPrice: 49.99,
                    currencyCode: 'USD',
                  ),

                  // FutureBuilder(
                  //   future: AppPircing.getPackageMap(),
                  //   builder: (context, snapshot) {
                  //     if (!snapshot.hasData) {
                  //       return PackagesWidgets(
                  //         weeklyPrice: 2.99,
                  //         monthlyPrice: 9.99,
                  //         yearlyPrice: 49.99,
                  //         currencyCode: 'USD',
                  //       );
                  //     } else {
                  //       final pircingData = snapshot.data ?? {};
                  //       final weeklyPackage = pircingData['Weekly'];
                  //       final monthlyPackage = pircingData['Monthly'];
                  //       final yearlyPackage = pircingData['Yearly'];
                  //       final String currencyCode =
                  //           weeklyPackage!.storeProduct.currencyCode;
                  //       log('CC: ${weeklyPackage.storeProduct.currencyCode}');
                  //       final double weekprice =
                  //           weeklyPackage.storeProduct.price;
                  //       final double monthprice =
                  //           monthlyPackage!.storeProduct.price;
                  //       final double yearPrice =
                  //           yearlyPackage!.storeProduct.price;
                  //       return PackagesWidgets(
                  //         weeklyPrice: weekprice,
                  //         monthlyPrice: monthprice,
                  //         yearlyPrice: yearPrice,
                  //         currencyCode: currencyCode,
                  //       );
                  //     }
                  //   },
                  // ),
                  AppConstants.defaultDoubleSpace,
                  Text(
                    'Premium Benefits',
                    style: TypographyTheme.themeTitleStyle(
                      21,
                    ).copyWith(color: AppColors.mainColorLightGreen),
                  ),
                  AppConstants.defaultDoubleSpace,
                  ...List.generate(premiumBenefits(context).length, (index) {
                    final PremiumBenefitModel benefit = premiumBenefits(
                      context,
                    )[index];
                    return PremiumBenefit(
                      title: benefit.title,
                      subTitle: benefit.subTitle,
                      iconData: benefit.iconData,
                    );
                  }),
                  30.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {},
                        child: Text(
                          'Privacy Policy     ●  ',
                          style: TypographyTheme.themeSubTitleStyle(12),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {},
                        child: Text(
                          '   Contact Us',
                          style: TypographyTheme.themeSubTitleStyle(12),
                        ),
                      ),
                    ],
                  ),
                  30.height,
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.kLargePadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
              valueListenable: buttonLoadingState,
              builder: (context, isloading, child) {
                return ActionButton(
                  buttonState: isloading,
                  onTap: () {},
                  title: 'Continue',
                  buttonColor: AppColors.mainColorStrongOrange,
                );
              },
            ),
            ActionButton(
              icon: const Icon(
                CupertinoIcons.wand_stars_inverse,
                color: AppColors.themeWhite,
              ),
              onTap: () async {},
              title: 'Restore Purchase',
              buttonColor: AppColors.transparentColor,
              borderButtonTextColor: AppColors.themeWhite,
            ),
            AppConstants.defaultSpace,
          ],
        ),
      ),
    );
  }
}

class PackagesWidgets extends StatelessWidget {
  const PackagesWidgets({
    super.key,
    required this.monthlyPrice,
    required this.weeklyPrice,
    required this.yearlyPrice,
    required this.currencyCode,
  });
  final double weeklyPrice;
  final double monthlyPrice;
  final double yearlyPrice;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          //splashColor: AppColors.transparentColor,
          onTap: () {},
          child: EachPackage(
            duration: 'Yearly',
            isSelected: true,
            //price: '49.99\$',
            price: '${yearlyPrice * 2} $currencyCode',
            discountedPrice: '$yearlyPrice $currencyCode',
            discount: '-50%',
            dealText: 'Early Bird Offer',
          ),
        ),
        AppConstants.defaultSpace,
        SizedBox(
          width: double.maxFinite,
          height: 100,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: GestureDetector(
                  //splashColor: AppColors.transparentColor,
                  onTap: () {},
                  child: EachPackage(
                    duration: 'Weekly',
                    isSelected: false,
                    discount: '',
                    // price: '2.99\$',
                    price: '$weeklyPrice $currencyCode',
                    discountedPrice: '',
                    dealText: 'Budget Friendly',
                  ),
                ),
              ),
              AppConstants.singleWidth,
              Flexible(
                child: GestureDetector(
                  //  splashColor: AppColors.transparentColor,
                  onTap: () {},
                  child: EachPackage(
                    duration: 'Monthly',
                    discount: '',

                    isSelected: false,
                    // price: '9.99\$',
                    price: '$monthlyPrice $currencyCode',
                    discountedPrice: '',
                    dealText: 'Best To Start',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
