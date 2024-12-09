import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RichTextWidget extends StatelessWidget {
  const RichTextWidget({
    super.key,
    required this.label,
    required this.content,
  });

  final String label;

  final String content;

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 20,
      overflow: TextOverflow.ellipsis,
      // Optional: adds ellipsis if text overflows
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: TextStyle(
              color: blue, // Color for the label part
              fontSize: 16.spMax, // Font size for the label part
              fontWeight: FontWeight.bold, // Bold for the label part
            ),
          ),
          TextSpan(
            text: content.isNotEmpty ? content : 'unknown',
            style: TextStyle(
              color: black, // Color for the content part
              fontSize: 14.spMax, // Smaller font size for the content part
            ),
          ),
        ],
      ),
    );
  }
}
