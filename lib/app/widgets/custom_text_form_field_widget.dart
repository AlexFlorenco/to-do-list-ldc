import 'package:flutter/material.dart';

import '../core/singletons/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Function onPressed;
  final Function onSubmit;
  final String label;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.onPressed,
    required this.onSubmit,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value == "") {
          return 'Campo obrigatório';
        }
        return null;
      },
      controller: controller,
      onFieldSubmitted: (value) => onSubmit(),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(width: 2, color: AppColor.primary)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: () => onPressed(), icon: const Icon(Icons.close)),
        label: Text(label),
      ),
    );
  }
}
