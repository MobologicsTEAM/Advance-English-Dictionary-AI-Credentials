import 'package:easy_dictionary_latest/AddHelper/InterstitialAdHelper.dart';
import 'package:easy_dictionary_latest/Provider/favorite_page_provider.dart';
import 'package:easy_dictionary_latest/Provider/history_provider.dart';
import 'package:easy_dictionary_latest/Screen/favouritePage.dart';
import 'package:easy_dictionary_latest/Screen/historyPage.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HistoryandFavTab extends StatefulWidget {
  const HistoryandFavTab({super.key});

  @override
  State<HistoryandFavTab> createState() => _HistoryandFavTabState();
}

class _HistoryandFavTabState extends State<HistoryandFavTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0), // Set the desired height
          child: AppBar(
              //centerTitle: true,
              title: Text(
                _tabController.index == 0 ? "History" : "Favourite",
                style: TextStyle(
                    color: white,
                    fontWeight: FontWeight.w700,
                    fontSize: 25.spMax),
              ),
              backgroundColor: darkbluee,
              bottom: TabBar(
                controller: _tabController,
                labelColor: white,
                labelStyle:
                    TextStyle(fontSize: 15.spMax, fontWeight: FontWeight.w700),
                unselectedLabelColor: liteblue,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: liteblue,
                indicatorWeight: 5,
                tabs: [
                  Tab(
                    text: 'History',
                  ),
                  Tab(
                    text: 'Favourite',
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: ((context) {
                            return AlertDialog(
                              title: Text(
                                'Warning!',
                                style: TextStyle(color: black),
                              ),
                              content: Text(
                                'Are you really want to delete ?',
                                style: TextStyle(color: black),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () async {
                                      InterstitialAdClass.showInterstitialAd(
                                          context);
                                      if (_tabController.index == 0) {
                                        await Provider.of<HistoryProvider>(
                                                context,
                                                listen: false)
                                            .DeleteAllSearchDictionary();
                                      } else {
                                        await Provider.of<FavoritePageProvider>(
                                                context,
                                                listen: false)
                                            .deleteAllFavorite();
                                      }

                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: darkbluee),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      InterstitialAdClass.showInterstitialAd(
                                          context);
                                      Navigator.pop(context);
                                    },
                                    child: Text('No',
                                        style: TextStyle(color: darkbluee))),
                              ],
                            );
                          }));
                    },
                    child: Icon(
                      Icons.delete,
                      color: white,
                    ),
                  ),
                ),
              ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            HistoryPage(),
            FavouritePage(),
          ],
        ),
      ),
    );
  }
}
