import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../configs/ad_config.dart';

class AdsBloc  extends ChangeNotifier{

  bool _isInterstialEnabled = false;
  bool get isInterstitialEnabled => _isInterstialEnabled;

  bool _isRewardedEnabled = false;
  bool get isRewardedEnabled => _isRewardedEnabled;

  bool _isBannerAdEnabled = false;
  bool get isBannerAdEnabled => _isBannerAdEnabled;

  bool _isInterstitalAdLoaded = false;
  bool get isInterstitialAdLoaded => _isInterstitalAdLoaded;

  int _rewardedAdPoints = 0;
  int get rewardedAdPoints => _rewardedAdPoints;

  Future checkAds ()async{
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot snap = await firestore.collection('settings').doc('ads').get();
    if(snap.exists){
      _isInterstialEnabled = snap.get('interstitial_ad') ?? false;
      _isRewardedEnabled = snap.get('rewarded_ad') ?? false;
      _isBannerAdEnabled = snap.get('banner_ad') ?? false;
      _rewardedAdPoints = snap.get('reward_ad_points') ?? 0;

    }else{
      _isInterstialEnabled = false;
      _isRewardedEnabled = false;
      _isBannerAdEnabled = false;
      _rewardedAdPoints = 0;
    }
    notifyListeners();
  }

  InterstitialAd? _interstitialAd;

  void createInterstitialAd(){
    InterstitialAd.load(
        adUnitId: AdConfig.getInterstitialAdUnitId(),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            debugPrint('$ad loaded');
            _interstitialAd = ad;
            _isInterstitalAdLoaded = true;
            notifyListeners();
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error.');
            _interstitialAd = null;
            _isInterstitalAdLoaded = false;
            notifyListeners();
            createInterstitialAd();
          },
    ));
  }

  void showInterstitialAd() {
    if(_interstitialAd != null){

      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => debugPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _interstitialAd = null;
        _isInterstitalAdLoaded = false;
        notifyListeners();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _interstitialAd = null;
        _isInterstitalAdLoaded = false;
        notifyListeners();
      },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
      notifyListeners();
    }
  }


  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

}