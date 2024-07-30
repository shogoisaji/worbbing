import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:worbbing/application/helper/ad_helper.dart';
import 'package:worbbing/application/helper/ad_test_helper.dart';

class AdBanner extends StatefulWidget {
  final double width;
  const AdBanner({
    super.key,
    required this.width,
  });

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  final double height = 50;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId:
          kDebugMode ? AdTestHelper.bannerAdUnitId : AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize(width: widget.width.toInt(), height: height.toInt()),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        height: height,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 7,
              offset: const Offset(0, -3),
            ),
          ],
          color: Colors.grey.withOpacity(0.15),
        ),
        child: _bannerAd == null
            ? const SizedBox.shrink()
            : SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ));
  }
}
