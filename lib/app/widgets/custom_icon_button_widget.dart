import 'package:flutter/material.dart';

import '../core/singletons/app_colors.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Function onPressed;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.primary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        highlightColor: AppColor.transparent,
        splashColor: AppColor.transparent,
        onPressed: () => onPressed(),
        icon: Icon(icon, size: 30),
        color: AppColor.light,
      ),
    );
  }
}
