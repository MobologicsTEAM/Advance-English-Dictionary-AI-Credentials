class DbModel {
  var word;
  var partOfSpeech;
  var definition;
  var synonyms;
  var antonyms;

  DbModel({
    this.word,
    this.partOfSpeech,
    this.definition,
    this.synonyms,
    this.antonyms,
  });

  DbModel.fromMap(Map<String, dynamic> res)
      : word = res['word'],
        partOfSpeech = res['partOfSpeech'],
        definition = res['definition'],
        synonyms = res['synonyms'],
        antonyms = res['antonyms'];

  Map<String, Object> toMap() {
    return {
      'word': word,
      'partOfSpeech': partOfSpeech,
      'definition': definition,
      'synonyms': synonyms,
      'antonyms': antonyms,
    };
  }
}
