import 'package:flutter/widgets.dart';
import 'package:life_goal/core/services/form_validation/validation.dart';

/// a validation that checks if the value is a valid email.
class EmailValidation extends Validation<String> {
  const EmailValidation();

  @override
  String? validate(BuildContext context, String? value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (value == null) return null;
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
