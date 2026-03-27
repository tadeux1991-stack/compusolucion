import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const CompusolucionApp());
}

class CompusolucionApp extends StatelessWidget {
  const CompusolucionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compusolución - Innovación Tech',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      home: const HomePage(),
    );
  }
}
