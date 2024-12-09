import 'dart:ui';

import 'package:easy_dictionary_latest/Provider/ai_provider.dart';
import 'package:easy_dictionary_latest/Provider/americanSlangsProvider.dart';
import 'package:easy_dictionary_latest/Provider/britishSlangsProvider.dart';
import 'package:easy_dictionary_latest/Provider/categoriesProvider.dart';
import 'package:easy_dictionary_latest/Provider/favorite_page_provider.dart';
import 'package:easy_dictionary_latest/Provider/history_provider.dart';
import 'package:easy_dictionary_latest/Provider/home_ai_controller.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/internetConnection.dart';
import 'package:easy_dictionary_latest/Provider/premium_feature_controller.dart';
import 'package:easy_dictionary_latest/Provider/price_card_controller.dart';
import 'package:easy_dictionary_latest/Provider/proverbProvider.dart';
import 'package:easy_dictionary_latest/Provider/subcategoryProvider.dart';
import 'package:easy_dictionary_latest/Provider/theasaurusPageProvider.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:easy_dictionary_latest/Screen/AI%20Screen/gemini_ai.dart';
import 'package:easy_dictionary_latest/Screen/Home%20Screen/home_screen.dart';
import 'package:easy_dictionary_latest/Screen/categories_screen.dart';
import 'package:easy_dictionary_latest/Screen/mainPage.dart';
import 'package:easy_dictionary_latest/Screen/proverbs_screen_tabs.dart';
import 'package:easy_dictionary_latest/Screen/splash_screen.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import 'Provider/class6_provider.dart';
import 'Provider/offline_dictionary_provider.dart';
import 'Provider/quizProvider.dart';
import 'Screen/subCategoryTabs.dart';
import 'Services/notification_services.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InAppPurchaseController? inAppPurchaseController;
  await MobileAds.instance.initialize();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyCPwKwPzWgGDkb-bF54mYj6Z10vjCoyTCY',
    appId: '1:703330394162:android:7fb8e919a51ae856955c2b',
    messagingSenderId: '703330394162',
    projectId: 'easy-dictionary-473bb',
    storageBucket: 'easy-dictionary-473bb.appspot.com',
  ));

  await NotificationServices.initializeNotifications();

  FlutterError.onError = (errorDetails) {
    // If you wish to record a "non-fatal" exception, please use `FirebaseCrashlytics.instance.recordFlutterError` instead
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    // If you wish to record a "non-fatal" exception, please remove the "fatal" parameter
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  //  FirebaseCrashlytics.instance.crash();

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver(analytics: analytics);

  // Enable Firebase Analytics logging
  await analytics.setAnalyticsCollectionEnabled(true);

//InApp Purchase
  InAppPurchase instance = InAppPurchase.instance;
  inAppPurchaseController = InAppPurchaseController(
      inAppPurchaseInstance: instance,
      premiumFeatureController: PremiumFeatureController())
    ..initialize();

  await inAppPurchaseController.restorePurchases();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
    ChangeNotifierProvider(
      create: (context) => GeminiAPIController(),
      child: GeminiAI(),
    ),

    ChangeNotifierProvider(
      create: (context) => HomeAIController(),
      child: HomeScreen(),
    ),

    ChangeNotifierProvider(
      create: ((context) => AmericanSlangsProvider()),
    ),
    ChangeNotifierProvider(
      create: ((context) => WidgetProvider()),
    ),
    ChangeNotifierProvider(
      create: ((context) => BritishSlangsProvider()),
    ),
    ChangeNotifierProvider(
      create: ((context) => CategoriesProvider()),
    ),
    ChangeNotifierProvider(
      create: ((context) => SubCategoryProvider()),
    ),
    ChangeNotifierProvider(
      create: ((context) => ProverbProvider()),
    ),
    ChangeNotifierProvider(
      create: ((context) => HistoryProvider()),
    ),
    ChangeNotifierProvider(
      create: ((context) => FavoritePageProvider()),
    ),
    ChangeNotifierProvider(
      create: ((context) => TheasaurusPageProvider()),
    ),
    ChangeNotifierProvider(
      create: ((context) => OfflineDictionaryProvider()),
    ),
    ChangeNotifierProvider(
      create: ((context) => QuizProvider()),
    ),
    ChangeNotifierProvider(
      create: ((context) => PriceCardProvider()),
    ),
    ChangeNotifierProvider(
      create: ((context) => Class6Provider()),
    ),
    // Create PremiumFeatureController first
    ChangeNotifierProvider(create: (context) => PremiumFeatureController()),
    // Now InAppPurchaseController is dependent on PremiumFeatureController
    ChangeNotifierProvider<InAppPurchaseController?>.value(
      value: inAppPurchaseController,
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey:
              navigatorKey, // Assign the navigator key to the MaterialApp
          debugShowCheckedModeBanner: false,
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: white),
              titleTextStyle: TextStyle(color: white, fontSize: 20.spMax),
            ),

            //primarySwatch: Colors.green,
            textTheme: TextTheme(bodyMedium: TextStyle(color: black)),
          ),
          home: child,
          routes: {
            MainPage.routeName: (context) => const MainPage(),
            ProverbsTabScreen.routeName: (ctx) => const ProverbsTabScreen(),
            CategoriesScreen.routeName: ((context) => const CategoriesScreen()),
            SubCategoryTabs.routeName: ((context) => const SubCategoryTabs())
          },
        );
      },
      child: SplashScreen(),
    );
  }
}
