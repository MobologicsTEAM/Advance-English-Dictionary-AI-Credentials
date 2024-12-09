import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//const Color darkBlue = Color(0xff4188FF);
const Color darkbluee = Color(0xFF0F69B3);
const Color blue = Colors.blue;
Color lightblue = Colors.blue.shade300;
// const Color lightBlue = Color(0xff78AAFF);
const Color lightgreen = Color(0xff68B2A0);

const Color white = Color.fromARGB(255, 255, 255, 255);
const Color black = Color.fromARGB(255, 0, 0, 0);
const Color red = Colors.red;
Color liteblue = const Color.fromARGB(255, 179, 215, 245);


TextTheme textTheme = TextTheme(
  displayLarge: TextStyle(
      fontSize: 30.0.spMax,
      fontWeight: FontWeight.bold,
      color: white,
      fontFamily: 'Mulish'),
  displayMedium: TextStyle(
    fontSize: 26.0.spMax,
    color: white,
  ),
  displaySmall: TextStyle(fontSize: 20.spMax, color: white),
  headlineMedium: TextStyle(
    fontSize: 15.0.spMax,
    color: white,
  ),
);

TextTheme blackTextTheme = TextTheme(
    displayLarge: TextStyle(
        fontSize: 30.spMax, fontWeight: FontWeight.bold, color: black),
    displayMedium: TextStyle(fontSize: 26.spMax, color: black),
    displaySmall: TextStyle(
        fontSize: 15.spMax,
        color: black.withOpacity(0.7),
        fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(
        fontSize: 17.spMax,
        color: black.withOpacity(0.7),
        fontWeight: FontWeight.bold));

TextTheme blueTextTheme = TextTheme(
  headlineMedium:
      TextStyle(fontSize: 17.spMax, color: white, fontWeight: FontWeight.bold),
  displayLarge: TextStyle(
      fontSize: 30.spMax, fontWeight: FontWeight.bold, color: darkbluee),
  displayMedium: TextStyle(fontSize: 26.spMax, color: darkbluee),
  displaySmall: TextStyle(fontSize: 18.spMax, color: darkbluee),
  labelLarge: TextStyle(fontSize: 15.spMax, color: darkbluee),
);

 CustomSnackBar(String mesage, BuildContext context,Color color) {
  return ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text(mesage), backgroundColor: color,duration: Duration(milliseconds: 1500),));
}
