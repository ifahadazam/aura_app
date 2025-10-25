import 'package:flutter/widgets.dart';

abstract class Validation<T> {
  const Validation();

  String? validate(BuildContext context, T? value);
}
