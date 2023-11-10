import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/blocs/ads_bloc.dart';
import 'package:quiz_app/blocs/user_bloc.dart';
import 'package:quiz_app/configs/app_config.dart';
import 'package:quiz_app/services/firebase_service.dart';
import 'package:quiz_app/utils/icon_utils.dart';
import 'package:quiz_app/widgets/loading_widget.dart';

import '../configs/ad_config.dart';

class RewardedAdContainer extends StatefulWidget {
  const RewardedAdContainer({Key? key}) : super(key: key);

  @override
  State<RewardedAdContainer> createState() => _RewardedAdContainerState();
}

class _RewardedAdContainerState extends State<RewardedAdContainer> {
  bool _isLoading = false;

  RewardedAd? _rewardedAd;

  void _createRewardedVideoAd() async {
    setState(() => _isLoading = true);
    await RewardedAd.load(
        adUnitId: AdConfig.getRewardedVideoAdUnitId(),
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            debugPrint('$ad loaded');
            _rewardedAd = ad;
            _showRewardedVideoAd();
            setState(() => _isLoading = false);
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('Rewarded Ad failed to load: $error.');
            _rewardedAd = null;
            setState(() => _isLoading = false);
            //_isRewardedAdLoaded = false;
          },
          
        ));
  }

  void _showRewardedVideoAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) => debugPrint('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          debugPrint('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          _rewardedAd = null;
          //_isRewardedAdLoaded = false;
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          _rewardedAd = null;
          //_isRewardedAdLoaded = false;
        },
      );
      _rewardedAd!.show(onUserEarnedReward: (ad, RewardItem item) async {
        await _onRewardComplete();
      });
      _rewardedAd = null;
    }
  }

  _onRewardComplete() async {
    final String userId = context.read<UserBloc>().userData!.uid!;
    final int rewardAmount = context.read<AdsBloc>().rewardedAdPoints;
    await FirebaseService()
        .updateUserPointsByTransection(userId, true, rewardAmount)
        .then((value) async => await _updatePointsHistory(rewardAmount))
        .then((value) async => await context.read<UserBloc>().getUserData());
    _openRewardDialog(rewardAmount);
  }

  _onPressed() {
    _createRewardedVideoAd();
  }

  _updatePointsHistory(int rewardPoint) async {
    final String userId = context.read<UserBloc>().userData!.uid!;
    final newHistory = "Watched A Rewarded Video Ad +$rewardPoint at ${DateTime.now()}";
    await FirebaseService().updateUserPointHistory(userId, newHistory);
  }

  Future<void> _openRewardDialog(int rewardAmount) {
    return Dialogs.materialDialog(
        context: context,
        title: 'points-reward-title'.tr(),
        msg: 'points-reward-subtitle-count'.tr(args: [rewardAmount.toString()]),
        lottieBuilder: LottieBuilder.asset(
          Config.rewardAnimation,
          fit: BoxFit.cover,
        ),
        titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        msgAlign: TextAlign.center,
        msgStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20),
            height: 50,
            child: IconsButton(
              onPressed: () => Navigator.pop(context),
              text: 'claim'.tr(),
              iconData: Icons.done,
              color: Theme.of(context).primaryColor,
              textStyle: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              iconColor: Colors.white,
            ),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onPressed(),
      child: Container(
        alignment: Alignment.center,
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        child: _isLoading
            ? const LoadingIndicatorWidget(
                color: Colors.white,
              )
            : Wrap(
                children: [
                  const Icon(
                    IconUtils.video,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text('watch-video-count', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white))
                      .tr(args: [context.read<AdsBloc>().rewardedAdPoints.toString()]),
                ],
              ),
      ),
    );
  }
}
