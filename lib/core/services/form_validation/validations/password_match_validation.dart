import 'package:flutter/widgets.dart';
import 'package:life_goal/core/services/form_validation/validation.dart';

/// a validation that checks if the [value] confirm pass is a equal to new password.
class PasswordMatchValidation extends Validation<String> {
  const PasswordMatchValidation({required this.confirmPassController});

  final TextEditingController confirmPassController;

  @override
  String? validate(BuildContext context, String? value) {
    if (value?.isEmpty == true) return null;

    if (value != confirmPassController.text) {
      return 'Password Not Matched';
    }

    return null;
  }
}
