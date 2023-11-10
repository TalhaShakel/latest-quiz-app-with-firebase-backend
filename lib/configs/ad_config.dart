import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdConfig {

  // Android 
  // Admob App ID for Android
  static const String appIdAndroid = 'ca-app-pub-3940256099942544~3347511713';

  // Admob Interstitial Ad Unit ID Android
  static const String interstitialAdUnitIdAndroid = 'ca-app-pub-3940256099942544/1033173712';

  // Admob Rewarded Video Ad Unit ID Android
  static const String rewardedVideoAdUnitIdAndroid = 'ca-app-pub-3940256099942544/5224354917';

  // Admob Banner Ad Unit ID for Android
  static const String bannerAdUnitIdAndroid = 'ca-app-pub-3940256099942544/6300978111';





  // iOS
  // Admob App ID for iOS
  static const String appIdiOS = 'ca-app-pub-3940256099942544~1458002511';

  // Admob Interstitial Ad Unit ID iOS
  static const String interstitialAdUnitIdiOS = 'ca-app-pub-3940256099942544/4411468910';

  // Admob Interstitial Rewarded Video Ad Unit ID iOS
  static const String rewardedVideoAdUnitIdiOS = 'ca-app-pub-3940256099942544/1712485313';

  // Admob Banner Ad Unit ID for iOS
  static const String bannerAdUnitIdiOS = 'ca-app-pub-3940256099942544/2934735716';

  
  
  
  // -- Don't edit these --
  Future initAdmob() async {
    await MobileAds.instance.initialize();
  }

  static String getAdmobAppId() {
    if (Platform.isAndroid) {
      return appIdAndroid;
    } else {
      return appIdiOS;
    }
  }

  static String getBannerAdUnitId() {
    if (Platform.isAndroid) {
      return bannerAdUnitIdAndroid;
    } else {
      return bannerAdUnitIdiOS;
    }
  }

  static String getInterstitialAdUnitId() {
    if (Platform.isAndroid) {
      return interstitialAdUnitIdAndroid;
    } else {
      return interstitialAdUnitIdiOS;
    }
  }

  static String getRewardedVideoAdUnitId() {
    if (Platform.isAndroid) {
      return rewardedVideoAdUnitIdAndroid;
    } else {
      return rewardedVideoAdUnitIdiOS;
    }
  }
}
