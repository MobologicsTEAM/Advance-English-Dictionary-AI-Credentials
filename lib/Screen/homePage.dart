// ignore_for_file: body_might_complete_normally_nullable

import 'dart:async';
import 'dart:convert';

import 'package:easy_dictionary_latest/AddHelper/AdHelper.dart';
import 'package:easy_dictionary_latest/AddHelper/InterstitialAdHelper.dart';
import 'package:easy_dictionary_latest/Helper/dbHelper.dart';
import 'package:easy_dictionary_latest/Helper/dbHelperIdioms.dart';
import 'package:easy_dictionary_latest/Model/dbModel.dart';
import 'package:easy_dictionary_latest/Model/modelClass.dart';
import 'package:easy_dictionary_latest/Model/searchWordModel.dart';
import 'package:easy_dictionary_latest/Provider/favorite_page_provider.dart';
import 'package:easy_dictionary_latest/Provider/in_app_purchase_controller.dart';
import 'package:easy_dictionary_latest/Provider/internetConnection.dart';
import 'package:easy_dictionary_latest/Provider/widgetProvider.dart';
import 'package:easy_dictionary_latest/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  FocusNode focusNode = FocusNode();
  //(word)
  List<String> word = [];
  //(partsOfSpeech)
  List<String> partsOfSpeech = [];
  //(definition)
  List<String> definition = [];
  //(synonyms)
  List<String> syn = [];
  //(antonyms)
  List<String> ant = [];

  //get data from api
  Future getData() async {
    setState(() {
      isLoding = true;
    });
    FocusManager.instance.primaryFocus!.unfocus();
    word.clear();
    definition.clear();
    partsOfSpeech.clear();
    syn.clear();
    ant.clear();

    var response = await http.get(Uri.parse(
        "https://api.dictionaryapi.dev/api/v2/entries/en/${searchController.text}"));

    setState(() {
      search = true;
    });

    var decode = jsonDecode(response.body);

    final a = decode[0]['word'];

    final b = decode[0]['meanings'] as List;
    final c = decode[0]['meanings'] as List;
    final d = decode[0]['meanings'][0]['synonyms'] as List;
    final e = decode[0]['meanings'][0]['antonyms'] as List;
    // final listOfMaps = decode[0]['meanings'] as List;

    ModelClass modelClass = ModelClass(
      word: a.length == 0 ? '---' : a,
      partOfSpeech: b.length == 0 ? '---' : b,
      definition: c.length == 0
          ? '---'
          : decode[0]['meanings'][0]['definitions'][0]['definition'],
      synonyms: d.length == 0 ? '---' : decode[0]['meanings'][0]['synonyms'],
      antonyms: e.length == 0 ? '---' : decode[0]['meanings'][0]['antonyms'],
    );

    //fatch (word) from api and save in var word = [];
    word.add(modelClass.word.toString());

    //fatch (partsOfSpeech) from api and save var partsOfSpeech = [];
    for (int i = 0; i < b.length; i++) {
      definition.add(b[i]['definitions'][0]['definition']);
    }
    //fatch (partsOfSpeech) from api and save var partsOfSpeech = [];
    for (int i = 0; i < c.length; i++) {
      partsOfSpeech.add(c[i]['partOfSpeech']);
    }
    //fatch (synonyms) from api and save var syn = [];
    for (int i = 0; i < d.length; i++) {
      syn.add(d[i]);
    }
    //fatch (antonyms) from api and save var ant = [];
    for (int i = 0; i < e.length; i++) {
      ant.add(e[i]);
    }

    setState(() {});
    getWordList();
    getPartOfSpeechList();
    getDefinitionList();
    getSynonymsList();
    getAntonymsList();

    // print(modelClass.synonyms);
  }

  //insert data in data base
  DbHelper? dbHelper;

  @override
  void initState() {
    super.initState();
    keyboardActive();
    dbHelper = DbHelper();
    loadData();
    DbHelperIdioms.initDb();
    loadNativeAd();
  }

  late List<DbModel> dataList;

  Future loadData() async {
    dbHelper!.getData().then((value) => dataList = value);
    dbHelper!.getsearchWordData();
  }

  void keyboardActive() {
    FavoritePageProvider favoritePageProvider =
        Provider.of<FavoritePageProvider>(context, listen: false);
    // Add listener to focus node to monitor keyboard state
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        favoritePageProvider.SetkeybaordActive(true);
      } else {
        favoritePageProvider.SetkeybaordActive(false);
      }
    });
  }

  String wordList = '';
  String partofspeechList = '';
  String definitionList = '';
  String synonymsList = '';
  String antonymsList = '';

  String getWordList() {
    for (int i = 0; i < word.length; i++) {
      // wordList = wordList + word[i] + ' mobologics ';
      wordList = wordList + word[i];
    }
    return wordList;
  }

  String getPartOfSpeechList() {
    for (int i = 0; i < partsOfSpeech.length; i++) {
      partofspeechList = partofspeechList + partsOfSpeech[i] + ' mobologics ';
    }
    return partofspeechList;
  }

  String getDefinitionList() {
    for (int i = 0; i < definition.length; i++) {
      definitionList = definitionList + definition[i] + ' mobologics ';
    }
    return definitionList;
  }

  String getSynonymsList() {
    for (int i = 0; i < syn.length; i++) {
      synonymsList = synonymsList + syn[i] + ' mobologics ';
    }
    return synonymsList;
  }

  String getAntonymsList() {
    for (int i = 0; i < ant.length; i++) {
      antonymsList = antonymsList + ant[i] + ' mobologics ';
    }
    return antonymsList;
  }

  void insertData() async {
    dbHelper?.insert(DbModel(
      word: wordList,
      partOfSpeech: partofspeechList,
      definition: definitionList,
      synonyms: synonymsList,
      antonyms: antonymsList,
    ));
    print('added');
  }

  void insertsearchword() async {
    dbHelper?.insertSearchDictionary(
        SearchWord(word: wordList, definition: definitionList));
    print('SearchWordDataAdded');
  }

  var iconUnselected = Icon(
    Icons.favorite_border_outlined,
    size: 30.sp,
    color: darkbluee,
  );
  var iconSelected = Icon(
    Icons.favorite_rounded,
    size: 30.sp,
    color: darkbluee,
  );

  bool icon = true;

//title word
  searchTitleData(String title, List<String> word,
      FavoritePageProvider favoritePageProvider) {
    return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
          side: BorderSide(color: blue, width: 1.w),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          height: 80.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: darkbluee),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      if (favourite == false) {
                        insertData();
                        setState(() {
                          favourite = !favourite;
                        });
                      } else if (favourite == true) {
                        dbHelper!
                            .deleteSpecificDictionary(searchController.text);
                        setState(() {
                          favourite = !favourite;
                        });
                        favoritePageProvider.loadDataSep();
                      }
                    },
                    icon: favourite == true
                        ? Icon(
                            Icons.favorite_rounded,
                            color: darkbluee,
                          )
                        : Icon(
                            Icons.favorite_border_outlined,
                            color: darkbluee,
                          ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await Share.share(
                          "word: ${word.toString()}\nPart Of Speech: ${partsOfSpeech}\nDefinitions: ${definition}\nSynonyms: ${syn.isNotEmpty ? syn : "No Synonyms Found"}\nAntonyms: ${ant.isNotEmpty ? ant : "No Antonyms Found"}");
                    },
                    icon: Icon(
                      Icons.share,
                      color: darkbluee, // Adjusted color
                    ),
                  ),
                ],
              ),
              Flexible(
                  child: Text(
                word[0],
                style: TextStyle(),
              )),
            ],
          ),
        ));
  }

//Part Of Speech

  Widget partOfSpeechData(String title, partOfSpeech) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20.sp, fontWeight: FontWeight.bold, color: darkbluee),
        ),
        SizedBox(
          height: 5.h,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: partOfSpeech.length,
          itemBuilder: (context, index) {
            return Text(partOfSpeech[index]);
          },
        ),
      ],
    );
  }

  //definations

  Widget definations(String title, defination) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20.sp, fontWeight: FontWeight.bold, color: darkbluee),
        ),
        SizedBox(
          height: 5.h,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: defination.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Text(
                        partsOfSpeech[index] + ":",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Flexible(
                      child: Text(
                        defination[index],
                      ),
                    ),
                  ],
                ),
              );
            })
      ],
    );
  }

//synonyms
  Widget synonyms(String title, syc) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20.sp, fontWeight: FontWeight.bold, color: darkbluee),
        ),
        SizedBox(
          height: 5.h,
        ),
        syn.isEmpty
            ? Center(
                child: Text(
                  'No Synonyms Found',
                  style: TextStyle(color: black.withOpacity(0.5)),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: syn.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 5.h,
                        width: 5.w,
                        decoration: new BoxDecoration(
                          color: darkbluee,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        syc[index],
                      ),
                    ],
                  );
                })
      ],
    );
  }

//antonyms
  Widget antonyms(String title, ant) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 20.sp, fontWeight: FontWeight.bold, color: darkbluee),
        ),
        SizedBox(
          height: 5.h,
        ),
        ant.isEmpty
            ? Center(
                child: Text(
                  'No Antonyms Found',
                  style: TextStyle(color: black.withOpacity(0.5)),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: ant.length,
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 5.h,
                        width: 5.w,
                        decoration: new BoxDecoration(
                          color: darkbluee,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        ant[index],
                      ),
                    ],
                  );
                })
      ],
    );
  }

  bool search = false;
  bool isAdShow = true;
  bool favourite = false;
  //for loding data when user search
  bool isLoding = false;
  String recordnotfount = '';
  recordNotFount() {
    word.isEmpty ? recordnotfount = 'No Record Found' : recordnotfount = '';

    setState(() {});
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  late NativeAd _ad;
  bool isLoaded = false;

  void loadNativeAd() {
    _ad = NativeAd(
        request: const AdRequest(),
        adUnitId: AdHelper.nativeAd,
        factoryId: 'listTile',
        listener: NativeAdListener(onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
        }));

    _ad.load();
  }

  @override
  void dispose() {
    super.dispose();
    _ad.dispose();
  }

  String text = '';
  void changeText(String searchword) {
    setState(() {
      text = searchword;
    });
  }

  @override
  Widget build(BuildContext context) {
    InAppPurchaseController value2 =
        Provider.of<InAppPurchaseController>(context, listen: false);
    FavoritePageProvider favoritePageProvider =
        Provider.of<FavoritePageProvider>(context, listen: false);
    return SafeArea(
        child: Scaffold(
            body: Stack(children: [
      Column(
        children: [
          Expanded(
            child: ListView(children: [
              Form(
                key: _formKey,
                child: Container(
                  height: 220.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/dicBanner.png',
                      ), // Correct the path to 'assets'
                      fit: BoxFit
                          .cover, // Ensures the image covers the entire container
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30.r),
                        bottomRight: Radius.circular(30.r)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 25.w, top: 40.h),
                        child: Text("Easy Dictionary",
                            style: TextStyle(color: white, fontSize: 25.spMax)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 27.w, top: 5.h),
                        child: Text(
                            "Unlock a world of words with our Dictionary App",
                            maxLines: 2,
                            style: TextStyle(color: white, fontSize: 14.spMax)),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 17.w, top: 25.h, right: 17.w),
                        child: Consumer<ConnectivityProvider>(
                          builder: (context, connectivityProvider, child) =>
                              TextFormField(
                            focusNode: focusNode,
                            onTap: () {
                              isAdShow = false;
                              setState(() {});
                            },
                            onTapOutside: (PointerDownEvent event) {
                              if (focusNode.hasFocus) {
                                FocusScope.of(context).unfocus();
                                isAdShow = true;
                                setState(() {});
                              }
                            },
                            textInputAction: TextInputAction.search,
                            onChanged: (value) {
                              favoritePageProvider.SetkeybaordActive(true);
                              changeText(searchController.text);
                            },
                            onFieldSubmitted: (value) async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              print("""""");

                              wordList = '';
                              partofspeechList = '';
                              definitionList = '';
                              synonymsList = '';
                              antonymsList = '';

                              !connectivityProvider.isInternetAvailable
                                  ? CustomSnackBar(
                                      'No internet connection', context, red)
                                  : searchController.text.isEmpty
                                      ? ' '
                                      : getData().then((value) {
                                          setState(() {
                                            isLoding = false;
                                          });

                                          insertsearchword();
                                          if (favoritePageProvider
                                              .dataList.isEmpty) {
                                            favourite = false;
                                          } else {
                                            for (int i = 0;
                                                i <
                                                    favoritePageProvider
                                                        .dataList.length;
                                                i++) {
                                              if (favoritePageProvider
                                                  .dataList[i].word
                                                  .toString()
                                                  .contains(searchController
                                                      .text
                                                      .toLowerCase())) {
                                                setState(() {
                                                  favourite = true;
                                                });
                                                break;
                                              } else {
                                                print('I am not in fav');
                                                setState(() {
                                                  favourite = false;
                                                });
                                              }
                                            }
                                          }
                                        }).catchError((e) {
                                          setState(() {
                                            isLoding = false;
                                          });
                                          recordNotFount();
                                        });
                            },
                            keyboardType: TextInputType.text,
                            controller: searchController,
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Please Enter a search query";
                            },
                            decoration: InputDecoration(
                                errorStyle: TextStyle(
                                    color: Color.fromARGB(255, 247, 106, 106)),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: darkbluee,
                                  size: 30.sp,
                                ),
                                suffixIcon: searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.cancel_outlined),
                                        color: darkbluee,
                                        onPressed: () {
                                          searchController.clear();
                                          setState(() {
                                            recordnotfount = '';
                                          });
                                        },
                                      )
                                    : SizedBox(),
                                filled: true,
                                fillColor: white,
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: red, width: 2),
                                    borderRadius: BorderRadius.circular(10.r)),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: red, width: 1),
                                    borderRadius: BorderRadius.circular(10.r)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: darkbluee),
                                    borderRadius: BorderRadius.circular(10.r)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2, color: darkbluee),
                                    borderRadius: BorderRadius.circular(10.r)),
                                hintText: 'Search a word',
                                hintStyle:
                                    TextStyle(color: blue, fontSize: 14.spMax)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              isLoding
                  ? UnconstrainedBox(
                      child: CircularProgressIndicator(
                        color: darkbluee,
                      ),
                    )
                  : UnconstrainedBox(
                      child: Container(
                          height: 40.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: black.withOpacity(0.4),
                                  blurRadius: 5.r,
                                  offset: Offset(0, 2)),
                            ],
                            borderRadius: BorderRadius.circular(10.r),
                            color: darkbluee,
                          ),
                          child: Consumer<ConnectivityProvider>(
                            builder: (context, connectivityProvider, child) =>
                                TextButton(
                                    onPressed: () async {
                                      InterstitialAdClass.count++;
                                      if (InterstitialAdClass.count ==
                                              InterstitialAdClass.limit &&
                                          (!(value2.isMonthlyPurchased ||
                                              value2.isYearlyPurchased))) {
                                        InterstitialAdClass.showInterstitialAd(
                                            context);
                                        InterstitialAdClass.count = 0;
                                      }
                                      wordList = '';
                                      partofspeechList = '';
                                      definitionList = '';
                                      synonymsList = '';
                                      antonymsList = '';

                                      if (!connectivityProvider
                                              .isInternetAvailable &&
                                          searchController.text.isNotEmpty) {
                                        CustomSnackBar('No Internet Connection',
                                            context, red);
                                      } else if (searchController
                                          .text.isEmpty) {
                                        // Show message if the text field is empty
                                        CustomSnackBar(
                                            'Please Enter a search query',
                                            context,
                                            red);
                                      } else {
                                        getData().then((value) {
                                          setState(() {
                                            isLoding = false;
                                          });
                                          insertsearchword();
                                          if (favoritePageProvider
                                              .dataList.isEmpty) {
                                            favourite = false;
                                          } else {
                                            for (int i = 0;
                                                i <
                                                    favoritePageProvider
                                                        .dataList.length;
                                                i++) {
                                              if (favoritePageProvider
                                                  .dataList[i].word
                                                  .toString()
                                                  .contains(searchController
                                                      .text
                                                      .toLowerCase())) {
                                                setState(() {
                                                  favourite = true;
                                                });
                                                break;
                                              } else {
                                                print('I am not in fav');
                                                setState(() {
                                                  favourite = false;
                                                });
                                              }
                                            }
                                          }
                                        }).catchError((e) {
                                          setState(() {
                                            isLoding = false;
                                          });
                                          recordNotFount();
                                        });
                                      }
                                    },
                                    child: Text('Search',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: white,
                                        ))),
                          )),
                    ),
              SizedBox(
                height: 10.h,
              ),
              word.isEmpty
                  ? Center(
                      child: Text(
                        recordnotfount,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 15.spMax,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : search == true
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              searchTitleData('Word', word.isEmpty ? [] : word,
                                  favoritePageProvider),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  side: BorderSide(color: blue, width: 1.w),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: partOfSpeechData(
                                    'Part Of Speech',
                                    partsOfSpeech.isEmpty ? '' : partsOfSpeech,
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  side: BorderSide(color: blue, width: 1.w),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: definations(
                                    'Definitions',
                                    definition.isEmpty ? '' : definition,
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  side: BorderSide(color: blue, width: 1.w),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: synonyms(
                                    'Synonyms',
                                    syn,
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  side: BorderSide(color: blue, width: 1.w),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: antonyms(
                                    'Antonyms',
                                    ant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
            ]),
          ),
        ],
      ),
      Visibility(
        visible: word.isEmpty &&
            !favoritePageProvider.isKeyboardActive &&
            searchController.text.isEmpty &&
            isAdShow,
        child: Consumer2<WidgetProvider, InAppPurchaseController>(
            builder: (context, value, value2, child) {
          return isLoaded &&
                  value.getOpenAppAd == false &&
                  (!(value2.isMonthlyPurchased || value2.isYearlyPurchased))
              ? Positioned(
                  top: 268.h,
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: darkbluee)),
                    height: 355,
                    width: MediaQuery.of(context).size.width,
                    child: AdWidget(ad: _ad),
                  ),
                )
              : SizedBox();
        }),
      )
    ])));
  }
}
