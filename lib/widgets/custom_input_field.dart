import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomInputField extends StatelessWidget {
  final TextInputType? textType;
  final Function? validator;
  final TextEditingController controller;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  const CustomInputField({super.key, this.textType, this.validator, required this.controller, required this.obscureText, this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        height: 45,
        child: TextFormField(
            style: AppTheme.commonText(Colors.white, 18),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            keyboardType: textType,
            controller: controller,
            obscureText: obscureText,
            inputFormatters: inputFormatters // Only numbers can be entered
            ),
      ),
    );
  }
}
