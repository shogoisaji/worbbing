import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:worbbing/application/helper/ad_helper.dart';
import 'package:worbbing/application/helper/ad_test_helper.dart';
import 'package:worbbing/core/constants/ticket_constants.dart';
import 'package:worbbing/presentation/widgets/custom_text.dart';
import 'package:worbbing/presentation/widgets/error_dialog.dart';
import 'package:worbbing/presentation/widgets/two_way_dialog.dart';

class AdReward extends StatefulWidget {
  final Widget child;
  final Function() onEarnTicket;
  const AdReward({
    super.key,
    required this.child,
    required this.onEarnTicket,
  });

  @override
  State<AdReward> createState() => _AdRewardState();
}

class _AdRewardState extends State<AdReward> {
  RewardedAd? _rewardedAd;

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: kDebugMode
          ? AdTestHelper.rewardedAdUnitId
          : AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  void _handleTap() {
    HapticFeedback.lightImpact();

    TwoWayDialog.show(
        context,
        '広告を見て\nチケットを獲得',
        const Icon(Icons.help_outline, size: 36),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 1, left: 4),
              child: bodyText(
                  '動画広告を最後まで視聴することで、チケットが ${TicketConstants.rewardEarnTicket} 枚獲得できます。\n\n※音声が流れる可能せがあります。',
                  Colors.white),
            ),
            const SizedBox(height: 12),
          ],
        ),
        leftButtonText: 'キャンセル',
        rightButtonText: '広告を見る',
        onLeftButtonPressed: () {}, onRightButtonPressed: () async {
      if (_rewardedAd == null) {
        ErrorDialog.show(context: context, text: '広告の取得に失敗しました。');
        return;
      }

      await _rewardedAd?.setImmersiveMode(true);

      _rewardedAd?.show(
        onUserEarnedReward: (_, reward) {
          widget.onEarnTicket();
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  @override
  void dispose() {
    super.dispose();
    _rewardedAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _handleTap();
        },
        child: widget.child);
  }
}
