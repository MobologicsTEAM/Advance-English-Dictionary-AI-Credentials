class Class6Model {
  int lesson;
  String name;

  Class6Model({required this.lesson, required this.name});

  Class6Model.fromMap(Map<String, dynamic> res)
      : lesson = res['lesson'],
        name = res['name'];

  Map<String, Object> toMap() {
    return {
      'lesson': lesson,
      'name': name,
    };
  }
}
