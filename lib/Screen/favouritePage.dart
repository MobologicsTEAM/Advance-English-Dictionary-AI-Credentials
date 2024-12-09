import 'dart:async';

import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/Helper/dbHelper.dart';
import 'package:easy_dictionary_latest/Model/dbModel.dart';
import 'package:easy_dictionary_latest/Provider/favorite_page_provider.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  // List<DbModel> dataList = [];
  DbHelper? dbHelper;
  late Future myFuture;
  @override
  void initState() {
    super.initState();
    dbHelper = DbHelper();
    myFuture =
        Provider.of<FavoritePageProvider>(context, listen: false).loadData();
    loadNativeAd();
  }

//splitpartOfSpeech
  String splitpartOfSpeech = '';
  var a = [];
  splitPartOfSpeech(List<DbModel> snapshot, index) {
    a.clear();
    var p = snapshot[index].partOfSpeech.toString().split('mobologics');
    for (var element in p) {
      splitpartOfSpeech = splitpartOfSpeech + element;
    }
    a = splitpartOfSpeech.toString().split('  ');
    splitpartOfSpeech = '';
  }

  //splitDefination
  String b = '';
  var splitdefination = [];
  splitDefination(List<DbModel> snapshot, index) {
    splitdefination.clear();
    var p = snapshot[index].definition.toString().split('mobologics');
    for (var element in p) {
      b = b + element;
    }
    splitdefination = b.toString().split('  ');
    b = '';
  }

  var spiltword = [];
  splitWord(List<DbModel> snapshot, index) {
    spiltword.clear();
    var p = snapshot[index].word.toString();
    spiltword.add(p);
  }

  //splitSynonyms
  String c = '';
  var splitsynonyms = [];

  splitSynonyms(List<DbModel> snapshot, index) {
    splitsynonyms.clear();
    var p = snapshot[index].synonyms.toString().split('mobologics');
    for (var element in p) {
      c = c + element;
    }

    splitsynonyms = c.toString().split('  ');

    c = '';
  }

  //splitAntonyms
  String d = '';
  var splitantonyms = [];
  splitAntonyms(List<DbModel> snapshot, index) {
    splitantonyms.clear();
    var p = snapshot[index].antonyms.toString().split('mobologics');
    for (var element in p) {
      d = d + element;
      print(element);
    }
    splitantonyms = d.toString().split('  ');
    d = '';
  }

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
  Widget build(BuildContext context) {
    FavoritePageProvider favoritePageProvider =
        Provider.of<FavoritePageProvider>(
      context,
    );
    return Scaffold(
      backgroundColor: white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: FutureBuilder(
                future: myFuture,
                builder: (context, snapshots) {
                  return snapshots.connectionState == ConnectionState.waiting
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: darkbluee,
                          ),
                        )
                      : favoritePageProvider.dataList.isEmpty
                          ? Center(
                              child: Container(
                                child: Text(
                                  'No Favourites items Found',
                                  style: TextStyle(
                                      color: darkbluee, fontSize: 18.spMax),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: favoritePageProvider.dataList.length,
                              itemBuilder: (context, index) {
                                splitWord(favoritePageProvider.dataList, index);
                                splitPartOfSpeech(
                                    favoritePageProvider.dataList, index);
                                splitDefination(
                                    favoritePageProvider.dataList, index);
                                splitSynonyms(
                                    favoritePageProvider.dataList, index);
                                splitAntonyms(
                                    favoritePageProvider.dataList, index);

                                return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 5.h),
                                    child: Card(
                                      elevation: 2,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 5.h),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        side:
                                            BorderSide(color: blue, width: 1.w),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 10.w, bottom: 10.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ExpandablePanel(
                                                header: ExpandableButton(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Word',
                                                          style: TextStyle(
                                                              fontSize: 20.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: darkbluee),
                                                        ),
                                                        Spacer(),
                                                        IconButton(
                                                            onPressed:
                                                                () async {
                                                              await Share.share(
                                                                  "Word: ${spiltword[0]}\nDefinition: ${splitdefination[index]}\nSynonyms: ${splitsynonyms}\nAntonyms: ${splitantonyms}");
                                                            },
                                                            icon: Icon(
                                                              Icons.share,
                                                              size: 20.spMax,
                                                            )),
                                                        IconButton(
                                                            onPressed:
                                                                () async {
                                                              dbHelper!.deleteSpecificDictionary(
                                                                  favoritePageProvider
                                                                      .dataList[
                                                                          index]
                                                                      .word);
                                                              await favoritePageProvider
                                                                  .loadData();
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .favorite_rounded,
                                                              color: darkbluee,
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                )),
                                                collapsed: Text(
                                                  spiltword[0],
                                                  style:
                                                      TextStyle(color: black),
                                                ),
                                                expanded: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          spiltword[0],
                                                          style: TextStyle(
                                                              color: black),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Part Of Speech',
                                                          style: TextStyle(
                                                              fontSize: 20.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: darkbluee),
                                                        ),
                                                      ],
                                                    ),
                                                    // Text(splitPartOfSpeech(snapshot, index)),
                                                    SizedBox(
                                                      child: ListView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount: a.length,
                                                          itemBuilder:
                                                              (contex, index) {
                                                            return Text(
                                                              a[index],
                                                              style: TextStyle(
                                                                  color: black),
                                                            );
                                                          }),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Definition',
                                                          style: TextStyle(
                                                              fontSize: 20.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: darkbluee),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      child: ListView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              splitdefination
                                                                  .length,
                                                          itemBuilder:
                                                              (contex, index) {
                                                            return Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          5),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    a[index] +
                                                                        " ",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Flexible(
                                                                    child: Text(
                                                                      splitdefination[
                                                                          index],
                                                                      style: TextStyle(
                                                                          color:
                                                                              black),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Synonyms',
                                                          style: TextStyle(
                                                              fontSize: 20.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: darkbluee),
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      child: ListView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              splitsynonyms
                                                                      .length -
                                                                  1,
                                                          itemBuilder:
                                                              (contex, index) {
                                                            return Row(
                                                              children: [
                                                                Container(
                                                                  height: 5.h,
                                                                  width: 5.w,
                                                                  decoration:
                                                                      new BoxDecoration(
                                                                    color:
                                                                        darkbluee,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 5.w,
                                                                ),
                                                                Text(
                                                                  splitsynonyms[
                                                                      index],
                                                                  style: TextStyle(
                                                                      color:
                                                                          black),
                                                                ),
                                                              ],
                                                            );
                                                          }),
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Antonyms',
                                                          style: TextStyle(
                                                              fontSize: 20.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: darkbluee),
                                                        ),
                                                      ],
                                                    ),
                                                    // Text(snapshot.data![index].antonyms
                                                    //     .toString()),

                                                    SizedBox(
                                                      child: ListView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              splitantonyms
                                                                      .length -
                                                                  1,
                                                          itemBuilder:
                                                              (contex, index) {
                                                            return Row(
                                                              children: [
                                                                Container(
                                                                  height: 5.h,
                                                                  width: 5.w,
                                                                  decoration:
                                                                      new BoxDecoration(
                                                                    color:
                                                                        darkbluee,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 5.w,
                                                                ),
                                                                Text(
                                                                  splitantonyms[
                                                                      index],
                                                                  style: TextStyle(
                                                                      color:
                                                                          black),
                                                                ),
                                                              ],
                                                            );
                                                          }),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ));
                              });
                }),
          ),
          favoritePageProvider.dataList.isNotEmpty
              ? Consumer2<WidgetProvider, InAppPurchaseController>(
                  builder: (context, value, value2, child) {
                  return isLoaded &&
                          value.getOpenAppAd == false &&
                          (!(value2.isMonthlyPurchased ||
                              value2.isYearlyPurchased))
                      ? Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: darkbluee)),
                              height: 140,
                              width: MediaQuery.of(context).size.width,
                              child: AdWidget(ad: _ad),
                            ),
                          ],
                        )
                      : SizedBox(
                          // height: 140,
                          );
                })
              : SizedBox()
        ],
      ),
    );
  }
}
