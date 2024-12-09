import 'package:easy_dictionary_latest/AddHelper/InterstitialAdHelper.dart';
import 'package:easy_dictionary_latest/Provider/class6_provider.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../AddHelper/AdHelper.dart';
import '../../Provider/widgetProvider.dart';
import '../../constants.dart';
import 'lesson_details_screen.dart';

class VocabularyMainScreen extends StatefulWidget {
  const VocabularyMainScreen({super.key});

  @override
  State<VocabularyMainScreen> createState() => _VocabularyMainScreenState();
}

class _VocabularyMainScreenState extends State<VocabularyMainScreen> {
  late NativeAd _ad;
  bool isLoaded = false;

  void loadNativeAd() {
    _ad = NativeAd(
        request: const AdRequest(),
        adUnitId: AdHelper.nativeAd,
        factoryId: 'small',
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
  Widget build(BuildContext context) {
    InAppPurchaseController value2 =
        Provider.of<InAppPurchaseController>(context, listen: false);
    Class6Provider class6Provider =
        Provider.of<Class6Provider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: white),
          elevation: 0,
          backgroundColor: darkbluee,
          title: Text(
            "Vocabulary Builder",
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: class6Provider.class6_lessonTbl_data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    child: InkWell(
                      onTap: () {
                        InterstitialAdClass.count++;
                        if (InterstitialAdClass.count ==
                                InterstitialAdClass.limit &&
                            (!(value2.isMonthlyPurchased ||
                                value2.isYearlyPurchased))) {
                          InterstitialAdClass.showInterstitialAd(context);
                          InterstitialAdClass.count = 0;
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => LessonDetailsScreen(
                                      id: class6Provider
                                          .class6_lessonTbl_data[index].lesson
                                          .toString(),
                                      name: class6Provider
                                          .class6_lessonTbl_data[index].name,
                                    ))));
                      },
                      child: Card(
                        // margin: EdgeInsets.only(
                        //     left: 10.w, right: 10.w, bottom: 10.h, top: 10.h),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: BorderSide(color: blue, width: 1.w),
                        ),
                        child: ListTile(
                          title: Text(
                              class6Provider.class6_lessonTbl_data[index].name),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            class6Provider.class6_lessonTbl_data.isNotEmpty
                ? Consumer2<WidgetProvider, InAppPurchaseController>(
                    builder: (context, value, value2, child) {
                    return isLoaded &&
                            value.getOpenAppAd == false &&
                            (!(value2.isMonthlyPurchased ||
                                value2.isYearlyPurchased))
                        ? Column(
                            children: [
                              Card(
                                elevation: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: darkbluee)),
                                  height: 140,
                                  width: MediaQuery.of(context).size.width,
                                  child: AdWidget(ad: _ad),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(
                            // height: 140,
                            );
                  })
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
