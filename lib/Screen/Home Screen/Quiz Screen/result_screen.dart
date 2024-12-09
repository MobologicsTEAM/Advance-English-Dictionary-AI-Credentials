// ignore_for_file: must_be_immutable

import 'package:easy_dictionary_latest/Screen/Home%20Screen/Quiz%20Screen/quizScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../AddHelper/InterstitialAdHelper.dart';
import '../../../constants.dart';

class ResultScreen extends StatefulWidget {
  ResultScreen({super.key, required this.marks});
  int marks;
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    if (InterstitialAdClass.interstitialAd != null)
      InterstitialAdClass.showInterstitialAd(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkbluee,
        title: Text("Result"),
      ),
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: white,
        child: Padding(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                    border: Border.all(color: darkbluee),
                    color: liteblue,
                    borderRadius: BorderRadius.circular(20.r)),
                height: 400.h,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150.h,
                      child: widget.marks < 5
                          ? Lottie.asset('assets/fail.json')
                          : Lottie.asset('assets/pass.json'),
                    ),
                    Text(
                      widget.marks.toString() + '0% Score',
                      style: blueTextTheme.headlineLarge,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Quiz Completed Sucessfully.',
                      style: blackTextTheme.bodyLarge,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: Text(
                        'You attempt 10 questions and ${widget.marks.toString()} answers is/are correct.',
                        style: blackTextTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    UnconstrainedBox(
                      child: Container(
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
                              onPressed: () {
                                InterstitialAdClass.showInterstitialAd(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QuizScreen()));
                              },
                              child: Text('Play Again',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: white,
                                  )))),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
