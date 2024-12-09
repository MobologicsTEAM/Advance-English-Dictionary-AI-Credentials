import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ThesaurusDetailsPage extends StatefulWidget {
  final List<String> word;
  final List<String> definition;
  final List<String> synonyms;
  final List<String> antonyms;
  ThesaurusDetailsPage(
      {required this.word,
      required this.definition,
      required this.synonyms,
      required this.antonyms});

  @override
  State<ThesaurusDetailsPage> createState() => _ThesaurusDetailsPageState();
}

class _ThesaurusDetailsPageState extends State<ThesaurusDetailsPage> {
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
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: darkbluee,
        centerTitle: true,
        title: Text(
          widget.word.first,
          style: TextStyle(
              color: white, fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Card(
                        elevation: 5,
                        margin: EdgeInsets.only(
                            left: 10.w, right: 10.w, bottom: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: BorderSide(color: blue, width: 1.w),
                        ),
                        child: ListTile(
                          title: Text(
                            'Word',
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: darkbluee),
                          ),
                          subtitle: Text(
                            widget.word.first,
                            style: TextStyle(color: black),
                          ),
                          trailing: IconButton(
                              onPressed: () async {
                                await Share.share(
                                    "Word: ${widget.word.first}\nDefinition: ${widget.definition}\nSynonyms: ${widget.synonyms.isNotEmpty ? widget.synonyms : "No Synonyms found"}\nAntonyms: ${widget.antonyms.isNotEmpty ? widget.antonyms : "No Antonyms found"}");
                              },
                              icon: Icon(
                                Icons.share,
                                color: darkbluee,
                              )),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.only(
                            left: 10.w, right: 10.w, bottom: 10.h),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: BorderSide(color: blue, width: 1.w),
                        ),
                        child: ListTile(
                          title: Text(
                            'Definition',
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: darkbluee),
                          ),
                          subtitle: Text(
                            widget.definition.first,
                            style: TextStyle(color: black),
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.only(
                            left: 10.w, right: 10.w, bottom: 10.h),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: BorderSide(color: blue, width: 1.w),
                        ),
                        child: ListTile(
                          title: Text(
                            'Synonyms',
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: darkbluee),
                          ),
                          subtitle: Text(
                            widget.synonyms.first.isNotEmpty
                                ? widget.synonyms.first
                                : 'No Synonyms found',
                            style: TextStyle(
                                color: widget.synonyms.first.isNotEmpty
                                    ? black
                                    : Colors.black.withOpacity(0.5),
                                fontWeight: widget.synonyms.first.isNotEmpty
                                    ? FontWeight.normal
                                    : FontWeight.w500),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 5,
                        margin: EdgeInsets.only(
                            left: 10.w, right: 10.w, bottom: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          side: BorderSide(color: blue, width: 1.w),
                        ),
                        child: ListTile(
                          title: Text(
                            'Antonyms',
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: darkbluee),
                          ),
                          subtitle: Text(
                            widget.antonyms.first.isNotEmpty
                                ? widget.antonyms.first
                                : "No Antonyms found",
                            style: TextStyle(
                                color: widget.antonyms.first.isNotEmpty
                                    ? black
                                    : Colors.black.withOpacity(0.5),
                                fontWeight: widget.antonyms.first.isNotEmpty
                                    ? FontWeight.normal
                                    : FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Consumer2<WidgetProvider, InAppPurchaseController>(
                  builder: (context, value, value2, child) {
                return isLoaded &&
                        value.getOpenAppAd == false &&
                        (!(value2.isMonthlyPurchased ||
                            value2.isYearlyPurchased))
                    ? Container(
                        decoration:
                            BoxDecoration(border: Border.all(color: darkbluee)),
                        margin:
                            EdgeInsets.only(left: 3.w, right: 3.w, top: 5.h),
                        height: 340,
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
