import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_goal/core/constants/app_colors.dart';
import 'package:life_goal/core/constants/app_constants.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    super.key,
    required this.textController,
    required this.hintText,
    required this.obscureText,
    required this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.validator,
    this.focusNode,
    this.errorMsg,
    this.onChanged,
    this.maxLines,
    this.themeColor,
    this.isBorderVisible,
    this.inputFormatters,
  });
  final TextEditingController textController;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? errorMsg;
  final String? Function(String?)? onChanged;
  final int? maxLines;
  final Color? themeColor;
  final bool? isBorderVisible;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines ?? 1,
      onChanged: onChanged,
      validator: validator,
      controller: textController,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      onTap: onTap,
      inputFormatters: inputFormatters,
      onTapOutside: (event) {
        focusNode?.unfocus();
        // FocusManager.instance.primaryFocus?.unfocus();
      },
      textInputAction: TextInputAction.next,
      style: TextStyle(
        // fontFamily: 'RobotoSlab',
        color: themeColor ?? AppColors.themeWhite,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          // fontFamily: 'RobotoSlab',
          color:
              themeColor?.withAlpha(128) ?? AppColors.themeWhite.withAlpha(128),
        ),
        errorText: errorMsg,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        suffixIconColor: WidgetStateColor.resolveWith((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.focused)) {
            return themeColor ?? AppColors.themeWhite;
          }
          return themeColor?.withAlpha(217) ??
              AppColors.themeWhite.withAlpha(217);
        }),
        prefixIconColor: WidgetStateColor.resolveWith((
          Set<WidgetState> states,
        ) {
          if (states.contains(WidgetState.focused)) {
            return themeColor ?? AppColors.themeWhite;
          }
          return themeColor?.withAlpha(217) ??
              AppColors.themeWhite.withAlpha(217);
        }),
        focusedErrorBorder: isBorderVisible ?? true
            ? OutlineInputBorder(
                borderRadius: AppConstants.widgetMediumBorderRadius,
                borderSide: const BorderSide(
                  color: AppColors.redColor,
                  width: 1.35,
                ),
              )
            : null,
        errorBorder: isBorderVisible ?? true
            ? OutlineInputBorder(
                borderRadius: AppConstants.widgetMediumBorderRadius,
                borderSide: const BorderSide(color: AppColors.redColor),
              )
            : null,
        enabledBorder: isBorderVisible ?? true
            ? OutlineInputBorder(
                borderRadius: AppConstants.widgetMediumBorderRadius,
                borderSide: BorderSide(
                  color:
                      themeColor?.withAlpha(217) ??
                      AppColors.themeWhite.withAlpha(217),
                ),
              )
            : null,
        focusedBorder: isBorderVisible ?? true
            ? OutlineInputBorder(
                borderRadius: AppConstants.widgetMediumBorderRadius,
                borderSide: BorderSide(
                  color: themeColor ?? AppColors.themeWhite,
                  width: 1.35,
                ),
              )
            : null,
      ),
    );
  }
}
