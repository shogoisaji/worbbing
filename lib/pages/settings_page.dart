import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:worbbing/application/usecase/app_state_usecase.dart';
import 'package:worbbing/domain/entities/translate_language.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/view_model/setting_page_state.dart';
import 'package:worbbing/presentation/widgets/ad_banner.dart';
import 'package:worbbing/presentation/widgets/language_dropdown_horizontal.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/notice_block.dart';
import 'package:worbbing/routes/router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(settingPageViewModelProvider);
    final notifier = ref.read(settingPageViewModelProvider.notifier);

    const Widget contentSpacer = SizedBox(height: 22);
    final contentWidth =
        (MediaQuery.of(context).size.width * 0.9).clamp(100.0, 500.0);

    Future<void> privacyURL() async {
      final Uri url = Uri.parse('https://worbbing.vercel.app/privacy-policy');
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
      ref.read(appStateUsecaseProvider.notifier).showDemo(context);
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
                                                  'Total Words', Colors.white),
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
                                    _buildDefaultLang(
                                      viewModel.originalLanguage,
                                      viewModel.translateLanguage,
                                      (value) {
                                        notifier.updateOriginalLanguage(value);
                                      },
                                      (value) {
                                        notifier.updateTranslateLanguage(value);
                                      },
                                    ),
                                    contentSpacer,
                                    _buildSlideHintSwitch(
                                        viewModel.enableSlideHint,
                                        notifier.switchSlideHint),
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
                                    _buildPrivacyPolicy(privacyURL),
                                    contentSpacer,
                                    _buildInquiry(inquiryURL),
                                    contentSpacer,
                                    _buildDemo(handleTapDemo),
                                    contentSpacer,
                                    _buildLicense(handleTapLicense),
                                    contentSpacer,
                                    _buildForgettingCurve(
                                        handleTapForgettingCurve),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              _buildAppVersion(viewModel.version ?? ""),
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

  Widget _buildDefaultLang(
    TranslateLanguage originalLanguage,
    TranslateLanguage translateLanguage,
    Function(TranslateLanguage) onOriginalSelected,
    Function(TranslateLanguage) onTranslateSelected,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
            ),
            const Expanded(
              child: Text('Default Language',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          // height: 40,
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            // color: MyTheme.lemon,
            borderRadius: BorderRadius.circular(10),
          ),
          child: LanguageDropdownHorizontal(
            onOriginalSelected: (value) {
              onOriginalSelected(value);
            },
            onTranslateSelected: (value) {
              onTranslateSelected(value);
            },
            originalLanguage: originalLanguage,
            translateLanguage: translateLanguage,
          ),
        )
      ],
    );
  }

  Widget _buildSlideHintSwitch(bool isEnable, VoidCallback onTap) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
        ),
        Expanded(
          child: Row(
            children: [
              const Text('Slide Hint',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500)),
              const SizedBox(width: 16),
              Opacity(
                opacity: isEnable ? 1 : 0.3,
                child: SizedBox(
                    width: 50,
                    height: 45,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
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
                      ],
                    )),
              ),
            ],
          ),
        ),
        Switch(
          activeTrackColor: MyTheme.lemon,
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.white,
          value: isEnable,
          onChanged: (value) async {
            HapticFeedback.lightImpact();
            onTap();
          },
        )
      ],
    );
  }

  Widget _buildPrivacyPolicy(VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
          ),
          const Expanded(
            child: Text('Privacy Policy',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.open_in_new, color: Colors.white)
        ],
      ),
    );
  }

  Widget _buildInquiry(VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
          ),
          const Expanded(
            child: Text('Contact',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.open_in_new, color: Colors.white)
        ],
      ),
    );
  }

  Widget _buildLicense(VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
          ),
          const Expanded(
            child: Text('License',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildDemo(VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
          ),
          const Expanded(
            child: Text('Show Demo',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildForgettingCurve(VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.circle, color: MyTheme.lemon, size: 12),
          ),
          const Expanded(
            child: Text('Forgetting Curve',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildAppVersion(String version) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Version',
            style: TextStyle(
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
