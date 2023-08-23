import 'package:calculator/home.dart';
import 'package:flutter/material.dart';

Color myCustomColor = const Color(0xFF0E0E0E);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green),

        useMaterial3: true,
        primaryColor: Colors.red,
        appBarTheme: AppBarTheme(
          backgroundColor: myCustomColor,
        ),
        scaffoldBackgroundColor: myCustomColor,

        snackBarTheme: SnackBarThemeData(
          width: screenWidth * 0.7,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white24,
          contentTextStyle: TextStyle(
            fontSize: screenWidth * 0.038,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        // textTheme: const TextTheme(
        //   bodyMedium: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 30,
        //     color: Colors.white,
        //   ),
        //   bodyLarge: TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 30,
        //     color: Colors.white,
        //   ),
        // ),
      ),
      home: const HomePage(),
    );
  }
}
