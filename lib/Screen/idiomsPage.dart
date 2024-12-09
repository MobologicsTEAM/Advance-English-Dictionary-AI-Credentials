import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:easy_dictionary_latest/Screen/britishSlangsPage.dart';
import 'package:easy_dictionary_latest/Screen/categories_screen.dart';
import 'package:easy_dictionary_latest/Screen/proverbs_screen_tabs.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../AddHelper/InterstitialAdHelper.dart';
import 'americanSlangsPage.dart';

class IdiomsPage extends StatefulWidget {
  const IdiomsPage({super.key});

  @override
  State<IdiomsPage> createState() => _IdiomsPageState();
}

class _IdiomsPageState extends State<IdiomsPage> {
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
          ad.dispose();
        }));

    _ad.load();
  }

  @override
  void initState() {
    loadNativeAd();
    super.initState();
  }

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InAppPurchaseController subscriptioncontroller =
        Provider.of<InAppPurchaseController>(context, listen: false);
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: darkbluee,
        title: Text(
          "Idioms",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
          child: Column(
            children: [
              Expanded(
                  child: Container(
                      child: ListView(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        InterstitialAdClass.count++;
                        if (InterstitialAdClass.count ==
                                InterstitialAdClass.limit &&
                            (!(subscriptioncontroller.isMonthlyPurchased ||
                                subscriptioncontroller.isYearlyPurchased))) {
                          InterstitialAdClass.showInterstitialAd(context);
                          InterstitialAdClass.count = 0;
                        }
                        Navigator.pushNamed(
                            context, CategoriesScreen.routeName);
                      },
                      child: Container(
                        padding: EdgeInsets.all(13),
                        height: 100.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                            color: liteblue,
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/popularIdiomsIcon.png',
                              color: darkbluee,
                              height: 40.h,
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                            Flexible(
                              child: Text(
                                'Popular Idioms',
                                style: blackTextTheme.displaySmall,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    InkWell(
                      onTap: () {
                        InterstitialAdClass.count++;
                        if (InterstitialAdClass.count ==
                                InterstitialAdClass.limit &&
                            (!(subscriptioncontroller.isMonthlyPurchased ||
                                subscriptioncontroller.isYearlyPurchased))) {
                          InterstitialAdClass.showInterstitialAd(context);
                          InterstitialAdClass.count = 0;
                        }
                        Navigator.pushNamed(
                            context, ProverbsTabScreen.routeName);
                      },
                      child: Container(
                        padding: EdgeInsets.all(13),
                        height: 100.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                            color: liteblue,
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/proVersIcon.png',
                              color: darkbluee,
                              height: 40.h,
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                            Flexible(
                              child: Text(
                                'Proverbs',
                                style: blackTextTheme.displaySmall,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        InterstitialAdClass.count++;
                        if (InterstitialAdClass.count ==
                                InterstitialAdClass.limit &&
                            (!(subscriptioncontroller.isMonthlyPurchased ||
                                subscriptioncontroller.isYearlyPurchased))) {
                          InterstitialAdClass.showInterstitialAd(context);
                          InterstitialAdClass.count = 0;
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BritishSlangTabs()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(13),
                        height: 100.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                            color: liteblue,
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/britishSlangsIcon.png',
                              color: darkbluee,
                              height: 40.h,
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                            Flexible(
                              child: Text(
                                'British Slangs',
                                style: blackTextTheme.displaySmall,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    InkWell(
                      onTap: () {
                        InterstitialAdClass.count++;
                        if (InterstitialAdClass.count ==
                                InterstitialAdClass.limit &&
                            (!(subscriptioncontroller.isMonthlyPurchased ||
                                subscriptioncontroller.isYearlyPurchased))) {
                          InterstitialAdClass.showInterstitialAd(context);
                          InterstitialAdClass.count = 0;
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AmericanSlangTabs()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        height: 100.h,
                        width: 160.w,
                        decoration: BoxDecoration(
                            color: liteblue,
                            borderRadius: BorderRadius.circular(5.r)),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/americanSlangsIcon.png',
                              color: darkbluee,
                              height: 40.h,
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                            Flexible(
                              child: Text(
                                'American Slangs',
                                style: blackTextTheme.displaySmall,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]))),
              Consumer2<WidgetProvider, InAppPurchaseController>(
                  builder: (context, value, value2, child) {
                return isLoaded &&
                        value.getOpenAppAd == false &&
                        (!(value2.isMonthlyPurchased ||
                            value2.isYearlyPurchased))
                    ? Container(
                        decoration:
                            BoxDecoration(border: Border.all(color: darkbluee)),
                        height: 355,
                        margin: EdgeInsets.only(top: 10.h),
                        width: MediaQuery.of(context).size.width,
                        child: AdWidget(ad: _ad),
                      )
                    : SizedBox();
              })
            ],
          ),
        ),
      ),
    );
  }
}
