import 'package:life_goal/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TypographyTheme {
  TypographyTheme._();
  //* Auth
  // AppBar
  // Auth Title
  // Auth Button Text
  // Auth simple text (Forgot Password,Don't have an account)
  // Auth AppBar Title Style
  static TextStyle authAppBarTitleStyle({double? fontSize}) {
    return TextStyle(
      fontFamily: 'Poppins',
      color: AppColors.themeWhite,
      letterSpacing: 2.3,
      fontSize: fontSize ?? 30,
      fontWeight: FontWeight.w600,
    );
  }

  // Auth AppBar Sub-Title Style
  static TextStyle authAppBarSubTitleStyle() {
    return const TextStyle(
      fontFamily: 'Poppins',
      color: AppColors.themeWhite,
      fontSize: 19,
      fontWeight: FontWeight.w400,
    );
  }

  //Auth Title Style (Sign UP/ Sign In)
  static TextStyle authPageTitleStyle() {
    return const TextStyle(
      fontFamily: 'Poppins',
      color: AppColors.blackColor,
      fontSize: 32,
      fontWeight: FontWeight.w700,
    );
  }

  //Sign In With Google Text Style
  static TextStyle authButtonTextStyle({Color? color}) {
    return TextStyle(
      fontFamily: 'Poppins',
      color: color ?? AppColors.blackColor,
      fontWeight: FontWeight.w500,
      fontSize: 17,
    );
  }

  //Auth Simple text style.
  static TextStyle authSimpleTextStyle({FontWeight? fontWeight}) {
    return TextStyle(
      // fontFamily: 'Poppins',
      color: AppColors.lightBlackColor,
      fontWeight: fontWeight,
      fontSize: 16,
    );
  }

  //*Home
  //AppBar
  //Learning of thr Day (Tile,Subtitle)
  //Daily Goal(Quotes,Info Text)

  // Home AppBar Title Style
  static TextStyle homeAppBarTitleStyle() {
    return const TextStyle(
      // fontFamily: 'Roboto',
      color: AppColors.themeBlack,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    );
  }

  // Home AppBar Sub-Title Style
  static TextStyle homeAppBarSubTitleStyle(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Poppins',
      color: AppColors.themeWhite,
      fontSize: 15,
      fontWeight: FontWeight.w400,
    );
  }

  //* Common Text Styles

  //Title With White Color
  static TextStyle simpleTitleStyle({required double fontSize}) {
    return TextStyle(
      fontFamily: 'Poppins',
      color: AppColors.themeBlack,
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
    );
  }

  //Sub Title With White Color
  static TextStyle simpleSubTitleStyle({required double fontSize}) {
    return TextStyle(
      fontFamily: 'Poppins',
      color: AppColors.themeBlack,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
    );
  }

  //Action Card title
  static TextStyle actionCardTitleStyle(Color? featureColor) {
    return const TextStyle(
      fontFamily: 'Poppins',
      color: AppColors.themeWhite,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    );
  }

  //Action Card sub title
  static TextStyle actionCardSubTitleStyle(Color? featureColor) {
    return const TextStyle(
      fontFamily: 'Poppins',
      color: AppColors.themeWhite,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
  }

  //Action Button title
  static TextStyle actionButtonTitleStyle(Color? borderButtonTextColor) {
    return TextStyle(
      fontFamily: 'Poppins',
      color: borderButtonTextColor ?? AppColors.themeWhite,
      fontWeight: FontWeight.w500,
      fontSize: 15,
    );
  }

  // Quranic Quote Arabic Text Style
  static TextStyle quoteRefTextStyle() {
    return const TextStyle(
      fontFamily: 'Poppins',
      color: AppColors.blackColor,
      fontSize: 16,
    );
  }

  //* Settings
  // Setting Title Text
  // Account Setting (User name and email text)
  // Contact Us (Title and subtitle text)
  // Privacy Policy (Title and Description text)
  // Change Name,Reset Account, Delete Account
  // -- Title and Subtitle text

  //Setting Tile Title Style
  static TextStyle settingTileTitle(double fontSize) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      letterSpacing: 0.7,
      color: AppColors.themeWhite,
      fontSize: fontSize,
    );
  }

  // Theme Title (Bottom Sheets and Dialogs)
  static TextStyle themeTitleStyle(double fontSize) {
    return TextStyle(
      color: AppColors.themeBlack,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  // Theme Sub Title (Bottom Sheets and Dialogs)
  static TextStyle themeSubTitleStyle(double fontSize) {
    return TextStyle(
      // fontFamily: 'Poppins',
      color: AppColors.themeWhite,
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
    );
  }

  // Primary Title (TextStyle with Color opposite background such as Black and White)
  static TextStyle primaryTitleStyle(double fontSize) {
    return TextStyle(
      fontFamily: 'Poppins',
      color: AppColors.themeWhite,
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
    );
  }

  // Primary Sub Title (Bottom Sheets and Dialogs)
  static TextStyle primarySubTitleStyle(double fontSize) {
    return TextStyle(
      color: AppColors.themeWhite,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
    );
  }

  // Internal Pages AppBar (Dua Page, Learn Page etc)
  static TextStyle internalAppBarTitleStyle(Color color) {
    return TextStyle(
      fontFamily: 'Poppins',
      color: color,
      fontWeight: FontWeight.w600,
      fontSize: 17,
    );
  }

  // Internal Pages AppBar (Dua Page, Learn Page etc)
  static TextStyle messageDialogTextStyle(
    double fontSize, {
    required bool isSuccess,
  }) {
    return TextStyle(
      // fontFamily: 'Poppins',
      color: isSuccess ? AppColors.greenColor : AppColors.redColor,
      fontSize: fontSize,
    );
  }
}





//* Learn
// Progress Widget Text
// Quotes, Info Decks Title text
// Internal AppBar Title
// Quote Card (Quote Title and Ref text)
// Info Card (Ques and Ans Text)
// Quranic Duasv (Title,Dua,Translation,Reference text)
// Liked Card (Title and Subtile text)



//* Common
// Action Button text
// Action Card Title and Subtitle
// TextFormField hint text
// tab Bar text
