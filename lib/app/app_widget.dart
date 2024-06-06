import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lista_de_tarefas/app/core/singletons/app_colors.dart';

import 'pages/todo_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        useMaterial3: false,
        brightness: MediaQuery.platformBrightnessOf(context) == Brightness.dark
            ? Brightness.dark
            : Brightness.light,
        checkboxTheme:
            CheckboxThemeData(checkColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return AppColor.light;
            } else {
              return MediaQuery.platformBrightnessOf(context) ==
                      Brightness.light
                  ? AppColor.light
                  : AppColor.lightDark;
            }
          },
        ), fillColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.selected)) {
              return MediaQuery.platformBrightnessOf(context) ==
                      Brightness.light
                  ? AppColor.primary
                  : AppColor.primaryDark;
            } else {
              return MediaQuery.platformBrightnessOf(context) ==
                      Brightness.light
                  ? AppColor.light
                  : AppColor.lightDark;
            }
          },
        )),
      ),
      home: const ToDoPage(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt')],
      debugShowCheckedModeBanner: false,
    );
  }
}
