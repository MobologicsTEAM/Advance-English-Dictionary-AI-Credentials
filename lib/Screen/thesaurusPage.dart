import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/theasaurusPageProvider.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:easy_dictionary_latest/Screen/thesaurusDetailsPage.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class ThesaurusPage extends StatefulWidget {
  const ThesaurusPage({super.key});

  @override
  State<ThesaurusPage> createState() => _ThesaurusPageState();
}

class _ThesaurusPageState extends State<ThesaurusPage> {
  bool iskeyboardVisible = false;
  TextEditingController searchController = TextEditingController();

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
    iskeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    TheasaurusPageProvider theasaurusPageProvider =
        Provider.of<TheasaurusPageProvider>(
      context,
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        body: Column(
          children: [
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/dicBanner.png'),
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
                  SizedBox(height: 20.h),
                  Row(children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: white,
                        )),
                    SizedBox(width: 5.w),
                    Text(
                      "Thesaurus",
                      style: TextStyle(
                          color: white,
                          fontSize: 22.spMax,
                          fontWeight: FontWeight.w500),
                    )
                  ]),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 17.w, right: 15.w, top: 20.h),
                    child: TextFormField(
                      style: TextStyle(color: black),
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) {},
                      onChanged: (_) {
                        theasaurusPageProvider
                            .changeText(searchController.text);
                      },
                      keyboardType: TextInputType.text,
                      controller: searchController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: darkbluee,
                            size: 30.sp,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.cancel_outlined),
                            color: darkbluee,
                            onPressed: () {
                              searchController.clear();
                            },
                          ),
                          filled: true,
                          fillColor: white,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: darkbluee),
                              borderRadius: BorderRadius.circular(10.r)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2.w, color: darkbluee),
                              borderRadius: BorderRadius.circular(10.r)),
                          hintText: 'Search a word',
                          hintStyle: TextStyle(color: blue, fontSize: 14.sp)),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: theasaurusPageProvider.wordList.length,
                    itemBuilder: (contex, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(color: blue, width: 1.w),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (contex) => ThesaurusDetailsPage(
                                              word: [
                                                theasaurusPageProvider
                                                    .wordList[index].word
                                                    .split('\n')[0]
                                                    .toString()
                                              ],
                                              definition: [
                                                theasaurusPageProvider
                                                    .wordList[index].definition
                                                    .split('\n')[0]
                                                    .toString()
                                              ],
                                              synonyms: [
                                                theasaurusPageProvider
                                                    .wordList[index].synonyms
                                                    .split('\n')[0]
                                                    .toString()
                                              ],
                                              antonyms: [
                                                theasaurusPageProvider
                                                    .wordList[index].antonyms
                                                    .split('\n')[0]
                                                    .toString()
                                              ])));
                            },
                            title: Center(
                              child: Text(
                                theasaurusPageProvider.wordList[index].word
                                    .split('\n')[0]
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 20.spMax,
                                    color: darkbluee,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
            Visibility(
                visible: !iskeyboardVisible,
                child: Consumer2<WidgetProvider, InAppPurchaseController>(
                    builder: (context, value, value2, child) {
                  return isLoaded &&
                          value.getOpenAppAd == false &&
                          (!(value2.isMonthlyPurchased ||
                              value2.isYearlyPurchased))
                      ? Container(
                          margin:
                              EdgeInsets.only(top: 5.h, right: 3.w, left: 3.w),
                          decoration: BoxDecoration(
                              border: Border.all(color: darkbluee)),
                          height: 140,
                          width: MediaQuery.of(context).size.width,
                          child: AdWidget(ad: _ad),
                        )
                      : SizedBox(
                          //  height: 140,
                          );
                }))
          ],
        ),
      ),
    );
  }
}
