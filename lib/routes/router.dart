import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/presentation/pages/detail_page.dart';
import 'package:worbbing/presentation/pages/ebbinghaus_page.dart';
import 'package:worbbing/presentation/pages/home_page.dart';
import 'package:worbbing/presentation/pages/notice_page.dart';
import 'package:worbbing/presentation/pages/settings_page.dart';
import 'package:worbbing/presentation/pages/splash_page.dart';

class PagePath {
  static const home = '/';
  static const splash = '/splash';
  static const settings = '/settings';
  static const notice = '/notice';
  static const detail = '/detail';
  static const ebbinghaus = '/ebbinghaus';
  static const license = '/license';
  static const registration = 'registration';
}

GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: PagePath.home,
      pageBuilder: (BuildContext context, GoRouterState state) =>
          CustomTransitionPage<void>(
        transitionDuration: const Duration(milliseconds: 300),
        key: state.pageKey,
        child: const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: PagePath.splash,
      builder: (BuildContext context, GoRouterState state) {
        return const AppSplashPage();
      },
    ),
    GoRoute(
      path: PagePath.notice,
      builder: (BuildContext context, GoRouterState state) {
        return const NoticePage();
      },
    ),
    GoRoute(
      path: PagePath.settings,
      builder: (BuildContext context, GoRouterState state) {
        return const SettingsPage();
      },
    ),
    GoRoute(
      path: PagePath.detail,
      builder: (BuildContext context, GoRouterState state) {
        return DetailPage(wordModel: state.extra as WordModel);
      },
    ),
    GoRoute(
      path: PagePath.ebbinghaus,
      builder: (BuildContext context, GoRouterState state) {
        return const EbbinghausPage();
      },
    ),
    GoRoute(
      path: PagePath.license,
      builder: (BuildContext context, GoRouterState state) {
        return const LicensePage(applicationName: "Worbbing");
      },
    ),
  ],
  initialLocation: PagePath.splash,
  // refreshListenable: listenable,
);
