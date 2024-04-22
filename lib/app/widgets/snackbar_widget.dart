import 'package:flutter/material.dart';

import '../core/singletons/app_colors.dart';

class SnackbarWidget extends SnackBar {
  SnackbarWidget({
    super.key,
    required String message,
  }) : super(
          duration: const Duration(seconds: 2),
          content: SizedBox(
            height: 32,
            child: Row(
              children: [
                const Icon(Icons.info, color: AppColor.light),
                const SizedBox(width: 8),
                Text(
                  message,
                  style: const TextStyle(color: AppColor.light, fontSize: 16),
                ),
              ],
            ),
          ),
          backgroundColor: AppColor.success,
          behavior: SnackBarBehavior.fixed,
          closeIconColor: AppColor.light,
          showCloseIcon: true,
        );
}
