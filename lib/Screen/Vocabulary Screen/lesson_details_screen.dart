import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../AddHelper/AdHelper.dart';
import '../../Provider/class6_provider.dart';
import '../../Provider/widgetProvider.dart';
import '../../constants.dart';

// ignore: must_be_immutable
class LessonDetailsScreen extends StatefulWidget {
  LessonDetailsScreen({super.key, required this.id, required this.name});
  String id;
  String name;
  @override
  State<LessonDetailsScreen> createState() => _LessonDetailsScreenState();
}

class _LessonDetailsScreenState extends State<LessonDetailsScreen> {
  FlutterTts flutterTts = FlutterTts();
  speak(String text) async {
    await flutterTts.setLanguage('en');
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
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
    final class6Provider = Provider.of<Class6Provider>(context);

    final lesson_details_list = class6Provider.class6_lessonTbl_details
        .where((element) => element.lesson == widget.id)
        .toList();
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        elevation: 0,
        backgroundColor: darkbluee,
        title: FittedBox(
          child: Text(
            widget.name,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: lesson_details_list.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {},
                    child: Card(
                      margin: EdgeInsets.only(
                          left: 10.w, right: 10.w, top: 5.h, bottom: 5.h),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        side: BorderSide(color: blue, width: 1.w),
                      ),
                      child: ListTile(
                        title: Text(
                          lesson_details_list[index].word,
                          style: TextStyle(
                              color: black, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 5.h),
                          child: HtmlWidget(
                            lesson_details_list[index].example,
                            textStyle: TextStyle(color: darkbluee),
                          ),
                        ),
                        trailing: IconButton(
                            onPressed: () async {
                              await speak(lesson_details_list[index].word);
                            },
                            icon: Image.asset(
                              "assets/spacker.png",
                              color: darkbluee,
                              height: 25.h,
                            )),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          lesson_details_list.isNotEmpty
              ? Consumer2<WidgetProvider, InAppPurchaseController>(
                  builder: (context, value, value2, child) {
                  return isLoaded &&
                          value.getOpenAppAd == false &&
                          (!(value2.isMonthlyPurchased ||
                              value2.isYearlyPurchased))
                      ? Container(
                          margin:
                              EdgeInsets.only(left: 3.w, right: 3.w, top: 5.w),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: darkbluee,
                          )),
                          height: 140,
                          width: MediaQuery.of(context).size.width,
                          child: AdWidget(ad: _ad),
                        )
                      : SizedBox(
                          // height: 140,
                          );
                })
              : SizedBox(),
        ],
      ),
    );
  }
}
