import 'package:flutter/widgets.dart';
import 'package:life_goal/core/services/form_validation/validation.dart';

/// a validation that checks if the value is a valid password.
class PasswordValidation extends Validation<String> {
  const PasswordValidation({
    this.minLength = 8,
    this.number = false,
    this.upperCase = false,
    this.specialChar = false,
    this.lowerCase = false,
  });

  final int minLength;
  final bool number;
  final bool upperCase;
  final bool specialChar;
  final bool lowerCase;

  static final _numberRegex = RegExp(r'[0-9]');
  static final _upperCaseRegex = RegExp(r'[A-Z]');
  static final _lowerCaseRegex = RegExp(r'[a-z]');
  static final _specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  @override
  String? validate(BuildContext context, String? value) {
    if (value?.isEmpty == true) return null;

    if (value!.length < minLength) {
      return 'Must be $minLength char. long';
    }

    if (number && !_numberRegex.hasMatch(value)) {
      return 'Must have a number';
    }

    if (upperCase && !_upperCaseRegex.hasMatch(value)) {
      return 'Must have an upper case';
    }

    if (specialChar && !_specialCharRegex.hasMatch(value)) {
      return 'Must have a special char.';
    }
    if (lowerCase && !_lowerCaseRegex.hasMatch(value)) {
      return 'Must have an lower case';
    }

    return null;
  }
}
