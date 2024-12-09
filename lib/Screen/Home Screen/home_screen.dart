import 'dart:developer';

import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/AddHelper/InterstitialAdHelper.dart';
import 'package:easy_dictionary_latest/Provider/home_ai_controller.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/internetConnection.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:easy_dictionary_latest/Screen/Home%20Screen/word_detail_screen.dart';
import 'package:easy_dictionary_latest/Screen/InAppPuchase/premium_feature_screen.dart';
import 'package:easy_dictionary_latest/Screen/thesaurusPage.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../Offline Dictionary/offline_dictionary_screen.dart';
import '../Translator Screen/translator_screen.dart';
import '../Vocabulary Screen/vocabulary_main_screen.dart';
import '../categories_screen.dart';
import 'Quiz Screen/quizScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  HomeAIController? _controller;
  final _formKey = GlobalKey<FormState>();
  bool isAdShow = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadNativeAd();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = Provider.of<HomeAIController>(context, listen: false);
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
          log("Ad is loaded");
          isLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        log("Ad failed to load");
        setState(() {
          isLoaded = false;
          _ad == null;
        });
        ad.dispose();
      }),
    );

    _ad.load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller?.clearData();
    });

    _ad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    InAppPurchaseController value2 =
        Provider.of<InAppPurchaseController>(context, listen: false);
    print("_______");
    print(isLoaded);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(children: [
            // Background Image
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    margin: EdgeInsets.only(bottom: 10.h),
                    child: ListView(children: [
                      Column(
                        children: [
                          Container(
                            height: 100.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/dicBanner.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.w, top: 15.h, right: 10.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Easy Dictionary",
                                          style: TextStyle(
                                              color: white,
                                              fontSize: 27.spMax)),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.h),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const PremiumScreen(
                                                          isSplash: true)),
                                            );
                                          },
                                          child: Container(
                                            height: 30.h,
                                            width: 100.w,
                                            decoration: BoxDecoration(
                                                color: Color(0xffE1FF41),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.r)),
                                            child: Center(
                                                child: Text(
                                              "Upgrade",
                                              style: TextStyle(color: black),
                                            )),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 27.w, top: 3.h),
                                  child: Text(
                                      "From A to Z, We've Got You Covered",
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: white, fontSize: 13.spMax)),
                                ),
                              ],
                            ),
                          ),
                          // Main Column with content
                          Consumer<HomeAIController>(
                              builder: (context, controller, child) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 15.w,
                                            right: 15.w,
                                            top: 30.h,
                                            bottom: 10.h),
                                        child: Consumer<ConnectivityProvider>(
                                          builder:
                                              (context, connectivity, child) =>
                                                  Form(
                                            key: _formKey,
                                            child: TextFormField(
                                              onTap: () {
                                                isAdShow = false;
                                                setState(() {});
                                              },
                                              onTapOutside:
                                                  (PointerDownEvent event) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                isAdShow = true;
                                                setState(() {});
                                              },
                                              onChanged: (query) {
                                                controller
                                                    .updateSuggestions(query);
                                              },
                                              onFieldSubmitted: (value) async {
                                                if (!_formKey.currentState!
                                                    .validate()) {
                                                  return;
                                                }
                                                controller.setSuggestion(false);

                                                if (!connectivity
                                                        .isInternetAvailable &&
                                                    value.isNotEmpty) {
                                                  CustomSnackBar(
                                                      'No internet connection. Please check your network.',
                                                      context,
                                                      red);
                                                  return;
                                                }
                                                await controller.getGeminiData(
                                                    controller
                                                        .textEditingController
                                                        .text);

                                                if (controller.result != null) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          WordDetailScreen(
                                                        word: [
                                                          controller
                                                              .result!.word
                                                        ],
                                                        partsOfSpeech: [
                                                          controller.result!
                                                              .partOfSpeech
                                                        ],
                                                        definition: [
                                                          controller.result!
                                                              .definition
                                                        ],
                                                        syn: controller
                                                            .result!.synonyms,
                                                        ant: controller
                                                            .result!.antonyms,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              style: TextStyle(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      width: 1.w),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      width: 2.w),
                                                ),
                                                fillColor: Color(0xffF0F0F0F0),
                                                filled: true,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                                suffixIcon: controller
                                                        .textEditingController
                                                        .text
                                                        .isNotEmpty
                                                    ? IconButton(
                                                        icon: Icon(Icons
                                                            .cancel_outlined),
                                                        color: darkbluee,
                                                        onPressed: () {
                                                          controller
                                                              .textEditingController
                                                              .clear(); // Clear the text
                                                          controller
                                                              .setSuggestion(
                                                                  false);
                                                        },
                                                      )
                                                    : SizedBox(),
                                                hintText:
                                                    "Search the words with AI",
                                                hintStyle: TextStyle(
                                                    fontSize: 15.spMax,
                                                    color: blue),
                                                prefixIcon: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.w, right: 5.w),
                                                  child: Icon(
                                                    Icons.search,
                                                    color: darkbluee,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                              controller: controller
                                                  .textEditingController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a search query';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      controller.isLoading == true
                                          ? Center(
                                              child: SizedBox(
                                                height: 30.h,
                                                width: 30.w,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: darkbluee,
                                                ),
                                              ),
                                            )
                                          : SizedBox(),

                                      if (controller.showSuggestion)
                                        SizedBox(
                                          height:
                                              50.h, // Adjust height if needed
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20.w),
                                              child: Row(
                                                children: controller
                                                    .filteredSuggestions
                                                    .map((suggestion) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 8.w),
                                                    child: ChoiceChip(
                                                      label: Text(suggestion),
                                                      showCheckmark: false,
                                                      selected: controller
                                                              .selectedSuggestion ==
                                                          suggestion,
                                                      selectedColor: lightblue,
                                                      onSelected:
                                                          (isSelected) async {
                                                        if (isSelected) {
                                                          controller
                                                              .selectSuggestion(
                                                                  suggestion); // Update selected chip

                                                          // Perform the search
                                                          await controller
                                                              .getGeminiData(
                                                                  suggestion);

                                                          // Navigate to the next screen if data is available
                                                          if (controller
                                                                  .result !=
                                                              null) {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        WordDetailScreen(
                                                                  word: [
                                                                    controller
                                                                        .result!
                                                                        .word
                                                                  ],
                                                                  partsOfSpeech: [
                                                                    controller
                                                                        .result!
                                                                        .partOfSpeech
                                                                  ],
                                                                  definition: [
                                                                    controller
                                                                        .result!
                                                                        .definition
                                                                  ],
                                                                  syn: controller
                                                                      .result!
                                                                      .synonyms,
                                                                  ant: controller
                                                                      .result!
                                                                      .antonyms,
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),

                                      SizedBox(
                                          height: 20.h), // Add some spacing
                                      // Cards for Offline Dictionary and others
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildCard('assets/offlineDict.png',
                                              "Offline Dictionary", () {
                                            InterstitialAdClass.count++;
                                            if (InterstitialAdClass.count ==
                                                    InterstitialAdClass.limit &&
                                                (!(value2.isMonthlyPurchased ||
                                                    value2
                                                        .isYearlyPurchased))) {
                                              InterstitialAdClass
                                                  .showInterstitialAd(context);
                                              InterstitialAdClass.count = 0;
                                            }
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        OfflineDictionaryScreen())));
                                          }),
                                          _buildCard(
                                              'assets/vocab.png', "Vocabulary",
                                              () {
                                            InterstitialAdClass.count++;
                                            if (InterstitialAdClass.count ==
                                                    InterstitialAdClass.limit &&
                                                (!(value2.isMonthlyPurchased ||
                                                    value2
                                                        .isYearlyPurchased))) {
                                              InterstitialAdClass
                                                  .showInterstitialAd(context);
                                              InterstitialAdClass.count = 0;
                                            }
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        VocabularyMainScreen())));
                                          }),
                                          _buildCard(
                                              'assets/trans.png', "Translator",
                                              () {
                                            InterstitialAdClass.count++;
                                            if (InterstitialAdClass.count ==
                                                    InterstitialAdClass.limit &&
                                                (!(value2.isMonthlyPurchased ||
                                                    value2
                                                        .isYearlyPurchased))) {
                                              InterstitialAdClass
                                                  .showInterstitialAd(context);
                                              InterstitialAdClass.count = 0;
                                            }
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        TranslatorScreen())));
                                          }),
                                        ],
                                      ),
                                      SizedBox(height: 10.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          _buildCard('assets/thesaurus.png',
                                              "Thesaurus", () {
                                            InterstitialAdClass.count++;
                                            if (InterstitialAdClass.count ==
                                                    InterstitialAdClass.limit &&
                                                (!(value2.isMonthlyPurchased ||
                                                    value2
                                                        .isYearlyPurchased))) {
                                              InterstitialAdClass
                                                  .showInterstitialAd(context);
                                              InterstitialAdClass.count = 0;
                                            }
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        ThesaurusPage())));
                                          }),
                                          _buildCard('assets/phraseHome.png',
                                              "Popular Idioms", () {
                                            InterstitialAdClass.count++;
                                            if (InterstitialAdClass.count ==
                                                    InterstitialAdClass.limit &&
                                                (!(value2.isMonthlyPurchased ||
                                                    value2
                                                        .isYearlyPurchased))) {
                                              InterstitialAdClass
                                                  .showInterstitialAd(context);
                                              InterstitialAdClass.count = 0;
                                            }
                                            Navigator.pushNamed(context,
                                                CategoriesScreen.routeName);
                                          }),
                                          _buildCard('assets/quiz.png', "Quiz",
                                              () {
                                            InterstitialAdClass.count++;
                                            if (InterstitialAdClass.count ==
                                                    InterstitialAdClass.limit &&
                                                (!(value2.isMonthlyPurchased ||
                                                    value2
                                                        .isYearlyPurchased))) {
                                              InterstitialAdClass
                                                  .showInterstitialAd(context);
                                              InterstitialAdClass.count = 0;
                                            }
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        QuizScreen())));
                                          }),
                                        ],
                                      ),
                                    ],
                                  ))
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            if (isAdShow && _controller!.textEditingController.text.isEmpty)
              Consumer2<WidgetProvider, InAppPurchaseController>(
                  builder: (context, value, value2, child) {
                return isLoaded &&
                        value.getOpenAppAd == false &&
                        (!(value2.isMonthlyPurchased ||
                            value2.isYearlyPurchased))
                    ? Positioned(
                        top: 440.h,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: darkbluee)),
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          child: AdWidget(ad: _ad),
                        ),
                      )
                    : SizedBox();
                // : Container(
                //     height: 150,
                //     color: red,
                //     child: Text(
                //         "ad not shown $isLoaded ${value.getOpenAppAd} ${value2.isMonthlyPurchased} ${value2.isYearlyPurchased}))}"));
              })
          ]),
        ));
  }

  Widget _buildCard(String image, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 77.h,
        width: 108.w,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: darkbluee),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 45.h,
            ),
            SizedBox(height: 3.h),
            Text(
              label,
              style: TextStyle(color: black, fontSize: 10.spMax),
            ),
          ],
        ),
      ),
    );
  }
}
