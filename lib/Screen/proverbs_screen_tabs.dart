import 'package:easy_dictionary_latest/Provider/proverbProvider.dart';
import 'package:easy_dictionary_latest/Screen/proverbData.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../Provider/widgetProvider.dart';
import 'favProverbData.dart';

class ProverbsTabScreen extends StatefulWidget {
  static const routeName = '/proverbsScrren';
  const ProverbsTabScreen({Key? key}) : super(key: key);

  @override
  State<ProverbsTabScreen> createState() => _ProverbsTabScreenState();
}

class _ProverbsTabScreenState extends State<ProverbsTabScreen> {
  bool isKeyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    print("rebuild");
    isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0.0;
    print("Current Keyboard didchange visibility state: $isKeyboardVisible");
    final widgetProvider = Provider.of<WidgetProvider>(
      context,
    );

    final proverbProivder = Provider.of<ProverbProvider>(
      context,
    );
    return SafeArea(
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          if (didPop) {
            proverbProivder.changeText('');
            Provider.of<WidgetProvider>(context, listen: false)
                .toggleSearchAbleToFalse();
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
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: () {
                      widgetProvider.toggleSearchAbleToTrue();
                    },
                    child: widgetProvider.isSearchAble == false
                        ? Icon(
                            Icons.search,
                            color: white,
                          )
                        : InkWell(
                            onTap: () {
                              widgetProvider.toggleSearchAbleToFalse();
                              proverbProivder.changeText('');
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
                  proverbProivder.changeText('');
                  Provider.of<WidgetProvider>(context, listen: false)
                      .toggleSearchAbleToFalse();
                  Navigator.pop(context);
                },
                child: Icon(
                  FontAwesomeIcons.arrowLeft,
                  color: white,
                ),
              ),
              title: widgetProvider.isSearchAble
                  ? TextField(
                      onTapOutside: (PointerDownEvent event) {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (_) {
                        proverbProivder.changeText(_);
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
                  : Text(
                      'Proverbs',
                      style: TextStyle(color: white),
                    ),
            ),
            body: TabBarView(
              children: [
                ProverbData(
                  isKeyboardVisible: isKeyboardVisible,
                ),
                FavProverbData(
                  isKeyboardVisible: isKeyboardVisible,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
