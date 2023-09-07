import 'dart:async';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:worbbing/pages/main_page.dart';
import 'package:worbbing/pages/registration_page.dart';
import 'package:worbbing/pages/splash_page.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late StreamSubscription _intentDataStreamSubscription;
  String _extractedText = "";
  Widget rootPage = AppSplashPage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String? value) {
      if (value != null) {
        print('original text : $value');
        if (value.split("\"").length > 2) {
          _extractedText = value.split("\"")[1];
        } else {
          _extractedText = value;
        }
        final englishRegex = RegExp(r'^[A-Za-z ]+$');
        print('input text : \'$_extractedText\'');
        // extractedText is not null & english only
        if (_extractedText == '' && !englishRegex.hasMatch(_extractedText)) {
          return;
        }
      }
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (value != null) {
        setState(() {
          _extractedText = value;
        });
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      debugPrint('paused');
      // アプリが paused 中
    } else if (state == AppLifecycleState.resumed) {
      debugPrint('resumed');
      if (_extractedText != '') {
        Navigator.pushReplacementNamed(
          context,
          '/registration',
          arguments: _extractedText,
        );
      }

      // アプリが resumed 中
    } else if (state == AppLifecycleState.inactive) {
      debugPrint('inactive');

      // アプリが inactive 中
    } else if (state == AppLifecycleState.detached) {
      debugPrint('detached');

      // アプリが detached 中
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      // home: ConfigPage(),
      home: AppSplashPage(),
      routes: {
        '/splash': (context) => AppSplashPage(),
        '/main': (context) => const MainPage(),
        '/registration': (context) =>
            RegistrationPage(sharedText: _extractedText),
      },
    );
  }
}
