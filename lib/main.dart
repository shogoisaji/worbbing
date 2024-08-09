import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:worbbing/domain/usecases/app/first_launch_usecase.dart';
import 'package:worbbing/providers/app_language_state_provider.dart';
import 'package:worbbing/providers/router_path_provider.dart';
import 'package:worbbing/application/utils/package_info_utils.dart';
import 'package:worbbing/data/repositories/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/routes/router.dart';
import 'package:worbbing/l10n/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  late final PackageInfo packageInfo;
  late final SharedPreferences sharedPreferences;

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

  await (
    Future(() async {
      packageInfo = await PackageInfo.fromPlatform();
    }),
    Future(() async {
      sharedPreferences = await SharedPreferences.getInstance();
    }),
    Future(() async {
      tz.initializeTimeZones();
      final currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
      print(currentTimeZone);
    }),

    /// 縦固定
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]),

    /// システムUIを上部に表示
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),

    /// admobを初期化
    MobileAds.instance.initialize(),

    /// 起動時の通知とATTのポップアップ
    initializeNotificationsAndATT(),
  ).wait;

  const app = MyApp();
  final scope = ProviderScope(
    overrides: [
      sharedPreferencesRepositoryProvider
          .overrideWithValue(SharedPreferencesRepository(sharedPreferences)),
      packageInfoUtilsProvider.overrideWithValue(PackageInfoUtils(packageInfo)),
    ],
    child: app,
  );
  runApp(MaterialApp(
    home: scope,
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLanguage = ref.watch(appLanguageStateProvider);

    void handleRouteChange() {
      // UI描画中だとエラーになるので、描画後に処理
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 現在のRouteMatchListを取得
        final config = router.routerDelegate.currentConfiguration;

        // RouteMatchListから各種情報を取得
        final path = config.last.matchedLocation; // stack最後=現在のパス
        ref.read(routerPathProvider.notifier).setPathState(path);
      });
    }

    useEffect(() {
      // 初期化時にリスナーへ追加
      router.routerDelegate.addListener(handleRouteChange);

      /// 初回起動時
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(firstLaunchUsecaseProvider).checkFirstLaunch(context);
      });

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
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      locale: appLanguage.locale,
    );
  }
}
