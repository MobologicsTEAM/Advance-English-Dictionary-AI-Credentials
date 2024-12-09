import 'package:flutter/material.dart';

import '../Helper/dbHelperclass6.dart';
import '../Model/Class6 Models/class6_details_model.dart';
import '../Model/Class6 Models/class6_model.dart';

class Class6Provider with ChangeNotifier {
  late List<Class6Model> class6_lessonTbl_data;
  late List<Class6DetailsModel> class6_lessonTbl_details;

  Future loadclass6LessonTblData() async {
    DbHelperClass6? dbHelperClass6 = DbHelperClass6();
    class6_lessonTbl_data = await dbHelperClass6.getClass6LessonTblData();
    notifyListeners();
    print(class6_lessonTbl_data.length.toString() + ' list data');
    return class6_lessonTbl_data;
  }

  Future loadclass6LessonTblDetailsData() async {
    DbHelperClass6? dbHelperClass6 = DbHelperClass6();
    class6_lessonTbl_details =
        await dbHelperClass6.getClass6LessonTblDetailsData();
    notifyListeners();
    print(class6_lessonTbl_data.length.toString() + ' list data');
    return class6_lessonTbl_data;
  }
}
