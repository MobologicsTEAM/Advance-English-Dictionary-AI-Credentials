import 'dart:developer';

import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class AppOpenAdManager {
  static AppOpenAd? appOpenAd;
  static bool isLoaded = false;

  void loadAd() {
    AppOpenAd.load(
      adUnitId: AdHelper.openAppAd,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          log("App Open Loaded");
          appOpenAd = ad;
          isLoaded = true;
        },
        onAdFailedToLoad: (error) {
          log("App Open Failed $error");
        },
      ),
    );
  }

  bool get isAdAvailable {
    return appOpenAd != null;
  }

  void showAdIfAvailable(BuildContext context) {
    if (appOpenAd == null) {
      loadAd();
      return;
    }
    // if (Provider.of<WidgetProvider>(context, listen: false).getOpenAppAd ==
    //     true) {
    //   return;
    // }
    appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        log("Ad showed full screen");
        Provider.of<WidgetProvider>(context, listen: false)
            .toggleOpenAppAdToToogle(true);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        log("Ad failed to show: $error");
        Provider.of<WidgetProvider>(context, listen: false)
            .toggleOpenAppAdToToogle(false);
        ad.dispose();
        appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        log("Ad dismissed");
        Provider.of<WidgetProvider>(context, listen: false)
            .toggleOpenAppAdToToogle(false);
        ad.dispose();
        appOpenAd = null;
        loadAd();
      },
    );

    appOpenAd!.show();
  }
}
