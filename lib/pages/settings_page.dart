import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:worbbing/models/translate_language.dart';
import 'package:worbbing/models/word_model.dart';
import 'package:worbbing/presentation/widgets/language_dropdown.dart';
import 'package:worbbing/repository/sqflite_repository.dart';
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
  late Future<int> totalWords;
  late Future<Map<int, int>> countNotice;

  Future<List<TranslateLanguage>> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedOriginalString = prefs.getString("original_lang") ?? "english";
    final loadedTranslateString =
        prefs.getString("translate_lang") ?? "japanese";
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

  Future<String> loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  void initState() {
    super.initState();
    totalWords = SqfliteRepository.instance.totalWords();
    countNotice = SqfliteRepository.instance.countNoticeDuration();
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
    return Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/settings.png',
              width: 150,
            ),
          ),
          leading: InkWell(
              child: Align(
                child: Image.asset(
                  'assets/images/custom_arrow.png',
                  width: 35,
                  height: 35,
                ),
              ),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.transparent,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 25),
                      width: 250,
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.white, width: 1)),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            mediumText('Total Words', Colors.white),
                            // total words
                            FutureBuilder(
                                future: totalWords,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: SizedBox.shrink());
                                  }

                                  if (snapshot.hasError) {
                                    return const Text('エラーが発生しました');
                                  }

                                  final data = snapshot.data!;

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: titleText(
                                        data.toString(), MyTheme.orange, 36),
                                  );
                                })
                          ])),
                  const SizedBox(
                    height: 24,
                  ),
                  FutureBuilder(
                      future: countNotice,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child:
                                  SizedBox(child: CircularProgressIndicator()));
                        }

                        if (snapshot.hasError) {
                          return const Text('error');
                        }

                        final data = snapshot.data!;

                        return SizedBox(
                          width: 350, //(noticeBlock+14padding)*7
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: noticeDurationList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Column(
                                  children: [
                                    noticeBlock(36, noticeDurationList[index],
                                        MyTheme.lemon),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    mediumText(
                                        data[noticeDurationList[index]] == null
                                            ? "0"
                                            : data[noticeDurationList[index]]
                                                .toString(),
                                        Colors.white)
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.circle,
                                      color: MyTheme.lemon, size: 12),
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
                              child: Row(
                                children: [
                                  FutureBuilder(
                                      future: loadPreferences(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child: SizedBox.shrink());
                                        }
                                        if (snapshot.hasError) {
                                          return const Text('error');
                                        }
                                        final data = snapshot.data!;
                                        return LanguageDropdownWidget(
                                          onOriginalSelected: (value) {
                                            updateOriginalLanguage(value);
                                          },
                                          onTranslateSelected: (value) {
                                            updateTranslateLanguage(value);
                                          },
                                          originalLanguage: data[0],
                                          translateLanguage: data[1],
                                          isHorizontal: true,
                                        );
                                      })
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        GestureDetector(
                          onTap: () {
                            privacyURL();
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.circle,
                                    color: MyTheme.lemon, size: 12),
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
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        GestureDetector(
                          onTap: () {
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
                                child: Icon(Icons.circle,
                                    color: MyTheme.lemon, size: 12),
                              ),
                              const Expanded(
                                child: Text('License',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500)),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EbbinghausPage()),
                            );
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.circle,
                                    color: MyTheme.lemon, size: 12),
                              ),
                              const Expanded(
                                child: Text('Forgetting Curve',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500)),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.circle,
                                  color: MyTheme.lemon, size: 12),
                            ),
                            const Expanded(
                              child: Text('App Version',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500)),
                            ),
                            FutureBuilder(
                                future: loadVersion(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox.shrink();
                                  }
                                  if (snapshot.hasError) {
                                    return const Text('error');
                                  }
                                  final data = snapshot.data!;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Text(data,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500)),
                                  );
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ));
  }
}
