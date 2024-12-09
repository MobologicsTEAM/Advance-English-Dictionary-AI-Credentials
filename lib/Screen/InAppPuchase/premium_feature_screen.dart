import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/premium_feature_controller.dart';
import 'package:easy_dictionary_latest/Screen/InAppPuchase/subscription_info_screen.dart';
import 'package:easy_dictionary_latest/Screen/mainPage.dart';
import 'package:easy_dictionary_latest/Widget/inAppPurchaseScreenWidgets/subscription_button.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Widget/inAppPurchaseScreenWidgets/price_card_widget.dart';

class PremiumScreen extends StatefulWidget {
  final bool isSplash;
  const PremiumScreen({super.key, required this.isSplash});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  late final PremiumFeatureController premiumController;
  late final InAppPurchaseController inAppPurchaseController;

  @override
  void initState() {
    super.initState();

    // Initialize the InAppPurchaseController
    inAppPurchaseController =
        Provider.of<InAppPurchaseController>(context, listen: false);

    // Initialize the PremiumFeatureController
    premiumController =
        Provider.of<PremiumFeatureController>(context, listen: false);

    // Accessing the provider instance after widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (inAppPurchaseController.productDetailsList.isEmpty) {
        inAppPurchaseController.getData();
      } else {
        print("Data already exists");
      }
    });
  }

//   @override
//   Widget build(BuildContext context) {
//      var mq = MediaQuery.of(context).size;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Consumer<InAppPurchaseController>(
//         builder: (context, controller, child) {
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Your existing widget code here
//                 // Example of accessing the controller data
//                 controller.isLoaded
//                     ? Text('Data Loaded')
//                     : CircularProgressIndicator(),
//                 Consumer<PremiumFeatureController>(
//                   builder: (context, premiumC, child) {
//                     return Text('Selected Plan: ${premiumC.selectedPlan}');
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<InAppPurchaseController>(
            builder: (context, controller, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // First section: Banner
                Container(
                  height: mq.height * 0.3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.white, // White shade
                        Colors.blue, // Replace with your primary color
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Stack(
                      children: [
                        CarouselSlider(
                          items: [
                            Image.asset("assets/dictinaryhome.png",
                                fit: BoxFit.cover),
                            Image.asset("assets/vocab.png", fit: BoxFit.cover),
                            Image.asset("assets/phraseHome.png",
                                fit: BoxFit.cover),
                          ],
                          options: CarouselOptions(
                            height: mq.height * 0.18,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.5,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 1200),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.45,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100.r),
                            onTap: () {
                              if (widget.isSplash) {
                                Navigator.pushReplacementNamed(
                                    context, MainPage.routeName);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 6.w, top: 10.h),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100.r),
                                    color: Colors.white),
                                child: Icon(Icons.close, color: Colors.red),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Upgrade to Premium & Get",
                                style: TextStyle(
                                  fontSize: mq.height * 0.025,
                                  color: darkbluee,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Unlimited Access",
                                style: TextStyle(
                                  fontSize: mq.height * 0.030,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: mq.height * 0.02),
                // Second section: Features
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.white, Colors.white],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        CarouselSlider(
                          items: [
                            FeatureCard(
                              mq: mq,
                              iconPath: "assets/ai.png",
                              title: "Ask AI",
                              content: "Ask Ai everything",
                            ),
                            FeatureCard(
                              mq: mq,
                              iconPath: "assets/noAd.png",
                              title: "No Ads",
                              content: "100% ad free experience",
                            ),
                            FeatureCard(
                              mq: mq,
                              iconPath: "assets/idiomsHome.png",
                              title: "Idioms",
                              content: "Popular Idioms",
                            ),
                            FeatureCard(
                              mq: mq,
                              iconPath: "assets/trans.png",
                              title: "Translator",
                              content: "Translate to languages",
                            ),
                          ],
                          options: CarouselOptions(
                            height: mq.height * 0.15,
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.5,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 1200),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.3,
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                        SizedBox(height: mq.height * 0.02),
                        // Price cards
                        !controller.isLoaded
                            ? Column(
                                children: [
                                  PriceCard(
                                    index: 0,
                                    onPressed: () {
                                      if (inAppPurchaseController
                                              .monthlyProduct !=
                                          null) {
                                        premiumController.changeSelectedPlan(
                                            inAppPurchaseController
                                                .monthlyProduct!.id);
                                      }
                                    },
                                    title: "Monthly Plan",
                                    price: inAppPurchaseController
                                            .monthlyProduct?.price ??
                                        "",
                                    // price: inAppPurchaseController
                                    //     .monthlyProduct!.price,
                                    description: inAppPurchaseController
                                            .monthlyProduct?.description ??
                                        "",
                                  ),

                                  SizedBox(height: mq.height * 0.01),
                                  Instruction(),
                                  //SizedBox(height: mq.height * 0.01),
                                  PriceCard(
                                    index: 1,
                                    onPressed: () {
                                      if (inAppPurchaseController
                                              .yearlyProduct !=
                                          null) {
                                        premiumController.changeSelectedPlan(
                                            inAppPurchaseController
                                                .yearlyProduct!.id);
                                      }
                                    },
                                    title: "Yearly Plan",
                                    price: inAppPurchaseController
                                            .yearlyProduct?.price ??
                                        '',
                                    description: inAppPurchaseController
                                            .yearlyProduct?.description ??
                                        '',
                                  ),

                                  SizedBox(height: mq.height * 0.01),
                                  Instruction(),
                                ],
                              )
                            : Center(child: CircularProgressIndicator()),
                        SizedBox(
                          height: 5.h,
                        ),
                        Consumer<PremiumFeatureController>(
                            builder: (context, premiumC, child) {
                          return SubscriptionButton(
                            premC: premiumC,
                          );
                        }),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SubscriptionInfoScreen()));
                              },
                              child: Text(
                                "Terms & Conditions",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: mq.height * 0.018,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _launchURL(Uri.parse(
                                    "https://support.google.com/googleplay/answer/7018481?co=GENIE.Platform%3DAndroid&hl=en"));
                              },
                              child: Text(
                                "How to unsubscribe?",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: mq.height * 0.018,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: mq.height * 0.01),
              ],
            ),
          );
        }));
  }

  _launchURL(Uri url) async {
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }
  }
}

class FeatureCard extends StatelessWidget {
  final String iconPath;
  final String title;
  final String content;
  const FeatureCard({
    super.key,
    required this.mq,
    required this.iconPath,
    required this.title,
    required this.content,
  });

  final Size mq;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mq.width * 0.4,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(color: darkbluee),
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(36, 33, 149, 243)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Image.asset(
              iconPath,
              height: 30,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Instruction extends StatelessWidget {
  const Instruction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 5.w),
        Image.asset(
          "assets/arrow.png",
          height: 15.h,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            "Cancel anytime atleast 24 hours before renewal",
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13.sp),
          ),
        ),
      ],
    );
  }
}
