import 'package:flutter/material.dart';

import '../core/singletons/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Function onPressed;
  final Function onSubmit;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final String label;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.onPressed,
    required this.onSubmit,
    this.onChanged,
    this.focusNode,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value == "") {
          return 'Campo obrigatório';
        } else if (value.trim() == "") {
          return 'Tarefa inválida';
        }
        return null;
      },
      focusNode: focusNode,
      controller: controller,
      onFieldSubmitted: (value) => onSubmit(),
      onChanged: onChanged,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(
              width: 2,
              color:
                  MediaQuery.platformBrightnessOf(context) == Brightness.light
                      ? AppColor.primary
                      : AppColor.primaryDark,
            )),
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
