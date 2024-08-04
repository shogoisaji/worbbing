import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:worbbing/application/state/router_path_state.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/routes/router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// shared_preferencesの初期化
  await SharedPreferencesRepository.init();

  /// 通知用のタイムゾーンの初期化
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation("Asia/Tokyo"));

  /// 広告の初期化
  MobileAds.instance.initialize();

  /// 画面の向きを固定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  /// 上部にシステムUIを表示
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  /// 通知&ATT許可
  initializeNotificationsAndATT();

  const app = MyApp();
  const scope = ProviderScope(child: app);
  runApp(const MaterialApp(
    home: scope,
    debugShowCheckedModeBanner: false,
  ));
}

Future<void> initializeNotificationsAndATT() async {
  /// 通知許可
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ),

    /// 通知をタップした時の処理
    ///
    // onDidReceiveNotificationResponse: (NotificationResponse details) {
    //   if (details.payload == 'notice_tap') {
    //     print('notice id : ${details.id}');
    //   }
    // },
  );

  /// ATTの許可
  final status = await AppTrackingTransparency.trackingAuthorizationStatus;
  if (status == TrackingStatus.notDetermined) {
    /// milliseconds: 200 -> could not display ATT permission.
    await Future.delayed(const Duration(milliseconds: 500));
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleRouteChange() {
      // UI描画中だとエラーになるので、描画後に処理
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 現在のRouteMatchListを取得
        final config = router.routerDelegate.currentConfiguration;

        // RouteMatchListから各種情報を取得
        final path = config.last.matchedLocation; // stack最後=現在のパス
        ref.read(routerPathStateProvider.notifier).setPathState(path);
      });
    }

    useEffect(() {
      // 初期化時にリスナーへ追加
      router.routerDelegate.addListener(handleRouteChange);
      return () {
        // dispose時にリスナーから削除
        router.routerDelegate.removeListener(handleRouteChange);
      };
    }, const []);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: MyTheme.lemon,
        fontFamily: 'SawarabiGothic',
        textTheme: TextTheme(
            bodyMedium: TextStyle(color: MyTheme.lemon),
            headlineSmall: TextStyle(color: MyTheme.lemon)),
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
