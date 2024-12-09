import 'package:flutter/material.dart';

import '../Helper/dbHelperQuiz.dart';
import '../Model/quizModel.dart';

class QuizProvider with ChangeNotifier {
  late List<QuizModel> quizData;
  int question_number_index = 0;
  int question_number = 1;
  int total_marks = 0;

  Future loadQuizData() async {
    DbHelperQuiz? dbHelperQuiz = DbHelperQuiz();
    quizData = await dbHelperQuiz.getQuizData();
    notifyListeners();
    print(quizData.length.toString() + ' list data');
    return quizData;
  }

  increment_question_number_index() {
    question_number_index++;
    notifyListeners();
  }

  increment_question_number() {
    question_number++;
    notifyListeners();
  }

  increment_total_marks() {
    total_marks++;
    notifyListeners();
  }
}
