import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/AddHelper/value.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const int maxFailLoadAttempts = 3;

class InterstitialAdClass {
  static InterstitialAd? interstitialAd;
  static int _interstitialAdLoadAttempts = 0;
  static int count = 0;
  static int limit = 3;

  static void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAd,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          _interstitialAdLoadAttempts = 0;
        },
        onAdFailedToLoad: (error) {
          _interstitialAdLoadAttempts += 1;
          interstitialAd = null;
          if (_interstitialAdLoadAttempts <= maxFailLoadAttempts) {
            createInterstitialAd();
          }
        },
      ),
    );
  }

  static void showInterstitialAd(BuildContext context) {
    if (interstitialAd != null) {
      Value.vl = true;
      InterstitialAdClass.count = 0;
      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
        Future.delayed(const Duration(seconds: 1))
            .then((v) => Value.vl = false);
        ad.dispose();
        createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createInterstitialAd();
      });
      interstitialAd!.show();
    }
  }
}
