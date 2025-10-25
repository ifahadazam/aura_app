import 'package:flutter/material.dart';

// extension PaddingSymmetric on Padding {
//   EdgeInsets symmetricValue({double? vertical, double? horizontle}) {
//     return EdgeInsets.symmetric(
//         vertical: vertical ?? 0, horizontal: horizontle ?? 0);
//   }
// }

extension PaddingAll on int {
  EdgeInsets get all => EdgeInsets.all(toDouble());
}

extension PaddingLeftOnly on int {
  EdgeInsets get left => EdgeInsets.only(
        left: toDouble(),
      );
}

extension PaddingHorizontleOnly on int {
  EdgeInsets get horizontle => EdgeInsets.symmetric(
        horizontal: toDouble(),
      );
}

extension PaddingVerticalOnly on int {
  EdgeInsets get vertical => EdgeInsets.symmetric(
        vertical: toDouble(),
      );
}

extension PaddingRightOnly on int {
  EdgeInsets get right => EdgeInsets.only(
        right: toDouble(),
      );
}

extension PaddingTopOnly on int {
  EdgeInsets get top => EdgeInsets.only(
        top: toDouble(),
      );
}

extension PaddingBottomOnly on int {
  EdgeInsets get bottom => EdgeInsets.only(
        bottom: toDouble(),
      );
}
