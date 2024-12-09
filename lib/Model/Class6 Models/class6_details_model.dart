class Class6DetailsModel {
  String lesson;
  String word;
  String type;
  String example;

  Class6DetailsModel(
      {required this.lesson,
      required this.word,
      required this.type,
      required this.example});

  Class6DetailsModel.fromMap(Map<String, dynamic> res)
      : lesson = res['lesson'],
        word = res['word'],
        type = res['type'],
        example = res['example_en'];

  Map<String, Object> toMap() {
    return {
      'lesson': lesson,
      'word': word,
      'type': type,
      'example_en': example,
    };
  }
}
