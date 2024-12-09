import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../Provider/britishSlangsProvider.dart';
import '../Widget/proverbsList.dart';

class FavBritishSlangs extends StatefulWidget {
  final bool isKeyboardVisible;
  const FavBritishSlangs({Key? key, required this.isKeyboardVisible})
      : super(key: key);

  @override
  State<FavBritishSlangs> createState() => _FavBritishSlangsState();
}

class _FavBritishSlangsState extends State<FavBritishSlangs> {
  late final future;
  bool isDepend = false;
  late NativeAd _ad;
  bool isLoaded = false;

  @override
  void initState() {
    loadNativeAd();
    super.initState();
  }

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
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (isDepend == false) {
      future = Provider.of<BritishSlangsProvider>(context, listen: false)
          .getFavoriteBritishSlangsFromModel();

      isDepend = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            return Consumer<BritishSlangsProvider>(
              builder: (context, value, child) {
                if (value.getFavbritishSlangsList.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'No Favorite items found',
                        style: TextStyle(fontSize: 18.sp, color: darkbluee),
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: 10.h, left: 10.w, right: 10.w),
                          child: ProverbList(
                            pageNum: 2,
                            isFav: true,
                            proverb: value.getFavbritishSlangsList[index].slang
                                .replaceAll('  ', ' '),
                            defination:
                                value.getFavbritishSlangsList[index].defination,
                            id: value.getFavbritishSlangsList[index].id,
                            fav: value.getFavbritishSlangsList[index].favorite,
                          ),
                        );
                      },
                      itemCount: value.getFavbritishSlangsList.length,
                    ),
                  );
                }
              },
            );
          },
        ),
        Provider.of<BritishSlangsProvider>(context, listen: false)
                .getFavbritishSlangsList
                .isEmpty
            ? SizedBox()
            : Visibility(
                visible: !widget.isKeyboardVisible,
                child: Consumer2<WidgetProvider, InAppPurchaseController>(
                  builder: (context, value, value2, child) {
                    return isLoaded &&
                            !value.getOpenAppAd &&
                            (!(value2.isMonthlyPurchased ||
                                value2.isYearlyPurchased))
                        ? Container(
                            margin: EdgeInsets.only(
                                top: 5.h, right: 3.w, left: 3.w),
                            decoration: BoxDecoration(
                                border: Border.all(color: darkbluee)),
                            height: 140,
                            width: MediaQuery.of(context).size.width,
                            child: AdWidget(ad: _ad),
                          )
                        : SizedBox();
                  },
                ),
              ),
      ],
    );
  }
}
