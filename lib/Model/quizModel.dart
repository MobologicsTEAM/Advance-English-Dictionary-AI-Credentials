class QuizModel {
  String question;
  String answerA;
  String answerB;
  String answerC;
  String answerD;
  String correctAnswer;

  QuizModel(
      {required this.question,
      required this.answerA,
      required this.answerB,
      required this.answerC,
      required this.answerD,
      required this.correctAnswer});

  QuizModel.fromMap(Map<String, dynamic> res)
      : question = res['QContent'],
        answerA = res['AnswerA'],
        answerB = res['AnswerB'],
        answerC = res['AnswerC'],
        answerD = res['AnswerD'],
        correctAnswer = res['CorrectAnswer'];

  Map<String, Object> toMap() {
    return {
      'QContent': question,
      'AnswerA': answerA,
      'AnswerB': answerB,
      'AnswerC': answerC,
      'AnswerD': answerD,
      'CorrectAnswer': correctAnswer,
    };
  }
}
