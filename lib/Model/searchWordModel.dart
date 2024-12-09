class SearchWord {
  var word;
  var definition;

  SearchWord({this.word, this.definition});

  SearchWord.fromMap(Map<String, dynamic> res)
      : word = res['word'],
        definition = res['definition'];

  Map<String, Object> toMap() {
    return {
      'word': word,
      'definition': definition,
    };
  }
}
