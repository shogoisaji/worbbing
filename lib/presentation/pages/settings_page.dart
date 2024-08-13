import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:worbbing/domain/entities/translate_language.dart';
import 'package:worbbing/domain/entities/word_model.dart';
import 'package:worbbing/l10n/l10n.dart';
import 'package:worbbing/presentation/view_model/setting_page_view_model.dart';
import 'package:worbbing/presentation/widgets/ad_banner.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/language_selector.dart';
import 'package:worbbing/presentation/widgets/notice_block.dart';
import 'package:worbbing/providers/demo_manager_provider.dart';
import 'package:worbbing/providers/app_language_state_provider.dart';
import 'package:worbbing/routes/router.dart';

const double langContainerWidth = 140;

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(settingPageViewModelProvider);
    final notifier = ref.read(settingPageViewModelProvider.notifier);
    final appLanguageState = ref.read(appLanguageStateProvider);

    final defaultLangGroup = AutoSizeGroup();

    final l10n = L10n.of(context)!;

    const Widget contentSpacer = SizedBox(height: 22);
    final contentWidth =
        (MediaQuery.of(context).size.width * 0.9).clamp(100.0, 500.0);

    void handleSelectAppLang(AppLanguage lang) {
      notifier.updateAppLanguage(lang);
    }

    Future<void> privacyURL() async {
      final Uri url = Uri.parse('https://worbbing.vercel.app/privacy-policy');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        return;
      }
    }

    Future<void> termsOfUseURL() async {
      final Uri url = Uri.parse('https://worbbing.vercel.app/terms-of-use');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        return;
      }
    }

    Future<void> inquiryURL() async {
      final Uri url = Uri.parse('https://worbbing.vercel.app/inquiry');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        return;
      }
    }

    void handleTapLicense() {
      context.push(PagePath.license);
    }

    void handleTapDemo() {
      ref.read(demoManagerProvider.notifier).showDemo(context);
    }

    void handleTapForgettingCurve() {
      context.push(PagePath.ebbinghaus);
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: MyTheme.bgGradient,
          ),
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              title: Image.asset(
                'assets/images/settings.png',
                width: 150,
              ),
              leading: InkWell(
                  child: Align(
                    child: Image.asset(
                      'assets/images/custom_arrow.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.pop();
                  }),
              backgroundColor: Colors.transparent,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 26,
                              ),
                              Container(
                                width: contentWidth,
                                padding: const EdgeInsets.only(
                                    left: 0, right: 0, top: 4, bottom: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 0.5),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 220,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.white, width: 1)),
                                      ),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 3.0),
                                              child: mediumText(
                                                  l10n.total_words,
                                                  Colors.white),
                                            ),
                                            // total words
                                            titleText(
                                                viewModel.totalWords != null
                                                    ? viewModel.totalWords
                                                        .toString()
                                                    : "",
                                                MyTheme.orange,
                                                36),
                                          ]),
                                    ),
                                    SizedBox(
                                      height: 120,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children:
                                            noticeDurationList.map((duration) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              left: duration == 1 ? 16 : 3,
                                              right: duration == 99 ? 20 : 3,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 55,
                                                  height: 59,
                                                  alignment: const Alignment(
                                                      -0.2, 0.0),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white12,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: noticeBlock(
                                                      34,
                                                      duration,
                                                      MyTheme.lemon,
                                                      false),
                                                ),
                                                const SizedBox(height: 3),
                                                Container(
                                                  width: 55,
                                                  height: 40,
                                                  alignment: const Alignment(
                                                      0.0, -0.4),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white12,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      bottomRight:
                                                          Radius.circular(10),
                                                    ),
                                                  ),
                                                  child: mediumText(
                                                      viewModel.noticeCount?[
                                                                  duration]
                                                              ?.toString() ??
                                                          "0",
                                                      Colors.white),
                                                )
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: contentWidth,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 0.5),
                                ),
                                margin:
                                    const EdgeInsets.only(left: 20, right: 20),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 24),
                                child: Column(
                                  children: [
                                    _buildDefaultOriginalLang(
                                      l10n,
                                      context,
                                      viewModel.originalLanguage,
                                      (value) {
                                        notifier.updateOriginalLanguage(value);
                                      },
                                      l10n.default_original_language,
                                      defaultLangGroup,
                                    ),
                                    contentSpacer,
                                    _buildDefaultTranslateLang(
                                      l10n,
                                      context,
                                      viewModel.translateLanguage,
                                      (value) {
                                        notifier.updateTranslateLanguage(value);
                                      },
                                      l10n.default_translate_language,
                                      defaultLangGroup,
                                    ),
                                    contentSpacer,
                                    SlideHintSwitch(
                                        isEnabled: viewModel.enableSlideHint,
                                        onTap: notifier.switchSlideHint,
                                        title: l10n.slide_hint),
                                    contentSpacer,
                                    _buildVolumeSelect(
                                      l10n,
                                      viewModel.speakVolume,
                                      (value) {
                                        HapticFeedback.lightImpact();
                                        notifier.updateSpeakVolume(value);
                                      },
                                    ),
                                    contentSpacer,
                                    _buildLanguageSelect(
                                      l10n,
                                      context,
                                      handleSelectAppLang,
                                      l10n.app_language,
                                      appLanguageState,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: contentWidth,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 0.5),
                                ),
                                margin:
                                    const EdgeInsets.only(left: 20, right: 20),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 24),
                                child: Column(
                                  children: [
                                    _buildUrlLauncher(
                                        privacyURL, l10n.privacy_policy),
                                    contentSpacer,
                                    _buildUrlLauncher(
                                        termsOfUseURL, l10n.terms_of_use),
                                    contentSpacer,
                                    _buildInquiry(inquiryURL, l10n.contact_us),
                                    contentSpacer,
                                    _buildDemo(handleTapDemo, l10n.show_demo),
                                    contentSpacer,
                                    _buildLicense(
                                        handleTapLicense, l10n.license),
                                    // contentSpacer,
                                    // _buildForgettingCurve(
                                    //     handleTapForgettingCurve,
                                    //     l10n.forgetting_curve),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              _buildAppVersion(
                                  viewModel.version ?? "", l10n.version),
                              const SizedBox(
                                height: 50,
                              ),
                            ]),
                      ),
                    ),
                  ),
                  AdBanner(
                    width: MediaQuery.of(context).size.width,
                    shadow: true,
                  )
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildDefaultOriginalLang(
      L10n l10n,
      BuildContext context,
      TranslateLanguage originalLanguage,
      Function(TranslateLanguage) onOriginalSelected,
      String title,
      AutoSizeGroup group) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
              ),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: AutoSizeText(title,
                      group: group,
                      maxLines: 2,
                      style: const TextStyle(
                          height: 1.1,
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => LanguageSelector<TranslateLanguage>(
                title: l10n.original_language,
                color: MyTheme.lemon,
                initialLanguage: originalLanguage,
                onSelect: (dynamic lang) {
                  onOriginalSelected(lang as TranslateLanguage);
                },
                languages: TranslateLanguage.values,
                languageToString: (dynamic lang) {
                  return (lang as TranslateLanguage).upperString;
                },
              ),
            );
          },
          child: Container(
            width: langContainerWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: MyTheme.lemon, width: 0.5),
            ),
            child: Center(
              child: Text(originalLanguage.upperString,
                  style: const TextStyle(
                      height: 1.1,
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultTranslateLang(
      L10n l10n,
      BuildContext context,
      TranslateLanguage translateLanguage,
      Function(TranslateLanguage) onTranslateSelected,
      String title,
      AutoSizeGroup group) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
              ),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: AutoSizeText(title,
                      group: group,
                      maxLines: 2,
                      style: const TextStyle(
                          height: 1.1,
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => LanguageSelector<TranslateLanguage>(
                title: l10n.translate_language,
                color: MyTheme.orange,
                initialLanguage: translateLanguage,
                onSelect: (dynamic lang) {
                  onTranslateSelected(lang as TranslateLanguage);
                },
                languages: TranslateLanguage.values,
                languageToString: (dynamic lang) {
                  return (lang as TranslateLanguage).upperString;
                },
              ),
            );
          },
          child: Container(
            width: langContainerWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: MyTheme.orange, width: 0.5),
            ),
            child: Center(
              child: Text(translateLanguage.upperString,
                  style: const TextStyle(
                      height: 1.1,
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVolumeSelect(
      L10n l10n, double volume, Function(double) onChange) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
              ),
              Expanded(
                child: AutoSizeText(l10n.speak_volume,
                    maxLines: 1,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        SizedBox(
          width: langContainerWidth + 10,
          child: Slider(
            value: volume,
            divisions: 10,
            onChanged: onChange,
            activeColor: MyTheme.lemon,
          ),
        )
      ],
    );
  }

  Widget _buildLanguageSelect(L10n l10n, BuildContext context,
      Function(AppLanguage) onTap, String title, AppLanguage currentLang) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
              ),
              Expanded(
                child: AutoSizeText(title,
                    maxLines: 1,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => LanguageSelector<AppLanguage>(
                title: l10n.app_language,
                color: Colors.white,
                initialLanguage: currentLang,
                onSelect: (dynamic lang) {
                  onTap(lang as AppLanguage);
                },
                languages: AppLanguage.values,
                languageToString: (dynamic lang) {
                  return (lang as AppLanguage).upperString;
                },
              ),
            );
          },
          child: Container(
            width: langContainerWidth,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border:
                  Border.all(color: Colors.white.withOpacity(0.5), width: 0.5),
            ),
            child: Center(
              child: Text(currentLang.upperString,
                  style: const TextStyle(
                      height: 1.1,
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUrlLauncher(VoidCallback onTap, String text) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
          ),
          Expanded(
            child: AutoSizeText(text,
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.open_in_new, color: Colors.white)
        ],
      ),
    );
  }

  Widget _buildInquiry(VoidCallback onTap, String title) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
          ),
          Expanded(
            child: AutoSizeText(title,
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.open_in_new, color: Colors.white)
        ],
      ),
    );
  }

  Widget _buildLicense(VoidCallback onTap, String title) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
          ),
          Expanded(
            child: AutoSizeText(title,
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildDemo(VoidCallback onTap, String title) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
          ),
          Expanded(
            child: AutoSizeText(title,
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildForgettingCurve(VoidCallback onTap, String title) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
          ),
          Expanded(
            child: AutoSizeText(title,
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildAppVersion(String version, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Text(version,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500)),
        )
      ],
    );
  }
}

class SlideHintSwitch extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback onTap;
  final String title;

  const SlideHintSwitch({
    Key? key,
    required this.isEnabled,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  @override
  SlideHintSwitchState createState() => SlideHintSwitchState();
}

class SlideHintSwitchState extends State<SlideHintSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final Tween<double> _scale = Tween<double>(begin: 0.5, end: 2.0);
  final TweenSequence<double> _opacity = TweenSequence<double>([
    TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 3),
    TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 1),
  ]);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SlideHintSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEnabled != oldWidget.isEnabled && widget.isEnabled) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
            ),
            Expanded(
              child: SizedBox(
                height: 40,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      AutoSizeText(widget.title,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500)),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              activeTrackColor: MyTheme.lemon,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.white,
              value: widget.isEnabled,
              onChanged: (value) async {
                HapticFeedback.lightImpact();
                widget.onTap();
              },
            )
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacity
                      .animate(CurvedAnimation(
                          parent: _controller, curve: Curves.easeOut))
                      .value,
                  child: Transform.scale(
                    scale: _scale
                        .animate(CurvedAnimation(
                            parent: _controller, curve: Curves.easeOut))
                        .value,
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Transform.rotate(
                                angle: -0.2,
                                child: SvgPicture.asset(
                                  'assets/svg/good.svg',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Transform.rotate(
                                angle: 0.1,
                                child: SvgPicture.asset(
                                  'assets/svg/bad.svg',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
