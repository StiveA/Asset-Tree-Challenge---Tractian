import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'constants/app_colors.dart';

void main() {
  runApp(const AssetTreeApp());
}

class AssetTreeApp extends StatelessWidget {
  const AssetTreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors().appColors;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asset Tree App',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors['light_blue'],
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}
