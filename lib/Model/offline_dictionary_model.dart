class OfflineDictionary {
  
  String word;
  String partOfSpeech;
  String meaning;
  String example1;
  String example2;
  String example3;

  OfflineDictionary(
      {required this.word,
      required this.partOfSpeech,
      required this.meaning,
      required this.example1,
      required this.example2,
      required this.example3});

  OfflineDictionary.fromMap(Map<String, dynamic> res)
      : word = res['word'],
        partOfSpeech = res['part_of_speech'],
        meaning = res['meaning'],
        example1 = res['example_1'],
        example2 = res['example_2'],
        example3 = res['example_3'];

  Map<String, Object> toMap() {
    return {
      'word': word,
      'part_of_speech': partOfSpeech,
      'meaning': meaning,
      'example_1': example1,
      'example_2': example2,
      'example_3': example3,
    };
  }
}
