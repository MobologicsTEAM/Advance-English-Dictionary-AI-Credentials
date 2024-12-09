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

class FavSubCategoryData extends StatefulWidget {
  final int index;
  final bool isKeyboardVisible;
  FavSubCategoryData({
    this.index = 0,
    required this.isKeyboardVisible,
  });

  @override
  State<FavSubCategoryData> createState() => _FavSubCategoryDataState();
}

class _FavSubCategoryDataState extends State<FavSubCategoryData> {
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
    return Column(
      children: [
        FutureBuilder(
            future: Provider.of<SubCategoryProvider>(context, listen: false)
                .getFavSubCatFromDB(widget.index),
            builder: ((context, snapshot) {
              return Consumer<SubCategoryProvider>(
                  builder: ((context, value, child) {
                if (value.getfavSubCategoryIdioms.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'No favorite items found',
                        style: TextStyle(color: darkbluee, fontSize: 18),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: 10.h, left: 10.w, right: 10.w),
                          child: ProverbList(
                            pageNum: 4,
                            defination:
                                value.getfavSubCategoryIdioms[index].define,
                            proverb: value.getfavSubCategoryIdioms[index].idiom,
                            id: value.getfavSubCategoryIdioms[index].idiomID,
                            fav: value.getfavSubCategoryIdioms[index].fav,
                            example:
                                value.getfavSubCategoryIdioms[index].example,
                            catID: value.getfavSubCategoryIdioms[index].catID,
                          ),
                        );
                      }),
                      itemCount: value.getfavSubCategoryIdioms.length,
                    ),
                  );
                }
              }));
            })),
        Provider.of<SubCategoryProvider>(context, listen: false)
                .getfavSubCategoryIdioms
                .isEmpty
            ? SizedBox()
            : Visibility(
                visible: !widget.isKeyboardVisible,
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
    );
  }
}
