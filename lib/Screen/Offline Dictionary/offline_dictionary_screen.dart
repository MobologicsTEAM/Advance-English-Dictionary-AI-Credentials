import 'package:easy_dictionary_latest/AddHelper/InterstitialAdHelper.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../AddHelper/AdHelper.dart';
import '../../Provider/offline_dictionary_provider.dart';
import '../../Provider/widgetProvider.dart';
import '../../constants.dart';
import 'od_word_details_screen.dart';

class OfflineDictionaryScreen extends StatefulWidget {
  const OfflineDictionaryScreen({super.key});

  @override
  State<OfflineDictionaryScreen> createState() =>
      _OfflineDictionaryScreenState();
}

class _OfflineDictionaryScreenState extends State<OfflineDictionaryScreen> {
  TextEditingController textEditingController = TextEditingController();
  bool iskeyboardVisible = false;
  late NativeAd _ad;
  bool isLoaded = false;
  bool is_translated = false;
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
    OfflineDictionaryProvider offlineDictionaryProvider =
        Provider.of<OfflineDictionaryProvider>(context, listen: false);
    offlineDictionaryProvider.text = '';

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
    InAppPurchaseController value2 =
        Provider.of<InAppPurchaseController>(context, listen: false);
    iskeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    print(iskeyboardVisible);
    OfflineDictionaryProvider offlineDictionaryProvider =
        Provider.of<OfflineDictionaryProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Container(
                height: 200.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/dicBanner.png'),
                      fit: BoxFit.cover,
                    )),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Row(children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: white,
                          )),
                      SizedBox(width: 5.w),
                      Text(
                        "Offline Dictionary",
                        style: TextStyle(
                            color: white,
                            fontSize: 22.spMax,
                            fontWeight: FontWeight.w500),
                      )
                    ]),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 17.w, right: 15.w, top: 20.h),
                      child: TextFormField(
                        onTapOutside: (PointerDownEvent event) {
                          FocusScope.of(context).unfocus();
                        },
                        style: TextStyle(color: black),
                        textInputAction: TextInputAction.search,
                        onChanged: (value) => offlineDictionaryProvider
                            .changeText(textEditingController.text),
                        keyboardType: TextInputType.text,
                        controller: textEditingController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: darkbluee,
                              size: 30.sp,
                            ),
                            suffixIcon: textEditingController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.cancel_outlined),
                                    color: darkbluee,
                                    onPressed: () {
                                      textEditingController.clear();
                                      offlineDictionaryProvider.changeText("");
                                    },
                                  )
                                : SizedBox(),
                            filled: true,
                            fillColor: white,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: darkbluee),
                                borderRadius: BorderRadius.circular(10.r)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 2, color: darkbluee),
                                borderRadius: BorderRadius.circular(10.r)),
                            hintText: 'Search a word',
                            hintStyle: TextStyle(color: blue, fontSize: 14.sp)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: offlineDictionaryProvider.wordList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        side: BorderSide(color: blue, width: 1.w),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                    builder: (context) =>
                                        OfflineDictinoaryWordDetailScreen(
                                          word: offlineDictionaryProvider
                                              .wordList[index].word,
                                          meaning: offlineDictionaryProvider
                                              .wordList[index].meaning,
                                          partofspeech:
                                              offlineDictionaryProvider
                                                  .wordList[index].partOfSpeech,
                                          example1: offlineDictionaryProvider
                                              .wordList[index].example1,
                                          example2: offlineDictionaryProvider
                                              .wordList[index].example2,
                                          example3: offlineDictionaryProvider
                                              .wordList[index].example3,
                                        )));
                          },
                          child: Center(
                            child: Text(
                                offlineDictionaryProvider.wordList[index].word,
                                style: TextStyle(
                                    color: darkbluee,
                                    fontSize: 20.spMax,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            //(!iskeyboardVisible)
            Visibility(
                visible: !iskeyboardVisible,
                child: Consumer2<WidgetProvider, InAppPurchaseController>(
                    builder: (context, value, value2, child) {
                  return isLoaded &&
                          value.getOpenAppAd == false &&
                          (!(value2.isMonthlyPurchased ||
                              value2.isYearlyPurchased))
                      ? Container(
                          margin:
                              EdgeInsets.only(top: 5.h, right: 3.w, left: 3.w),
                          decoration: BoxDecoration(
                              border: Border.all(color: darkbluee)),
                          height: 140,
                          width: MediaQuery.of(context).size.width,
                          child: AdWidget(ad: _ad),
                        )
                      : SizedBox(
                          // height: 140,
                          );
                }))
          ],
        ),
      ),
    );
  }
}
