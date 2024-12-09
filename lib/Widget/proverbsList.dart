import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../Provider/americanSlangsProvider.dart';
import '../Provider/britishSlangsProvider.dart';
import '../Provider/proverbProvider.dart';
import '../Provider/subcategoryProvider.dart';
import 'package:html/parser.dart' as html_parser; // HTML parser
import 'package:html/dom.dart' as dom;

class ProverbList extends StatelessWidget {
  final String proverb;
  final String defination;
  final String synonym;
  final int id;
  final int fav;
  final int catID;
  final bool isFav;
  final int pageNum;
  final String etymology;
  final String example;
  final String appBarTitle;

  ProverbList(
      {Key? key,
      this.catID = 0,
      this.appBarTitle = '',
      this.etymology = '',
      this.synonym = '',
      this.example = '',
      required this.pageNum,
      this.isFav = false,
      required this.defination,
      required this.proverb,
      required this.id,
      required this.fav})
      : super(key: key);

// html text convert into plain text
  String _copyTextToClipboard(String htmlContent) {
    // Parse HTML to plain text
    final dom.Document document = html_parser.parse(htmlContent);
    final String plainText = document.body?.text ?? '';
    return plainText;
  }

  @override
  Widget build(BuildContext context) {
    final proverbProvider =
        Provider.of<ProverbProvider>(context, listen: false);

    final britishSlangProvider =
        Provider.of<BritishSlangsProvider>(context, listen: false);

    final americanSlangsProvider =
        Provider.of<AmericanSlangsProvider>(context, listen: false);
    final subCategoryProvider =
        Provider.of<SubCategoryProvider>(context, listen: false);

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    String plainDefinationText =
                        _copyTextToClipboard(defination);
                    String plainTextExample = _copyTextToClipboard(example);
                    String plainTextEtymology = _copyTextToClipboard(etymology);
                    String plainTextSynonyms = _copyTextToClipboard(synonym);

                    if (pageNum == 1) {
                      await Share.share(
                          "proverb: ${proverb}\nDefinition: ${plainDefinationText}");
                    }
                    if (pageNum == 2) {
                      await Share.share(
                          "proverb: ${proverb}\nDefinition: ${plainDefinationText}");
                    }
                    if (pageNum == 3) {
                      await Share.share(
                          "Proverb: ${proverb}\nDefinition: ${plainDefinationText}\nEtymology: ${plainTextEtymology}\nExample: ${plainTextExample}\nSynonym:${plainTextSynonyms}");
                    }
                    if (pageNum == 4) {
                      await Share.share(
                          "Proverb: ${proverb}\nDefinition: ${plainDefinationText}\nExample: ${plainTextExample}");
                    }
                  },
                  child: Icon(
                    Icons.share,
                    color: darkbluee,
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
                InkWell(
                  onTap: () {
                    if (pageNum == 1) {
                      proverbProvider.updateFavouriteForProverb(
                          id, fav == 0 ? 1 : 0, defination, proverb);

                      if (isFav == true) {
                        proverbProvider.getFavProverbsFromModel();
                      }
                    }

                    if (pageNum == 2) {
                      britishSlangProvider.updateBritishSlangs(
                        id,
                        fav == 0 ? 1 : 0,
                        proverb,
                        defination,
                      );
                      if (isFav == true) {
                        britishSlangProvider
                            .getFavoriteBritishSlangsFromModel();
                      }
                    }

                    if (pageNum == 3) {
                      americanSlangsProvider.updateAmericanSlangs(
                          'American',
                          defination,
                          fav == 0 ? 1 : 0,
                          etymology,
                          example,
                          synonym,
                          id,
                          proverb);
                      if (isFav == true) {
                        americanSlangsProvider
                            .getAmericanFavoriteSlangsFromdb();
                      }
                    }
                    if (pageNum == 4) {
                      subCategoryProvider.updateSubCategory(defination, proverb,
                          id, fav == 0 ? 1 : 0, example, catID);
                    }
                  },
                  child: Icon(
                    color: darkbluee,
                    fav == 0
                        ? (Icons.favorite_border_outlined)
                        : (Icons.favorite_rounded),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                proverb,
                style: TextStyle(
                    fontSize: 16.spMax,
                    color: black.withOpacity(0.6),
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w, top: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: pageNum == 3 || pageNum == 4
                          ? Column(
                              children: [
                                HtmlWidget(
                                    '<span style="color: #ff2C7965"><b>Defination:</b>  </span>' +
                                        defination),
                                HtmlWidget(
                                    '<span style="color: #ff2C7965"><b>Example</b>  </span>' +
                                        example),
                                etymology.isNotEmpty
                                    ? HtmlWidget(
                                        '<span style="color: #ff2C7965"><b>Etymology<br></b></span>' +
                                            etymology)
                                    : SizedBox(),
                              ],
                            )
                          : RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Defination: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: darkbluee)),
                                  TextSpan(
                                    text: defination,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
