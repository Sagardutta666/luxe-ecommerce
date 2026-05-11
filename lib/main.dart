import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'state/shop_state.dart';
import 'widgets/theme_reveal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: shopState,
      builder: (context, _) {
        return MaterialApp(
          title: 'Luxe',
          debugShowCheckedModeBanner: false,
          themeMode: shopState.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            fontFamily: 'Inter',
            scaffoldBackgroundColor: const Color(0xFFFAFAF8),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFC8962A),
              primary: const Color(0xFFC8962A),
              surface: const Color(0xFFFAFAF8),
              onSurface: const Color(0xFF1A1A1A),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Color(0xFF1A1A1A)),
            ),
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            fontFamily: 'Inter',
            scaffoldBackgroundColor: const Color(0xFF0C0C0E),
            colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: const Color(0xFFC8962A),
              primary: const Color(0xFFC8962A),
              surface: const Color(0xFF161618),
              onSurface: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),

          // RepaintBoundary wraps the full themed tree so the reveal
          // animation can capture it before the theme switches.
          builder: (context, child) => RepaintBoundary(
            key: themeRevealBoundaryKey,
            child: child!,
          ),

          home: const SplashScreen(),
        );
      },
    );
  }
}
