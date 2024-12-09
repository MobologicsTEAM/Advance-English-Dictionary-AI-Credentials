import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../Provider/americanSlangsProvider.dart';
import '../Provider/widgetProvider.dart';
import 'FavAmericanSlangsPage.dart';
import 'americanSlangsDatapage.dart';

class AmericanSlangTabs extends StatefulWidget {
  static const routeName = './AmericanSlangs';
  const AmericanSlangTabs({Key? key}) : super(key: key);

  @override
  State<AmericanSlangTabs> createState() => _AmericanSlangTabsState();
}

class _AmericanSlangTabsState extends State<AmericanSlangTabs> {
  bool isKeyboardVisible = false;
  @override
  Widget build(BuildContext context) {
    isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0.0;
    print("Current Keyboard didchange visibility state: $isKeyboardVisible");
    final widgetProvider = Provider.of<WidgetProvider>(context);

    final americanSlangsProvider = Provider.of<AmericanSlangsProvider>(context);
    return SafeArea(
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          if (didPop) {
            americanSlangsProvider.changeText('');
            Provider.of<WidgetProvider>(context, listen: false)
                .toggleAmericanSearchAbleToFalse();
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
                      widgetProvider.toggleAmericanSearchAbleToTrue();
                    },
                    child: widgetProvider.americanSlangSearchAble == false
                        ? Icon(
                            Icons.search,
                            color: white,
                          )
                        : InkWell(
                            onTap: () {
                              widgetProvider.toggleAmericanSearchAbleToFalse();
                              americanSlangsProvider.changeText('');
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
                  widgetProvider.toggleAmericanSearchAbleToFalse();
                  Navigator.pop(context);
                },
                child: Icon(
                  FontAwesomeIcons.arrowLeft,
                  color: white,
                ),
              ),
              title: widgetProvider.americanSlangSearchAble
                  ? TextField(
                      onTapOutside: (PointerDownEvent event) {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (_) {
                        americanSlangsProvider.changeText(_);
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
                      'American Slangs',
                      style: TextStyle(color: white),
                    ),
            ),
            body: TabBarView(
              children: [
                AmericanSlangsData(
                  isKeyboardVisible: isKeyboardVisible,
                ),
                FavAmericanSlangs(
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
