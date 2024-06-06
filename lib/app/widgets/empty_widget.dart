import 'package:flutter/material.dart';

import '../core/singletons/app_colors.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_state.png',
            opacity: const AlwaysStoppedAnimation(0.4),
          ),
          const SizedBox(height: 10),
          Text(
            'Nenhum resultado encontrado.\nExperimente adicionar uma tarefa.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  MediaQuery.platformBrightnessOf(context) == Brightness.light
                      ? AppColor.semiTransparent
                      : AppColor.shade,
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
