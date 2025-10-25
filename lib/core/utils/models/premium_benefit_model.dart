import 'package:flutter/cupertino.dart';

class PremiumBenefitModel {
  final String title;
  final String subTitle;
  final IconData iconData;
  PremiumBenefitModel({
    required this.title,
    required this.subTitle,
    required this.iconData,
  });
}

List<PremiumBenefitModel> premiumBenefits(BuildContext context) {
  return [
    PremiumBenefitModel(
      title: 'Benefit One',
      subTitle: 'Benefit One',
      iconData: CupertinoIcons.person_2_fill,
    ),
    PremiumBenefitModel(
      title: 'Benefit One',
      subTitle: 'Benefit One',
      iconData: CupertinoIcons.person_2_fill,
    ),
    PremiumBenefitModel(
      title: 'Benefit One',
      subTitle: 'Benefit One',
      iconData: CupertinoIcons.person_2_fill,
    ),
    PremiumBenefitModel(
      title: 'Benefit One',
      subTitle: 'Benefit One',
      iconData: CupertinoIcons.person_2_fill,
    ),
  ];
}
