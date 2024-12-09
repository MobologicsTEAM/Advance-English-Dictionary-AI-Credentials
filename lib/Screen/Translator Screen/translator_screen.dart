import 'package:avatar_glow/avatar_glow.dart';
import 'package:easy_dictionary_latest/AddHelper/InterstitialAdHelper.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/internetConnection.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:easy_dictionary_latest/Screen/Translator%20Screen/languages.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

import '../../AddHelper/AdHelper.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  TextEditingController textEditingController = TextEditingController();
  final translator = GoogleTranslator();
  String from_Code = "en";
  String to_Code = "ur";
  String to_translated_text = '';
  bool isTotranslated = false;
  bool isLoading = false;
  bool isCopied = false;

  int currentIndex = 0;
  int currentPresenterVoicesIndex = 0;

  bool isListining = false;

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  // ignore: unused_field
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    loadNativeAd();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    if (_speechEnabled) {
      await _speechToText.listen(
        onResult: (result) {
          print(result);
          setState(() {
            textEditingController.text = result.recognizedWords;
          });
        },
      );
    } else {
      print("Not Available");
    }
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  bool isAdShow = true;

  late NativeAd _ad;
  bool isLoaded = false;
  final _formKey = GlobalKey<FormState>();

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
  void dispose() {
    _ad.dispose();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // @override
  // void didChangeMetrics() {
  //   // Handle window metrics changes here
  //   super.didChangeMetrics();
  // }

  @override
  Widget build(BuildContext context) {
    InAppPurchaseController value2 =
        Provider.of<InAppPurchaseController>(context, listen: false);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: white),
            elevation: 0,
            backgroundColor: darkbluee,
            title: Text(
              "Translator",
              style: TextStyle(color: white, fontWeight: FontWeight.w500),
            ),
          ),
          body: Stack(children: [
            Column(
              children: [
                Expanded(
                  child: ListView(children: [
                    Column(children: [
                      Container(
                        color: darkbluee,
                        height: 55.h,
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Card(
                                elevation: 3,
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  decoration: BoxDecoration(
                                      color: darkbluee.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  height: 40,
                                  width: 150.w,
                                  child: DropdownButton(
                                    underline: SizedBox(),
                                    value: from_Code,
                                    isExpanded: true,
                                    hint: Text('Select Language'),
                                    style: TextStyle(color: Colors.black),
                                    items: languagesList.map((map) {
                                      return DropdownMenuItem(
                                        child: Text(
                                          map['Flag']! +
                                              "   " +
                                              map['languageName']!,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                        value: map['code'],
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        from_Code = value as String;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.arrow_forward_outlined,
                                  size: 20.sp,
                                  color: white,
                                ),
                              ),
                              Card(
                                elevation: 3,
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
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
                                      print(
                                          "total languages  ${languagesList.length}");
                                      return DropdownMenuItem(
                                        child: Text(
                                          map['Flag']! +
                                              "   " +
                                              map['languageName']!,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                        value: map['code'],
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        to_Code = value as String;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Consumer<ConnectivityProvider>(
                          builder: (context, connectivity, child) => Form(
                            key: _formKey,
                            child: TextFormField(
                              onTap: () {
                                isAdShow = false;
                                setState(() {});
                              },
                              keyboardType: TextInputType.multiline,

                              maxLines: 5,
                              minLines: 1, // Minimum number of lines to show
                              onTapOutside: (PointerDownEvent event) {
                                FocusScope.of(context).unfocus();
                                isAdShow = true;
                                setState(() {});
                              },
                              textInputAction: TextInputAction.search,
                              onFieldSubmitted: (value) async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                setState(() {
                                  isCopied = false;
                                });
                                FocusScope.of(context).unfocus();
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a search query';
                                }
                                return null;
                              },
                              // keyboardType: TextInputType.text,
                              controller: textEditingController,
                              cursorColor: darkbluee,
                              decoration: InputDecoration(
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isListining = !isListining;
                                        });
                                        if (isListining == false) {
                                          print("yes listning");
                                          _stopListening();
                                        } else {
                                          _startListening();
                                        }
                                      },
                                      icon: isListining == true
                                          ? AvatarGlow(
                                              //endRadius: 30,
                                              glowColor: darkbluee,
                                              child: Icon(
                                                Icons.mic,
                                                color: darkbluee,
                                              ),
                                            )
                                          : Icon(
                                              Icons.mic,
                                              size: 25.sp,
                                              color: darkbluee,
                                            ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          textEditingController.clear();
                                          setState(() {
                                            isTotranslated = false;
                                          });
                                        },
                                        icon: Icon(Icons.cancel_outlined,
                                            color: darkbluee, size: 20.sp))
                                  ],
                                ),
                                errorStyle: TextStyle(color: red),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: red),
                                    borderRadius: BorderRadius.circular(5.r)),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                fillColor: white,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: darkbluee),
                                    borderRadius: BorderRadius.circular(5.r)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.w),
                                ),
                                hintText: 'Enter text for translation',
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15.spMax),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      isLoading == false
                          ? Consumer<ConnectivityProvider>(
                              builder: (context, controller, child) => InkWell(
                                onTap: () async {
                                  InterstitialAdClass.count++;
                                  if (InterstitialAdClass.count ==
                                          InterstitialAdClass.limit &&
                                      (!(value2.isMonthlyPurchased ||
                                          value2.isYearlyPurchased))) {
                                    InterstitialAdClass.showInterstitialAd(
                                        context);
                                    InterstitialAdClass.count = 0;
                                  }
                                  if (from_Code.isEmpty) {
                                    CustomSnackBar(
                                        'Please select a source language.',
                                        context,
                                        Colors.red);
                                    return;
                                  }

                                  if (to_Code.isEmpty) {
                                    CustomSnackBar(
                                        'Please select a target language.',
                                        context,
                                        Colors.red);
                                    return;
                                  }

                                  if (textEditingController.text.isEmpty) {
                                    CustomSnackBar(
                                        'Please enter text for translation.',
                                        context,
                                        red);
                                    return;
                                  }

                                  setState(() {
                                    isListining = false;
                                    isCopied = false;
                                    isLoading = true;
                                  });

                                  FocusScope.of(context).unfocus();

                                  // Check for empty text or no internet connection

                                  if (!controller.isInternetAvailable) {
                                    CustomSnackBar(
                                        'No internet connection. Please check your network.',
                                        context,
                                        red);
                                    return;
                                  } else {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    // Attempt translation
                                    translator
                                        .translate(textEditingController.text,
                                            from: from_Code, to: to_Code)
                                        .then((value) {
                                      setState(() {
                                        to_translated_text = value.toString();
                                        isLoading = false;
                                        isTotranslated = true;
                                        print(to_translated_text.toString());
                                      });
                                    }).catchError((error) {
                                      // Catch errors specific to the translation process
                                      setState(() {
                                        isLoading = false;
                                      });
                                      print(error);
                                      CustomSnackBar(
                                          'Translation error occurred: $error',
                                          context,
                                          red);
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: darkbluee,
                                    borderRadius: BorderRadius.circular(5.0.r),
                                  ),
                                  height: 30.h,
                                  width: 100.w,
                                  child: Center(
                                    child: Text("Translate",
                                        style: TextStyle(color: white)),
                                  ),
                                ),
                              ),
                            )
                          : CircularProgressIndicator(
                              color: darkbluee,
                            ),
                      SizedBox(
                        height: 30.h,
                      ),
                      isTotranslated
                          ? Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0.r),
                                  border: Border.all(color: darkbluee)),
                              width: double.infinity,
                              // height: 50.h,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        to_translated_text.toString(),
                                        textAlign: TextAlign.left,
                                        // Adjust overflow to handle long texts
                                        overflow: TextOverflow
                                            .ellipsis, // or TextOverflow.clip, TextOverflow.fade
                                        maxLines:
                                            100, // or set it to null for unlimited lines
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    InkWell(
                                      onTap: () async {
                                        await Clipboard.setData(ClipboardData(
                                            text: to_translated_text));

                                        setState(() {
                                          isCopied = true;
                                        });
                                        // Show a SnackBar when text is copied
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Text copied',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            backgroundColor: darkbluee,
                                          ),
                                        );
                                      },
                                      child: isCopied == true
                                          ? Icon(
                                              Icons.file_copy,
                                              color: darkbluee,
                                            )
                                          : Icon(
                                              Icons.file_copy_outlined,
                                              color: darkbluee,
                                            ),
                                    ),
                                  ],
                                ),
                              ))
                          : SizedBox()
                    ]),
                  ]),
                ),
              ],
            ),
            if (textEditingController.text.isEmpty && isAdShow)
              Consumer2<WidgetProvider, InAppPurchaseController>(
                  builder: (context, value, value2, child) {
                return isLoaded &&
                        value.getOpenAppAd == false &&
                        (!(value2.isMonthlyPurchased ||
                            value2.isYearlyPurchased))
                    ? Container(
                        margin:
                            EdgeInsets.only(left: 3.w, right: 3.w, top: 300.h),
                        decoration:
                            BoxDecoration(border: Border.all(color: darkbluee)),
                        height: 360,
                        width: MediaQuery.of(context).size.width,
                        child: AdWidget(ad: _ad),
                      )
                    : SizedBox();
              })
          ])),
    );
  }
}
