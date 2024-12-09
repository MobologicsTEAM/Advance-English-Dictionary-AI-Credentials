import 'package:easy_dictionary_latest/AddHelper/AppOpenAdManager.dart';
import 'package:easy_dictionary_latest/AddHelper/InterstitialAdHelper.dart';
import 'package:easy_dictionary_latest/AddHelper/value.dart';
import 'package:easy_dictionary_latest/Provider/categoriesProvider.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Screen/AI%20Screen/gemini_ai.dart';
import 'package:easy_dictionary_latest/Screen/history&fav_tabs_screen.dart';
import 'package:easy_dictionary_latest/Screen/homePage.dart';
import 'package:easy_dictionary_latest/Screen/idiomsPage.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../Provider/offline_dictionary_provider.dart';
import '../Services/notification_services.dart';
import 'Home Screen/home_screen.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/MainPage';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    notification_permission();
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);
    InterstitialAdClass.createInterstitialAd();
  }

  notification_permission() async {
    final user = Provider.of<OfflineDictionaryProvider>(context, listen: false);
    await user.loadOfflineDictionaryData(); // Ensure the data is loaded first

    PermissionStatus status = await Permission.notification.status;

    if (status.isDenied) {
      await Permission.notification.request();
    } else {
      if (user.wordData.isNotEmpty) {
        final randomIndex = user.notification_word(); // Get a random index

        final randomWord = user
            .wordData[randomIndex]; // Ensure the same index is used for both

        await NotificationServices()
            .createNotification(context, randomWord.word, randomWord.meaning);

        print('*********************');
        print(randomIndex);
        print(randomWord.word);
        print(randomWord.meaning);
      }
      // });
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused) {
      print("Resumed==========================");

      if (Value.vl == true) {
        return;
      } else {
        appOpenAdManager.showAdIfAvailable(context);
        isPaused = false;
      }
    }
  }

  bool isFirstTime = true;

  @override
  void didChangeDependencies() {
    if (isFirstTime == true) {
      Provider.of<CategoriesProvider>(context).getCategoryFromDatabase();
      Provider.of<OfflineDictionaryProvider>(context)
          .loadOfflineDictionaryData();

      isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  //custom bottom navigation bar
  int _selectedIndex = 2;

  final tabs = [
    HomePage(),
    IdiomsPage(),
    HomeScreen(),
    HistoryandFavTab(),
    GeminiAI(),
  ];

  Widget bottomNavigationBarItems(String image, int index, String title) {
    InAppPurchaseController value2 =
        Provider.of<InAppPurchaseController>(context, listen: false);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
          tabs[_selectedIndex];
        });

        InterstitialAdClass.count++;
        if (InterstitialAdClass.count == InterstitialAdClass.limit &&
            (!(value2.isMonthlyPurchased || value2.isYearlyPurchased))) {
          InterstitialAdClass.showInterstitialAd(context);
          InterstitialAdClass.count = 0;
        }
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Container(
              decoration: index == _selectedIndex
                  ? BoxDecoration(
                      border: Border.all(color: white),
                      borderRadius: BorderRadius.circular(40.r),
                      color: white.withOpacity(0.3))
                  : BoxDecoration(color: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  image,
                  height: 26.h,
                  width: 29.w,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.w, left: 10.w),
            child: Text(
              title,
              style: TextStyle(color: white, fontSize: 10.spMax),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding:
              EdgeInsets.only(left: 5.w, right: 5.w, top: 5.w, bottom: 5.h),
          child: Container(
            height: 60.h,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1D93F3),
                    Color(0XFF1A8BE6),
                    Color(0xFF1781D7),
                    Color(0xFF1374C4),
                    Color(0xFF0F69B3),
                    Color(0xFF0B5EA2),
                    Color(0xFF0A5B9C),
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: BorderRadius.circular(25.r)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  bottomNavigationBarItems(
                      'assets/dictionary.png', 0, 'Dictionary'),
                  // bottomNavigationBarItems(
                  //     'assets/thesause.png', 1, 'Thesaurus'),
                  bottomNavigationBarItems(
                      'assets/idiomsHome.png', 1, "Idioms"),
                  bottomNavigationBarItems('assets/home.png', 2, 'Home'),

                  bottomNavigationBarItems(
                      'assets/historyHome.png', 3, 'History'),
                  bottomNavigationBarItems('assets/ai.png', 4, 'AI')
                ],
              ),
            ),
          ),
        ),
        body: tabs[_selectedIndex],
      ),
    );
  }
}
