import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Provider/price_card_controller.dart';
// Replace with the correct path

class PriceCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final bool highlight;
  final VoidCallback onPressed;
  final int index;
  final Color? color;

  const PriceCard({
    Key? key,
    required this.title,
    required this.price,
    required this.description,
    this.highlight = false,
    required this.onPressed,
    required this.index,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final mq = MediaQuery.of(context).size;
    // final provider = Provider.of<PriceCardProvider>(context);

    return Consumer<PriceCardProvider>(
      builder: (context, value, child) => GestureDetector(
        onTap: () {
          onPressed(); // Trigger the callback
          value.updateSelectedIndex(index); // Update the selected index
        },
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: darkbluee), // Replace `mainClr` with your color
              color: value.selectedIndex == index ? darkbluee : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: value.selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      Text(
                        price,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: value.selectedIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    description,
                    style: TextStyle(
                      color: value.selectedIndex == index
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  if (highlight)
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Save 70%',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
