import 'dart:async';

import 'package:easy_dictionary_latest/AddHelper/InterstitialAdHelper.dart';
import 'package:easy_dictionary_latest/Helper/dbHelperThesaurus.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/quizProvider.dart';
import 'package:easy_dictionary_latest/Provider/theasaurusPageProvider.dart';
import 'package:easy_dictionary_latest/Screen/mainPage.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../AddHelper/AdHelper.dart';
import '../Provider/class6_provider.dart';
import '../Provider/offline_dictionary_provider.dart';
import '../Provider/widgetProvider.dart';
import 'InAppPuchase/premium_feature_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  final dbHelperThesaurus = DbHelperThesaurus();
  late Future myFuture;

  bool isLoading = false;

  bool showButton = false;

  @override
  initState() {
    loadNativeAd();
    // Set the loading state and show button after 5 seconds
    setState(() {
      isLoading = true; // Show the loading indicator
    });

    Future.delayed(Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          isLoading = false; // Hide the loading indicator
          showButton = true; // Show the "Start" button
        });
      }
    });

    // appOpenAdManager.loadAd();
    if (InterstitialAdClass.interstitialAd == null) {
      InterstitialAdClass.createInterstitialAd();
    }
    myFuture = load();

    super.initState();
  }

  load() async {
    try {
      final user =
          Provider.of<OfflineDictionaryProvider>(context, listen: false);

      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      final class6Provider =
          Provider.of<Class6Provider>(context, listen: false);
      final thesaurusProvider =
          Provider.of<TheasaurusPageProvider>(context, listen: false);

      await Future.wait([
        quizProvider.loadQuizData(),
        class6Provider.loadclass6LessonTblData(),
        class6Provider.loadclass6LessonTblDetailsData(),
        user.loadOfflineDictionaryData(),
        thesaurusProvider.loadData(),
      ]);

      if (mounted) {
        setState(() {
          showButton = true;
          isLoading = false;
        });
      }
      // setState(() {
      //   showButton = true;
      //   print("this is button value ${showButton}");
      //   isLoading = false;
      // });
    } catch (e) {
      print("Exception in load(): $e");
      if (mounted) {
        setState(() {
          showButton = true;
          isLoading = false;
        });
      }
      // setState(() {
      //   showButton = true;
      //   print("this is button value ${showButton}");
      //   isLoading = false;
      // });
      // Ensure the button appears even if there's an error
    }
  }

  late NativeAd _ad;
  bool isLoaded = false;

  void loadNativeAd() {
    _ad = NativeAd(
        request: const AdRequest(),
        adUnitId: AdHelper.nativeAd,
        factoryId: 'listTile',
        listener: NativeAdListener(onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          print('Native ad failed to load: $error');
          setState(() {
            isLoaded = false; // Ensure isLoaded is false on failure
          });
          ad.dispose();
        }));

    _ad.load();
  }

  @override
  void dispose() {
    _ad.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkbluee,
        body: Container(
          color: darkbluee,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer2<WidgetProvider, InAppPurchaseController>(
                    builder: (context, value, value2, child) {
                  return isLoaded &&
                          value.getOpenAppAd == false &&
                          (!(value2.isMonthlyPurchased ||
                              value2.isYearlyPurchased))
                      ? Container(
                          margin: EdgeInsets.only(left: 3.w, right: 3.w),
                          height: 350,
                          child: AdWidget(ad: _ad),
                        )
                      : SizedBox(
                          height: 320,
                        );
                }),
                SizedBox(
                  height: 15.h,
                ),
                Center(
                  child: Container(
                    height: 130,
                    width: 130,
                    child: Image(image: AssetImage('assets/logo.png')),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Easy AI Dictionary',
                  style: TextStyle(
                      fontSize: 30.0.spMax,
                      fontWeight: FontWeight.bold,
                      color: white,
                      fontFamily: 'Mulish'),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  'Unlocking the power of words with AI',
                  style: TextStyle(
                    fontSize: 16.spMax,
                    color: white,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                // showButton == false
                isLoading
                    ? Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white,
                          size: 70,
                        ),
                      )
                    : Container(
                        width: 200.w,
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(20.r)),
                        child: TextButton(
                            onPressed: () async {
                              // Accessing SubscriptionController via Provider
                              InAppPurchaseController subscriptioncontroller =
                                  Provider.of<InAppPurchaseController>(context,
                                      listen: false);

                              // Show interstitial ad if the user hasn't purchased a subscription
                              if (InterstitialAdClass.interstitialAd != null &&
                                  (!(subscriptioncontroller
                                          .isMonthlyPurchased ||
                                      subscriptioncontroller
                                          .isYearlyPurchased))) {
                                InterstitialAdClass.showInterstitialAd(context);

                                //  appOpenAdManager.showAdIfAvailable(context);
                              }

                              // Check subscription status and navigate accordingly
                              if ((!(subscriptioncontroller
                                      .isMonthlyPurchased ||
                                  subscriptioncontroller.isYearlyPurchased))) {
                                // Navigate to PremiumScreen if no subscription
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PremiumScreen(isSplash: true)),
                                );
                              } else {
                                Navigator.pushReplacementNamed(
                                    context, MainPage.routeName);
                              }

                              // Optionally, load remaining data after navigation
                              Provider.of<TheasaurusPageProvider>(context,
                                      listen: false)
                                  .loadRemaningData();
                            },
                            child: Text(
                              'Start',
                              style: blueTextTheme.displaySmall,
                            ))),
                SizedBox(height: 15.h),
                Text(
                  "This Action May Contain Ad",
                  style: TextStyle(color: white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
