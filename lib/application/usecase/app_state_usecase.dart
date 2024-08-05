import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:worbbing/presentation/widgets/demo.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_repository.dart';

part 'app_state_usecase.g.dart';

@riverpod
class AppStateUsecase extends _$AppStateUsecase with WidgetsBindingObserver {
  @override
  AppStateUsecase build() {
    WidgetsBinding.instance.addObserver(this);
    return this;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      removeOverlay();
    }
  }

  bool isFirst() {
    return ref
            .read(sharedPreferencesRepositoryProvider)
            .fetch<bool>(SharedPreferencesKey.isFirst) ??
        true;
  }

  Future<void> doneFirst() async {
    await ref
        .read(sharedPreferencesRepositoryProvider)
        .save<bool>(SharedPreferencesKey.isFirst, false);
  }

  bool isEnableSlideHint() {
    return ref
            .read(sharedPreferencesRepositoryProvider)
            .fetch<bool>(SharedPreferencesKey.isEnableSlideHint) ??
        true;
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
                    doneFirst();
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
