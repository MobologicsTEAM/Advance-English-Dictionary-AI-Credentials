// ignore_for_file: must_be_immutable

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator/translator.dart';

import '../../AddHelper/AdHelper.dart';
import '../../Provider/widgetProvider.dart';
import '../../constants.dart';
import '../Translator Screen/languages.dart';

class OfflineDictinoaryWordDetailScreen extends StatefulWidget {
  OfflineDictinoaryWordDetailScreen(
      {super.key,
      required this.word,
      required this.meaning,
      required this.partofspeech,
      required this.example1,
      required this.example2,
      required this.example3});
  String word;
  String meaning;
  String partofspeech;
  String example1;
  String example2;
  String example3;
  @override
  State<OfflineDictinoaryWordDetailScreen> createState() =>
      _OfflineDictinoaryWordDetailScreenState();
}

class _OfflineDictinoaryWordDetailScreenState
    extends State<OfflineDictinoaryWordDetailScreen> {
  String to_Code = "en";
  bool isLoading = false;
  final translator = GoogleTranslator();
  translate() async {
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.vpn) {
      try {
        setState(() {
          isLoading = true;
        });

        isLoading == true ? _showAlertDialog() : SizedBox();

        if (widget.meaning.isNotEmpty) {
          //translate meaning
          await translator
              .translate(
            widget.meaning,
            to: to_Code,
          )
              .then((value) {
            widget.meaning = value.toString();
          });
        }

        if (widget.partofspeech.isNotEmpty) {
          //translate partofspeech
          await translator
              .translate(
            widget.partofspeech,
            to: to_Code,
          )
              .then((value) {
            widget.partofspeech = value.toString();
          });
        }
        if (widget.example1.isNotEmpty) {
          //translate example1
          await translator
              .translate(
            widget.example1,
            to: to_Code,
          )
              .then((value) {
            widget.example1 = value.toString();
          });
        }

        if (widget.example2.isNotEmpty) {
          //translate example2
          await translator
              .translate(
            widget.example2,
            to: to_Code,
          )
              .then((value) {
            widget.example2 = value.toString();
          });
        }

        if (widget.example3.isNotEmpty) {
          //translate example3
          await translator
              .translate(
            widget.example3,
            to: to_Code,
          )
              .then((value) {
            widget.example3 = value.toString();
          });
        }

        await translator
            .translate(
          widget.word,
          to: to_Code,
        )
            .then((value) {
          setState(() {
            widget.word = value.toString();
            isLoading = false;
            Navigator.pop(context);
          });
        });
      } catch (errot) {
        print(errot);
      }
    }
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: darkbluee,
        content: Text('No Internet Connection'),
      ));
    }
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            content: Container(
          height: 60.h,
          width: 60.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40.h,
                width: 45.w,
                child: CircularProgressIndicator(
                  color: darkbluee,
                ),
              ),
            ],
          ),
        ));
      },
    );
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
  void initState() {
    loadNativeAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkbluee,
        title: Text(
          "Language",
          style: TextStyle(fontSize: 15.sp),
        ),
        // centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                    color: darkbluee.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5.r)),
                height: 40,
                width: 150.w,
                child: DropdownButton(
                  underline: SizedBox(),
                  value: to_Code,
                  isExpanded: true,
                  hint: Text('Select Language'),
                  style: TextStyle(color: Colors.black),
                  items: languagesList.map((map) {
                    return DropdownMenuItem(
                      child: Text(
                        map['Flag']! + "   " + map['languageName']!,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      value: map['code'],
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      to_Code = value as String;
                      translate();
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
            child: Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
                side: BorderSide(color: blue, width: 1.w),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Word : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: darkbluee),
                        ),
                        Text(widget.word),
                        Spacer(),
                        IconButton(
                            onPressed: () async {
                              await Share.share(
                                  "Word: ${widget.word}\nMeaning: ${widget.meaning}\nPart Of Speech: ${widget.partofspeech}\nExample1: ${widget.example1}\nExample2: ${widget.example2}\nExample3: ${widget.example3}");
                            },
                            icon: Icon(
                              Icons.share,
                              color: darkbluee,
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Meaning : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: darkbluee),
                        ),
                        Flexible(
                          child: Text(widget.meaning),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Part Of Speech : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: darkbluee),
                        ),
                        Flexible(
                          child: Text(widget.partofspeech),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Example 1 : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: darkbluee),
                        ),
                        Flexible(
                          child: Text(widget.example1),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Example 2 : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: darkbluee),
                        ),
                        Flexible(
                          child: Text(widget.example2),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Example 3 : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: darkbluee),
                        ),
                        Flexible(
                          child: Text(widget.example3),
                        ),
                      ],
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
                    height: 140,
                  );
          })
        ],
      ),
    );
  }
}
