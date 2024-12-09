import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../Provider/subcategoryProvider.dart';
import '../Provider/widgetProvider.dart';
import '../Widget/favSubCategoryData.dart';
import '../Widget/subCategoryData.dart';

class SubCategoryTabs extends StatefulWidget {
  static const routeName = './subCategory';
  const SubCategoryTabs({Key? key}) : super(key: key);

  @override
  State<SubCategoryTabs> createState() => _SubCategoryTabsState();
}

class _SubCategoryTabsState extends State<SubCategoryTabs> {
  bool isKeyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    print("rebuild");
    isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0.0;
    print("Current Keyboard didchange visibility state: $isKeyboardVisible");
    final tabsData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    int index = tabsData['index'];

    String title = tabsData['subCategory'];

    final widgetProvider = Provider.of<WidgetProvider>(context);

    final subCategoryProvider = Provider.of<SubCategoryProvider>(context);

    return SafeArea(
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          if (didPop) {
            subCategoryProvider.changeText('');
            widgetProvider.togglesubCategorySearchAbleToFalse();
          }
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                labelColor: white,
                labelStyle:
                    TextStyle(fontSize: 15.spMax, fontWeight: FontWeight.w700),
                unselectedLabelColor: liteblue,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: liteblue,
                indicatorWeight: 5,
                tabs: [
                  Tab(
                    text: 'All',
                  ),
                  Tab(
                    text: 'Favourite',
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(
                    right: 8.w,
                  ),
                  child: InkWell(
                    onTap: () {
                      widgetProvider.togglesubCategorySearchAbleToTrue();
                    },
                    child: widgetProvider.subcategoriesSlangSearchAble == false
                        ? Icon(
                            Icons.search,
                            color: white,
                          )
                        : InkWell(
                            onTap: () {
                              widgetProvider
                                  .togglesubCategorySearchAbleToFalse();
                              subCategoryProvider.changeText('');
                            },
                            child: Icon(
                              Icons.cancel,
                              color: white,
                            )),
                  ),
                )
              ],
              backgroundColor: darkbluee,
              leading: InkWell(
                onTap: () {
                  widgetProvider.togglesubCategorySearchAbleToFalse();

                  Navigator.pop(context);
                },
                child: Icon(
                  FontAwesomeIcons.arrowLeft,
                ),
              ),
              title: widgetProvider.subcategoriesSlangSearchAble
                  ? TextField(
                      onTapOutside: (PointerDownEvent event) {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (_) {
                        subCategoryProvider.changeText(_);
                      },
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        contentPadding: EdgeInsets.only(left: 10.w),
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Text(title),
            ),
            body: TabBarView(
              children: [
                SubCategoryData(
                    index: index, isKeyboardVisible: isKeyboardVisible),
                FavSubCategoryData(
                    index: index, isKeyboardVisible: isKeyboardVisible),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
