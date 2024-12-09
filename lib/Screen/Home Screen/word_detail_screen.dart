// ignore_for_file: must_be_immutable
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/internetConnection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator/translator.dart';

import '../../AddHelper/AdHelper.dart';
import '../../Provider/favorite_page_provider.dart';
import '../../Provider/widgetProvider.dart';
import '../../constants.dart';
import '../Translator Screen/languages.dart';

class WordDetailScreen extends StatefulWidget {
  WordDetailScreen(
      {super.key,
      required this.word,
      required this.partsOfSpeech,
      required this.definition,
      required this.syn,
      required this.ant});
  //(word)
  List<String> word = [];
  //(partsOfSpeech)
  List<String> partsOfSpeech = [];
  //(definition)
  List<String> definition = [];
  //(synonyms)
  List<String> syn = [];
  //(antonyms)
  List<String> ant = [];
  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
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
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

//title word
  Card searchTitleData(String title, List<String> word,
      FavoritePageProvider favoritePageProvider) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        height: 70.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: white,
            border: Border.all(color: darkbluee.withOpacity(0.5))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: darkbluee),
                ),
                IconButton(
                    onPressed: () async {
                      try {
                        await screenshot();
                      } catch (error) {
                        print(error);
                      }
                    },
                    icon: Icon(
                      Icons.share,
                      color: darkbluee,
                    )),
              ],
            ),
            Flexible(
                child: Text(
              word[0],
              style: TextStyle(),
            )),
          ],
        ),
      ),
    );
  }

// //Part Of Speech

  Widget partOfSpeechData(String title, partOfSpeech) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20.sp, fontWeight: FontWeight.bold, color: darkbluee),
        ),
        SizedBox(
          height: 5.h,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: partOfSpeech.length,
          itemBuilder: (context, index) {
            return Text(partOfSpeech[index]);
          },
        ),
      ],
    );
  }

//   //definations

  Widget definations(String title, defination) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20.sp, fontWeight: FontWeight.bold, color: darkbluee),
        ),
        SizedBox(
          height: 5.h,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: defination.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Text(
                        widget.partsOfSpeech[index] + ":",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Flexible(
                      child: Text(
                        defination[index],
                      ),
                    ),
                  ],
                ),
              );
            })
      ],
    );
  }

// //synonyms
  Widget synonyms(String title, syc) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20.sp, fontWeight: FontWeight.bold, color: darkbluee),
        ),
        SizedBox(
          height: 5.h,
        ),
        widget.syn.isEmpty
            ? Center(
                child: Text(
                  'No Synonyms Found',
                  style: TextStyle(color: black.withOpacity(0.5)),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.syn.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 5.h,
                        width: 5.w,
                        decoration: new BoxDecoration(
                          color: darkbluee,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        syc[index],
                      ),
                    ],
                  );
                })
      ],
    );
  }

//antonyms
  Widget antonyms(String title, ant) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20.sp, fontWeight: FontWeight.bold, color: darkbluee),
        ),
        SizedBox(
          height: 5.h,
        ),
        ant.isEmpty
            ? Center(
                child: Text(
                  'No Antonyms Found',
                  style: TextStyle(color: black.withOpacity(0.5)),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: ant.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 5.h,
                        width: 5.w,
                        decoration: new BoxDecoration(
                          color: darkbluee,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        ant[index],
                      ),
                    ],
                  );
                })
      ],
    );
  }

  bool search = false;

  bool isLoding = false;
  String recordnotfount = '';
  recordNotFount() {
    widget.word.isEmpty
        ? recordnotfount = 'No Record Found'
        : recordnotfount = '';

    setState(() {});
  }

  Uint8List? _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  Future screenshot() async {
    await screenshotController.capture().then((Uint8List? image) {
      //Capture Done
      setState(() {
        _imageFile = image;
      });
    }).catchError((onError) {
      print(onError);
    });

    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    Directory folder = Directory('${appDocumentsDirectory.path}/screen_short');
    if (!await folder.existsSync()) {
      folder.createSync(recursive: true);
    }

    String sspath = "${folder.path}/ss.jpg";
    File(sspath).writeAsBytesSync(_imageFile!);

    XFile file = await XFile(sspath);
    await Share.shareXFiles([file]);
    print(_imageFile);
  }

  //translation
  final translator = GoogleTranslator();
  String to_Code = "en";
  bool isLoading = false;
  bool isTotranslated = false;
  //(word)
  List<String> word1 = [];
  //(partsOfSpeech)
  List<String> partsOfSpeech1 = [];
  //(definition)
  List<String> definition1 = [];
  //(synonyms)
  List<String> syn1 = [];
  //(antonyms)
  List<String> ant1 = [];
  translate() async {
    final connectivityProvider =
        Provider.of<ConnectivityProvider>(context, listen: false);
    if (connectivityProvider.isInternetAvailable) {
      try {
        setState(() {
          isLoading = true;
        });

        isLoading == true ? _showAlertDialog() : SizedBox();

        if (widget.partsOfSpeech.isNotEmpty) {
          for (int i = 0; i < widget.partsOfSpeech.length; i++) {
            await translator
                .translate(
              widget.partsOfSpeech[i],
              to: to_Code,
            )
                .then((value) {
              setState(() {
                widget.partsOfSpeech[i] = value.toString();
              });
            });
          }
        }
        if (widget.definition.isNotEmpty) {
          for (int i = 0; i < widget.definition.length; i++) {
            await translator
                .translate(
              widget.definition[i],
              to: to_Code,
            )
                .then((value) {
              setState(() {
                widget.definition[i] = value.toString();
              });
            });
          }
        }
        if (widget.syn.isNotEmpty) {
          for (int i = 0; i < widget.syn.length; i++) {
            await translator
                .translate(
              widget.syn[i],
              to: to_Code,
            )
                .then((value) {
              setState(() {
                widget.syn[i] = value.toString();
              });
            });
          }
        }
        if (widget.ant.isNotEmpty) {
          for (int i = 0; i < widget.ant.length; i++) {
            await translator
                .translate(
              widget.ant[i],
              to: to_Code,
            )
                .then((value) {
              setState(() {
                widget.ant[i] = value.toString();
              });
            });
          }
        }

        await translator
            .translate(
          widget.word[0],
          to: to_Code,
        )
            .then((value) {
          setState(() {
            widget.word[0] = value.toString();
            isLoading = false;
            Navigator.pop(context);
          });
        });
      } catch (errot) {
        print(errot);
      }
    } else {
      CustomSnackBar('No internet connection', context, red);
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
          child: Column(
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

  @override
  void initState() {
    loadNativeAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FavoritePageProvider favoritePageProvider =
        Provider.of<FavoritePageProvider>(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: darkbluee,
        title: Text(
          "Language",
          style: TextStyle(fontSize: 15.sp),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                    color: darkbluee.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5.0)),
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
                      translate();
                      to_Code = value as String;
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Screenshot(
        controller: screenshotController,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: ListView(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                isLoding
                    ? UnconstrainedBox(
                        child: CircularProgressIndicator(
                          color: darkbluee,
                        ),
                      )
                    : SizedBox(),
                widget.word.isEmpty
                    ? Container(
                        child: Center(
                          child: Text(
                            recordnotfount,
                            style: TextStyle(color: white.withOpacity(0.9)),
                          ),
                        ),
                      )
                    : ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          searchTitleData(
                              'Word',
                              widget.word.isEmpty ? [] : widget.word,
                              favoritePageProvider),
                          Consumer2<WidgetProvider, InAppPurchaseController>(
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
                                              border: Border.all(
                                                  color: darkbluee, width: 2)),
                                          height: 140,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: AdWidget(ad: _ad),
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox(
                                    height: 140,
                                  );
                          }),
                          Card(
                            elevation: 5,
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: white,
                                  border: Border.all(
                                      color: darkbluee.withOpacity(0.5))),
                              child: partOfSpeechData(
                                'Part Of Speech',
                                widget.partsOfSpeech.isEmpty
                                    ? ''
                                    : widget.partsOfSpeech,
                              ),
                            ),
                          ),
                          Card(
                            elevation: 5,
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: white,
                                  border: Border.all(
                                      color: darkbluee.withOpacity(0.5))),
                              child: definations(
                                'Definitions',
                                widget.definition.isEmpty
                                    ? ''
                                    : widget.definition,
                              ),
                            ),
                          ),
                          Card(
                            elevation: 5,
                            child: Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: white,
                                    border: Border.all(
                                        color: darkbluee.withOpacity(0.5))),
                                child: synonyms(
                                  'Synonyms',
                                  widget.syn,
                                )),
                          ),
                          Card(
                            elevation: 5,
                            child: Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: white,
                                    border: Border.all(
                                        color: darkbluee.withOpacity(0.5))),
                                child: antonyms(
                                  'Antonyms',
                                  widget.ant,
                                )),
                          ),
                          SizedBox(
                            height: 10.h,
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      )),
    ));
  }
}
