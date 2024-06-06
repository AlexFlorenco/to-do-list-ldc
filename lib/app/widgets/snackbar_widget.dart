import 'package:flutter/material.dart';

import '../core/singletons/app_colors.dart';

class SnackbarWidget extends SnackBar {
  SnackbarWidget({
    super.key,
    required String message,
    required BuildContext context,
  }) : super(
          duration: const Duration(seconds: 2),
          content: SizedBox(
            height: 32,
            child: Row(
              children: [
                Icon(Icons.info,
                    color: MediaQuery.platformBrightnessOf(context) ==
                            Brightness.light
                        ? AppColor.light
                        : AppColor.lightDark),
                const SizedBox(width: 8),
                Text(
                  message,
                  style: TextStyle(
                      color: MediaQuery.platformBrightnessOf(context) ==
                              Brightness.light
                          ? AppColor.light
                          : AppColor.lightDark,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          backgroundColor: AppColor.success,
          behavior: SnackBarBehavior.fixed,
          closeIconColor:
              MediaQuery.platformBrightnessOf(context) == Brightness.light
                  ? AppColor.light
                  : AppColor.lightDark,
          showCloseIcon: true,
        );
}
