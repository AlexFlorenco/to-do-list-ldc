import 'package:flutter/material.dart';

import 'app/app_widget.dart';
import 'app/core/singletons/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();

  runApp(const MyApp());
}
