import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/quizProvider.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:easy_dictionary_latest/Screen/Home%20Screen/Quiz%20Screen/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int selected_button_index = -1;
  String answer = '';
  void _selectButton(int buttonIndex, String ans) {
    setState(() {
      selected_button_index = buttonIndex;
      answer = ans;
    });
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
    QuizProvider quizProvider =
        Provider.of<QuizProvider>(context, listen: false);
    quizProvider.quizData.shuffle();
    quizProvider.question_number_index = 0;
    quizProvider.question_number = 1;
    quizProvider.total_marks = 0;
    super.initState();
  }

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QuizProvider quizProvider =
        Provider.of<QuizProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: darkbluee,
          title: Text("Quiz"),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                      height: 40.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        ),
                        color: darkbluee,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Q. " + quizProvider.question_number.toString(),
                            style: textTheme.displaySmall,
                          ),
                        ],
                      )),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                      color: darkbluee,
                    ),
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      quizProvider.quizData[quizProvider.question_number_index]
                          .question,
                      style: textTheme.displaySmall,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  InkWell(
                    onTap: () {
                      _selectButton(
                          0,
                          quizProvider
                              .quizData[quizProvider.question_number_index]
                              .answerA);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: selected_button_index == 0 ? blue : liteblue,
                            border: Border.all(color: darkbluee)),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: darkbluee,
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: Center(
                                  child: Text(
                                "A",
                                style: textTheme.displaySmall,
                              )),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Flexible(
                              child: Text(
                                quizProvider
                                    .quizData[
                                        quizProvider.question_number_index]
                                    .answerA,
                                style: TextStyle(
                                    color: selected_button_index == 0
                                        ? white
                                        : black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  InkWell(
                    onTap: () {
                      _selectButton(
                          1,
                          quizProvider
                              .quizData[quizProvider.question_number_index]
                              .answerB);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: selected_button_index == 1 ? blue : liteblue,
                            border: Border.all(color: darkbluee)),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: darkbluee,
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: Center(
                                  child: Text(
                                "B",
                                style: textTheme.displaySmall,
                              )),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Flexible(
                              child: Text(
                                quizProvider
                                    .quizData[
                                        quizProvider.question_number_index]
                                    .answerB,
                                style: TextStyle(
                                    color: selected_button_index == 1
                                        ? white
                                        : black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  InkWell(
                    onTap: () {
                      _selectButton(
                          2,
                          quizProvider
                              .quizData[quizProvider.question_number_index]
                              .answerC);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: selected_button_index == 2 ? blue : liteblue,
                            border: Border.all(color: darkbluee)),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: darkbluee,
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: Center(
                                  child: Text(
                                "C",
                                style: textTheme.displaySmall,
                              )),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Flexible(
                              child: Text(
                                quizProvider
                                    .quizData[
                                        quizProvider.question_number_index]
                                    .answerC,
                                style: TextStyle(
                                    color: selected_button_index == 2
                                        ? white
                                        : black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  InkWell(
                    onTap: () {
                      _selectButton(
                          3,
                          quizProvider
                              .quizData[quizProvider.question_number_index]
                              .answerD);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: selected_button_index == 3 ? blue : liteblue,
                            border: Border.all(color: darkbluee)),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: darkbluee,
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: Center(
                                  child: Text(
                                "D",
                                style: textTheme.displaySmall,
                              )),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Flexible(
                              child: Text(
                                quizProvider
                                    .quizData[
                                        quizProvider.question_number_index]
                                    .answerD,
                                style: TextStyle(
                                    color: selected_button_index == 3
                                        ? white
                                        : black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
                height: 40.h,
                width: 150.w,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: black.withOpacity(0.4),
                        blurRadius: 5,
                        offset: Offset(0, 2)),
                  ],
                  borderRadius: BorderRadius.circular(10.r),
                  color: darkbluee,
                ),
                child: TextButton(
                    onPressed: () async {
                      if (selected_button_index == -1) {
                        // Show a SnackBar when no option is selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(milliseconds: 1000),
                            content: Text('Please choose at least one option'),
                            backgroundColor: Colors
                                .red, // You can customize the color if needed
                          ),
                        );
                      } else if (quizProvider.question_number_index < 9) {
                        if (answer ==
                            quizProvider
                                .quizData[quizProvider.question_number_index]
                                .correctAnswer) {
                          print("Correct Answer");
                          quizProvider.increment_total_marks();
                          print(quizProvider.total_marks.toString());
                        } else {
                          print("Wrong Answer");
                        }
                        quizProvider.increment_question_number_index();
                        quizProvider.increment_question_number();
                        setState(() {
                          selected_button_index = -1;
                        });
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultScreen(
                                      marks: quizProvider.total_marks,
                                    )));
                      }
                    },
                    child: Text('Next',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: white,
                        )))),
            Spacer(),
            Consumer2<WidgetProvider, InAppPurchaseController>(
                builder: (context, value, value2, child) {
              return isLoaded &&
                      value.getOpenAppAd == false &&
                      (!(value2.isMonthlyPurchased || value2.isYearlyPurchased))
                  ? Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: darkbluee)),
                      height: 150,
                      //width: MediaQuery.of(context).size.width,
                      child: AdWidget(ad: _ad),
                    )
                  : SizedBox();
            })
          ],
        ),
      ),
    );
  }
}
