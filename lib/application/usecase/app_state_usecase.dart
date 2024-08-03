import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:worbbing/presentation/widgets/demo.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_repository.dart';

class AppStateUsecase extends WidgetsBindingObserver {
  AppStateUsecase() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      removeOverlay();
    }
  }

  bool isFirst() {
    return SharedPreferencesRepository()
            .fetch<bool>(SharedPreferencesKey.isFirst) ??
        true;
  }

  Future<void> doneFirst() async {
    await SharedPreferencesRepository()
        .save<bool>(SharedPreferencesKey.isFirst, false);
  }

  bool isEnableSlideHint() {
    return SharedPreferencesRepository()
            .fetch<bool>(SharedPreferencesKey.isEnableSlideHint) ??
        true;
  }

  Future<void> switchEnableSlideHint(bool value) async {
    await SharedPreferencesRepository()
        .save<bool>(SharedPreferencesKey.isEnableSlideHint, value);
  }

  OverlayEntry? overlay;

  void showDemo(BuildContext context) {
    OverlayEntry createOverlayEntry() {
      return OverlayEntry(
        builder: (context) {
          return Stack(
            children: [
              const DemoPage(),
              Align(
                alignment: const Alignment(0.0, 0.85),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    AppStateUsecase().doneFirst();
                    removeOverlay();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 25,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    overlay = createOverlayEntry();
    Overlay.of(context).insert(overlay!);
  }

  void removeOverlay() {
    overlay?.remove();
    overlay = null;
    WidgetsBinding.instance.removeObserver(this);
  }
}
