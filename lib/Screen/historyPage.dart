import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/Provider/history_provider.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:easy_dictionary_latest/Widget/RichTextWidget.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<void> _dataFuture;

  String b = '';
  var splitdefination = [];

  String splitDefination(String a) {
    splitdefination.clear();
    var p = a.toString().split('mobologics');
    for (var element in p) {
      b = b + element;
    }
    splitdefination = b.toString().split('  ');
    b = '';

    return splitdefination.isNotEmpty ? splitdefination[0] : '';
  }

  late NativeAd _ad;
  bool isLoaded = false;

  void loadNativeAd() {
    _ad = NativeAd(
      request: const AdRequest(),
      adUnitId: AdHelper.nativeAd,
      factoryId: 'small',
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    _ad.load();
  }

  @override
  void initState() {
    _dataFuture = _loadData();
    loadNativeAd();
    super.initState();
  }

  Future<void> _loadData() async {
    final historyProvider =
        Provider.of<HistoryProvider>(context, listen: false);
    await historyProvider.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Consumer<HistoryProvider>(
              builder: (context, historyProvider, child) {
                return FutureBuilder(
                  future: _dataFuture,
                  builder: (context, snapshot) {
                    var data = historyProvider.dataList.reversed.toList();
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      );
                    } else if (historyProvider.dataList.isEmpty) {
                      return Center(
                        child: Text(
                          'No History Found',
                          style:
                              TextStyle(color: darkbluee, fontSize: 18.spMax),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  elevation: 2,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    side: BorderSide(color: blue, width: 1.w),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.only(left: 10.w),
                                    title: RichTextWidget(
                                        label: "Word",
                                        content: data[index].word),
                                    subtitle: RichTextWidget(
                                        label: "Meaning",
                                        content: splitDefination(
                                            data[index].definition)),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            String word = "Word: " +
                                                data[index].word +
                                                "\nMeaning: " +
                                                splitDefination(
                                                    data[index].definition);
                                            await Share.share(word);
                                          },
                                          icon: Icon(
                                            Icons.share,
                                            color: darkbluee, // Adjusted color
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            final historyProvider =
                                                Provider.of<HistoryProvider>(
                                                    context,
                                                    listen: false);
                                            await historyProvider
                                                .DeleteSpecificSearchWord(
                                                    data[index].word);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors
                                                    .lightBlue, // Adjusted color
                                                content: Text(
                                                  '${data[index].word} has been deleted',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black), // Adjusted color
                                                ),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: darkbluee, // Adjusted color
                                          ),
                                        ),
                                      ],
                                    ),
                                  )));
                        },
                      );
                    }
                  },
                );
              },
            ),
          ),
          Consumer<HistoryProvider>(
            builder: (context, historyProvider, child) {
              return historyProvider.dataList.isNotEmpty
                  ? Consumer2<WidgetProvider, InAppPurchaseController>(
                      builder: (context, value, value2, child) {
                        return isLoaded &&
                                !value.getOpenAppAd &&
                                (!(value2.isMonthlyPurchased ||
                                    value2.isYearlyPurchased))
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: 5.h,
                                    left: 5.w,
                                    right: 5.w,
                                    bottom: 5.h),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blue), // Adjusted color
                                  ),
                                  height: 140,
                                  width: MediaQuery.of(context).size.width,
                                  child: AdWidget(ad: _ad),
                                ),
                              )
                            : SizedBox();
                      },
                    )
                  : SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
