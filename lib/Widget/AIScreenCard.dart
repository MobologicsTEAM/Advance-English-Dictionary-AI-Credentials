import 'package:easy_dictionary_latest/Provider/ai_provider.dart';
import 'package:easy_dictionary_latest/Widget/RichTextWidget.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class InfoCard extends StatelessWidget {
  InfoCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GeminiAPIController>(
      builder: (context, controller, child) => Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: BorderSide(color: blue, width: 1.w),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RichTextWidget(
                      label: 'Word',
                      content: controller.result?.word ?? 'unknown'),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      controller.toggleFavorite();
                    },
                    icon: Icon(
                        controller.isFavourite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: darkbluee),
                  ),
                ],
              ),
              RichTextWidget(
                  label: 'Meaning',
                  content: controller.result?.meaning ?? 'unknown'),
              SizedBox(height: 10.h),
              RichTextWidget(
                  label: 'Part Of Speech',
                  content: controller.result?.partOfSpeech ?? 'unknown'),
              SizedBox(height: 10.h),
              RichTextWidget(
                  label: 'Synonyms',
                  content: controller.result?.synonyms.join(', ') ?? 'unknown'),
              SizedBox(height: 10.h),
              RichTextWidget(
                  label: 'Antonyms',
                  content: controller.result?.antonyms.join(', ') ?? 'unknown'),
              SizedBox(height: 10.h),
              RichTextWidget(
                  label: 'Examples',
                  content: controller.result?.examples.join('\n') ?? 'unknown'),
              Padding(
                padding: EdgeInsets.only(left: 225.w),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        String result =
                            "Word: ${controller.result!.word}\nMeaning: ${controller.result!.meaning}\nPart Of Speech: ${controller.result!.partOfSpeech}\nSynonyms: ${controller.result!.synonyms}\nAntonyms: ${controller.result!.antonyms}\nExamples: ${controller.result!.examples}";
                        // print(controller.result!.toString());
                        Clipboard.setData(ClipboardData(text: result))
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copied text')));
                        });
                        // controller.toggleFavorite();
                      },
                      icon: Icon(Icons.copy, color: darkbluee),
                    ),
                    IconButton(
                      onPressed: () async {
                        String result =
                            "Word: ${controller.result!.word}\nMeaning: ${controller.result!.meaning}\nPart Of Speech: ${controller.result!.partOfSpeech}\nSynonyms: ${controller.result!.synonyms}\nAntonyms: ${controller.result!.antonyms}\nExamples: ${controller.result!.examples}";

                        await Share.share(result);
                      },
                      icon: Icon(
                        Icons.share,
                        color: darkbluee, // Adjusted color
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
