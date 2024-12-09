import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/subcategoryProvider.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:easy_dictionary_latest/Widget/proverbsList.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class SubCategoryData extends StatefulWidget {
  final int index;
  final bool isKeyboardVisible;
  SubCategoryData({this.index = 0, required this.isKeyboardVisible});

  @override
  State<SubCategoryData> createState() => _SubCategoryDataState();
}

class _SubCategoryDataState extends State<SubCategoryData> {
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
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        FutureBuilder(
            future: Provider.of<SubCategoryProvider>(context, listen: false)
                .getSubCategoryFromDB(widget.index),
            builder: ((context, snapshot) {
              return Consumer<SubCategoryProvider>(
                  builder: ((context, value, child) {
                return Expanded(
                  child: ListView.builder(
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding:
                            EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                        child: ProverbList(
                          pageNum: 4,
                          defination: value.getSubCategoryIdioms[index].define,
                          proverb: value.getSubCategoryIdioms[index].idiom,
                          id: value.getSubCategoryIdioms[index].idiomID,
                          fav: value.getSubCategoryIdioms[index].fav,
                          example: value.getSubCategoryIdioms[index].example,
                          catID: value.getSubCategoryIdioms[index].catID,
                        ),
                      );
                    }),
                    itemCount: value.getSubCategoryIdioms.length,
                  ),
                );
              }));
            })),
        Visibility(
            visible: !widget.isKeyboardVisible,
            child: Consumer2<WidgetProvider, InAppPurchaseController>(
                builder: (context, value, value2, child) {
              return isLoaded &&
                      value.getOpenAppAd == false &&
                      (!(value2.isMonthlyPurchased || value2.isYearlyPurchased))
                  ? Container(
                      margin: EdgeInsets.only(top: 5.h, right: 3.w, left: 3.w),
                      decoration:
                          BoxDecoration(border: Border.all(color: darkbluee)),
                      height: 140,
                      width: MediaQuery.of(context).size.width,
                      child: AdWidget(ad: _ad),
                    )
                  : SizedBox();
            }))
      ],
    ));
  }
}
