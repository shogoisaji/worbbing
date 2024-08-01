import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:worbbing/application/usecase/app_state_usecase.dart';
import 'package:worbbing/models/translate_language.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/widgets/ad_banner.dart';
import 'package:worbbing/presentation/widgets/language_dropdown_horizontal.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_keys.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_repository.dart';
import 'package:worbbing/repository/sqflite/sqflite_repository.dart';
import 'package:worbbing/pages/ebbinghaus_page.dart';
import 'package:worbbing/presentation/theme/theme.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/notice_block.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int totalWords = 0;
  Map<int, int> countNotice = {};

  final Widget _contentSpacer = const SizedBox(height: 22);

  List<TranslateLanguage> loadPreferences() {
    final loadedOriginalString = SharedPreferencesRepository().fetch<String>(
          SharedPreferencesKey.originalLang,
        ) ??
        "english";
    final loadedTranslateString = SharedPreferencesRepository().fetch<String>(
          SharedPreferencesKey.translateLang,
        ) ??
        "japanese";
    final originalLanguage = TranslateLanguage.values
        .firstWhere((e) => e.lowerString == loadedOriginalString);
    final translateLanguage = TranslateLanguage.values
        .firstWhere((e) => e.lowerString == loadedTranslateString);
    return [originalLanguage, translateLanguage];
  }

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

  Future<String> loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> _initialLoad() async {
    totalWords = await SqfliteRepository.instance.totalWords();
    countNotice = await SqfliteRepository.instance.countNoticeDuration();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initialLoad();
  }

  void updateOriginalLanguage(TranslateLanguage value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("original_lang", value.lowerString);
  }

  void updateTranslateLanguage(TranslateLanguage value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("translate_lang", value.lowerString);
  }

  @override
  Widget build(BuildContext context) {
    final contentWidth =
        (MediaQuery.of(context).size.width * 0.9).clamp(100.0, 500.0);
    return Scaffold(
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
                Navigator.of(context).pop();
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 0.5),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 220,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.white, width: 1)),
                                  ),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        mediumText('Total Words', Colors.white),
                                        // total words
                                        titleText(totalWords.toString(),
                                            MyTheme.orange, 36),
                                      ]),
                                ),
                                SizedBox(
                                  height: 110,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children:
                                        noticeDurationList.map((duration) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          left: duration == 1 ? 20 : 8,
                                          right: duration == 99 ? 24 : 8,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            noticeBlock(
                                                36, duration, MyTheme.lemon),
                                            const SizedBox(height: 8),
                                            mediumText(
                                                countNotice[duration]
                                                        ?.toString() ??
                                                    "0",
                                                Colors.white)
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
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 24),
                            child: Column(
                              children: [
                                _buildDefaultLang(),
                                _contentSpacer,
                                _buildSlideHintSwitch(),
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
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 24),
                            child: Column(
                              children: [
                                _buildPrivacyPolicy(),
                                _contentSpacer,
                                _buildInquiry(),
                                _contentSpacer,
                                _buildDemo(),
                                _contentSpacer,
                                _buildLicense(),
                                _contentSpacer,
                                _buildForgettingCurve(),
                              ],
                            ),
                          ),
                          _contentSpacer,
                          _buildAppVersion(),
                          const SizedBox(
                            height: 50,
                          ),
                        ]),
                  ),
                ),
              ),
              AdBanner(width: MediaQuery.of(context).size.width)
            ],
          ),
        ));
  }

  Widget _buildDefaultLang() {
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
              updateOriginalLanguage(value);
            },
            onTranslateSelected: (value) {
              updateTranslateLanguage(value);
            },
            originalLanguage: loadPreferences()[0],
            translateLanguage: loadPreferences()[1],
          ),
        )
      ],
    );
  }

  Widget _buildSlideHintSwitch() {
    final isEnable = AppStateUsecase().isEnableSlideHint();
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
          value: AppStateUsecase().isEnableSlideHint(),
          onChanged: (value) async {
            HapticFeedback.lightImpact();
            await AppStateUsecase().switchEnableSlideHint(value);
            setState(() {});
          },
        )
      ],
    );
  }

  Widget _buildPrivacyPolicy() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        privacyURL();
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

  Widget _buildInquiry() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        inquiryURL();
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

  Widget _buildLicense() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LicensePage(
              applicationName: 'Worbbing',
            ),
          ),
        );
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

  Widget _buildDemo() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        AppStateUsecase().showDemo(context);
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

  Widget _buildForgettingCurve() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EbbinghausPage()),
        );
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

  Widget _buildAppVersion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Version',
            style: TextStyle(
                color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(width: 10),
        FutureBuilder(
            future: loadVersion(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }
              if (snapshot.hasError) {
                return const Text('---');
              }
              final data = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(data,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              );
            }),
      ],
    );
  }
}
