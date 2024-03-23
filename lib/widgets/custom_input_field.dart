import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextInputType? textType;
  final Function? validator;
  final TextEditingController controller;
  final bool obscureText;

  const CustomInputField(
      {super.key,
      this.textType,
      this.validator,
      required this.controller,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        height: 45,
        child: TextFormField(
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          keyboardType: textType,
          controller: controller,
          obscureText: obscureText,
        ),
      ),
    );
  }
}
