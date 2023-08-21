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
