import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Screen/subCategoryTabs.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../Provider/categoriesProvider.dart';
import '../Provider/widgetProvider.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = './categoriesScreen';
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool iskeyboardVisible = false;
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
  Widget build(BuildContext context) {
    print("rebhild");
    iskeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    print('Keyboard visibility: $iskeyboardVisible');
    print('ViewInsets: ${MediaQuery.of(context).viewInsets.bottom}');

    final categoryList = Provider.of<CategoriesProvider>(context);
    final widgetProvider = Provider.of<WidgetProvider>(context);
    return SafeArea(
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          if (didPop) {
            categoryList.changeText('');
            widgetProvider.toggleCategorySearchAbleToFalse();
          }
        },
        child: Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            elevation: 0.0,
            flexibleSpace: Container(
                padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: darkbluee,
                )),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () {
                    widgetProvider.toggleCategorySearchAbleToTrue();
                  },
                  child: widgetProvider.categoriesSlangSearchAble == false
                      ? Icon(
                          Icons.search,
                          color: white,
                        )
                      : InkWell(
                          onTap: () {
                            categoryList.changeText('');
                            widgetProvider.toggleCategorySearchAbleToFalse();
                          },
                          child: Icon(
                            Icons.cancel,
                            color: white,
                          ),
                        ),
                ),
              )
            ],
            backgroundColor: Colors.transparent,
            leading: InkWell(
              onTap: () {
                categoryList.changeText('');
                widgetProvider.toggleCategorySearchAbleToFalse();
                Navigator.pop(context);
              },
              child: Icon(
                FontAwesomeIcons.arrowLeft,
                color: white,
              ),
            ),
            title: widgetProvider.categoriesSlangSearchAble
                ? TextField(
                    onChanged: (_) {
                      categoryList.changeText(_);
                    },
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      contentPadding: EdgeInsets.only(left: 10.w),
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Text(
                    'Popular Idioms',
                    style: TextStyle(color: white),
                  ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, SubCategoryTabs.routeName,
                              arguments: {
                                'subCategory': categoryList
                                    .getCategoryList[index].category,
                                'index':
                                    categoryList.getCategoryList[index].catID,
                              });
                        },
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            side: BorderSide(color: blue, width: 1.w),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                categoryList.getCategoryList[index].category,
                                style: TextStyle(
                                    color: darkbluee,
                                    fontSize: 20.spMax,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: categoryList.getCategoryList.length,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Visibility(
                  visible: !iskeyboardVisible,
                  child: Consumer2<WidgetProvider, InAppPurchaseController>(
                      builder: (context, value, value2, child) {
                    return isLoaded &&
                            value.getOpenAppAd == false &&
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
                  }))
            ],
          ),
        ),
      ),
    );
  }
}
