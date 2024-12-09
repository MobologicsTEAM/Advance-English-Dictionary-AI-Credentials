import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/Provider/ai_provider.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/internetConnection.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:easy_dictionary_latest/Widget/AIScreenCard.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class GeminiAI extends StatefulWidget {
  const GeminiAI({super.key});

  @override
  State<GeminiAI> createState() => _GeminiAIState();
}

class _GeminiAIState extends State<GeminiAI> with WidgetsBindingObserver {
  late NativeAd _ad;
  bool isLoaded = false;
  GeminiAPIController? _controller;
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
    _controller = Provider.of<GeminiAPIController>(context);
  }

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
      }),
    );
    _ad.load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ad.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller?.clearData();
      _controller?.textEditingController.clear();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(children: [
                  Consumer<GeminiAPIController>(
                    builder: (context, controller, child) => Column(
                      children: [
                        Container(
                          height: 200.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/AIBanner.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.r),
                              bottomRight: Radius.circular(30.r),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 18.w, top: 30.h),
                                child: Text(
                                  "AI Dictionary",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25.spMax),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 17.w, top: 3.h),
                                child: Text(
                                  'Search Magic Words with AI Dictionary',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.spMax),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, top: 30.h, right: 10.w),
                                child: Consumer<ConnectivityProvider>(
                                  builder:
                                      (context, connectivityProvider, child) =>
                                          TextFormField(
                                    onTapOutside: (PointerDownEvent event) {
                                      FocusScope.of(context).unfocus();
                                      isAdShow = true;
                                      setState(() {});
                                    },
                                    onTap: () {
                                      isAdShow = false;
                                      setState(() {});
                                    },
                                    textInputAction: TextInputAction.search,
                                    onFieldSubmitted: (value) {
                                      if (value.isEmpty) {
                                        CustomSnackBar(
                                            'Search field cannot be empty',
                                            context,
                                            darkbluee);
                                      }

                                      if (!connectivityProvider
                                              .isInternetAvailable &&
                                          value.isNotEmpty) {
                                        CustomSnackBar(
                                            'No internet connection. Please check your network.',
                                            context,
                                            red);

                                        return;
                                      }

                                      controller.getGeminiData(controller
                                          .textEditingController.text);
                                    },
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                        borderSide: BorderSide(
                                            color: Colors.blue, width: 2.w),
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      suffixIcon: controller
                                              .textEditingController
                                              .text
                                              .isNotEmpty
                                          ? IconButton(
                                              icon: Icon(Icons.cancel_outlined),
                                              color: darkbluee,
                                              onPressed: () {
                                                controller.textEditingController
                                                    .clear();
                                              },
                                            )
                                          : SizedBox(),
                                      hintText: "Search the words with AI",
                                      hintStyle: TextStyle(
                                          fontSize: 15.spMax, color: blue),
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
                                    controller:
                                        controller.textEditingController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a search query';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        if (controller.isLoading)
                          Center(
                              child:
                                  CircularProgressIndicator(color: Colors.blue))
                        else if (controller.result != null)
                          InfoCard()
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
          if (isAdShow)
            Consumer2<WidgetProvider, InAppPurchaseController>(
                builder: (context, value, value2, child) {
              return isLoaded &&
                      value.getOpenAppAd == false &&
                      (!(value2.isMonthlyPurchased || value2.isYearlyPurchased))
                  ? Padding(
                      padding:
                          EdgeInsets.only(right: 3.w, left: 3.w, top: 270.h),
                      child: Consumer<GeminiAPIController>(
                          builder: (context, value, child) {
                        return (value.result == null)
                            ? Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: darkbluee)),
                                height: 355,
                                child: AdWidget(ad: _ad),
                              )
                            : SizedBox();
                      }),
                    )
                  : SizedBox();
            })
        ],
      ),
    );
  }
}
