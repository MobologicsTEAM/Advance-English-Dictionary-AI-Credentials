import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../Provider/americanSlangsProvider.dart';
import '../Widget/proverbsList.dart';

class FavAmericanSlangs extends StatefulWidget {
  final bool isKeyboardVisible;
  const FavAmericanSlangs({Key? key, required this.isKeyboardVisible})
      : super(key: key);

  @override
  State<FavAmericanSlangs> createState() => _FavAmericanSlangsState();
}

class _FavAmericanSlangsState extends State<FavAmericanSlangs> {
  late final future;
  bool isDepend = false;

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
  void didChangeDependencies() {
    if (isDepend == false) {
      future = Provider.of<AmericanSlangsProvider>(context, listen: false)
          .getAmericanFavoriteSlangsFromdb();

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
            return Consumer<AmericanSlangsProvider>(
              builder: (context, value, child) {
                if (value.getFavAmericanSlangs.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'No Favorite items Found',
                        style: TextStyle(fontSize: 18.spMax, color: darkbluee),
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
                            pageNum: 3,
                            isFav: true,
                            proverb: value.getFavAmericanSlangs[index].slang
                                .replaceAll('  ', ' '),
                            defination:
                                value.getFavAmericanSlangs[index].defination,
                            id: value.getFavAmericanSlangs[index].id,
                            fav: value.getFavAmericanSlangs[index].favorite,
                            example: value.getAmericanSlangs[index].example,
                            etymology: value.getAmericanSlangs[index].etymology,
                            synonym: value.getAmericanSlangs[index].synonyms,
                          ),
                        );
                      },
                      itemCount: value.getFavAmericanSlangs.length,
                    ),
                  );
                }
              },
            );
          },
        ),
        Provider.of<AmericanSlangsProvider>(context, listen: false)
                .getFavAmericanSlangs
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
