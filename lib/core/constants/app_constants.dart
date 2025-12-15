import 'package:life_goal/core/extensions/sized_box.dart';
import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();
  static const Size draHandleSize = Size(40, 6);
  static const testString =
      'Allah does not charge a soul except what He has given it.';

  // Button Border Radius
  static var widgetMediumBorderRadius = BorderRadius.circular(15);

  //Dialog Alert Button Border Radius
  static var widetHalfBorderRadius = BorderRadius.circular(10);

  // Widget Border Radius
  static var widgetBorderRadius = BorderRadius.circular(20);

  // Layout Border Radus
  static const layoutBorderRadius = BorderRadius.only(
    topRight: Radius.circular(25),
    topLeft: Radius.circular(25),
  );

  //* Bottom Bar Constants
  //BottomBar Border Radius
  static const bottomBarBorderRadius = BorderRadius.only(
    topRight: Radius.circular(22),
    topLeft: Radius.circular(22),
  );

  static const double bottomBarHeight = 70;

  //? Auth Form Field Outline Border

  //* Focused Border
  static var authFocusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      // color: AppColors.blackColor,
      width: 1.2,
    ),
  );

  //* Enabled Border
  static var authEnabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(
      //  color: AppColors.blackColor,
      width: 1.2,
    ),
  );

  //* App padings
  // Layout Default Padding
  static const layoutDefaultPadding = EdgeInsets.only(
    top: 12,
    bottom: 24 + kBottomNavigationBarHeight,
    left: 10,
    right: 10,
  );

  //Pages Internal Padding
  static const pagesInternalPadding = EdgeInsets.only(
    top: 2,
    bottom: 12,
    left: 13,
    right: 13,
  );

  // Layout padding for SignUP and SignIn Pages

  static const authLayoutPadding = EdgeInsets.symmetric(
    horizontal: 25,
    vertical: 15,
  );

  // Widgets Internal Padding
  static const widgetInternalPadding = EdgeInsets.symmetric(
    vertical: 9,
    horizontal: 12,
  );

  //BottomBar Button Padding
  static const bottomBarButtonPadding = EdgeInsets.only(
    right: 10,
    left: 10,
    bottom: 5,
  );
  static const likedTabPadding = EdgeInsets.only(
    left: 10,
    right: 10,
    bottom: kBottomNavigationBarHeight + 24,
  );

  static const kSmallPadding = 6.0;
  static const kMediumPadding = 10.0;
  static const kLargePadding = 16.0;
  static const extraLargePadding = 50.0;

  //*Width

  static var doubleWidth = 20.width;
  static var singleWidth = 10.width;
  static var halfWidth = 5.width;

  //Layout Default double Half Spcae
  static var defualtDoubleHalfSpace = 2.height;

  //Layout Default Half Spcae
  static var defualtHalfSpace = 4.height;

  // Layout Defualt Height
  static var defaultSpace = 8.height;

  // Layout Default Double Height
  static var defaultDoubleSpace = 18.height;

  //? Page by Page Constant Values

  //*Daily Goals Widget Constants
  //Daily Goals Widget Height
  static const double dailyGoalsWidgetHeiht = 225;
  static const double goalStatusWidgetHeight = 45;
}

const l1 = 10000;
const l2 = 30000;
const l3 = 50000;
const l4 = 70000;
const l5 = 80000;
const l6 = 100000;
const l7 = 110000;
const l8 = 130000;

final Map<String, dynamic> pointsLevel = {
  'l1': l1,
  'l2': l2,
  'l3': l3,
  'l4': l4,
  'l5': l5,
  'l6': l6,
  'l7': l7,
  'l8': l8,
};

final Map<String, dynamic> pointsAndLevels = {
  'Rookie': {'points': l1, 'level': 'Rookie', 'next': 'Unstoppable'},
  'Unstoppable': {'points': l2, 'level': 'Unstoppable', 'next': 'Pro+'},
  'Pro+': {'points': l3, 'level': 'Pro+', 'next': 'Mastermind'},
  'Mastermind': {'points': l4, 'level': 'Mastermind', 'next': 'Genius'},
  'Genius': {'points': l5, 'level': 'Genius', 'next': 'Sigma'},
  'Sigma': {'points': l6, 'level': 'Sigma', 'next': 'Aura Activated'},
  'Aura Activated': {
    'points': l7,
    'level': 'Aura Activated',
    'next': 'Cosmic Aura',
  },
  'Cosmic Aura': {
    'points': l8,
    'level': 'Cosmic Aura',
    'next': 'Infinite Aura',
  },
  'Infinite Aura': {
    'points': 999999,
    'level': 'Infinite Aura',
    'next': 'Infinite Aura',
  },
};
