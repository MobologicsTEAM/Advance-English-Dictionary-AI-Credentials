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

class BritishSlangsData extends StatefulWidget {
  final bool isKeyboardVisible;
  const BritishSlangsData({Key? key, required this.isKeyboardVisible})
      : super(key: key);

  @override
  State<BritishSlangsData> createState() => _BritishSlangsDataState();
}

class _BritishSlangsDataState extends State<BritishSlangsData> {
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
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (isDepend == false) {
      future = Provider.of<BritishSlangsProvider>(context, listen: false)
          .getBritishSlangsFromdb();

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
          builder: ((context, snapshot) {
            return Consumer<BritishSlangsProvider>(
              builder: ((context, value, child) => Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: 10.h, left: 10.w, right: 10.w),
                          child: ProverbList(
                            pageNum: 2,
                            proverb: value.britishSlangsList[index].slang
                                .replaceAll('  ', ' '),
                            defination:
                                value.britishSlangsList[index].defination,
                            id: value.britishSlangsList[index].id,
                            fav: value.britishSlangsList[index].favorite,
                          ),
                        );
                      },
                      itemCount: value.britishSlangsList.length,
                    ),
                  )),
            );
          }),
        ),
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
                  : SizedBox(
                      // height: 140,
                      );
            }))
      ],
    );
  }
}
