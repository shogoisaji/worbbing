import 'package:flutter/material.dart';
import 'package:worbbing/pages/main_page.dart';
import 'package:worbbing/pages/splash_page.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: AppSplashPage(),
      routes: {
        '/splash': (context) => AppSplashPage(),
        '/main': (context) => const MainPage(),
      },
    );
  }
}
