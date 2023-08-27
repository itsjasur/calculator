import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';

Color myCustomColor = const Color(0xFF000000);

void main() {
  runApp(const MyApp());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
        scaffoldBackgroundColor: myCustomColor,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green),
        useMaterial3: true,
        appBarTheme: AppBarTheme(backgroundColor: myCustomColor),
        snackBarTheme: SnackBarThemeData(
          width: screenWidth * 0.7,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white24,
          contentTextStyle: TextStyle(
            fontSize: screenWidth * 0.035,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
