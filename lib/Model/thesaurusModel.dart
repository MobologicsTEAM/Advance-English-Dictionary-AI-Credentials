class ThesaurusModel {
  String word;
  String definition;
  String synonyms;
  String antonyms;

  ThesaurusModel({
    required this.word,
    required this.definition,
    required this.synonyms,
    required this.antonyms,
  });

  ThesaurusModel.fromMap(Map<String, dynamic> res)
      : word = res['synonyms'],
        definition = res['definition'],
        synonyms = res['synonyms'],
        antonyms = res['antonyms'];

  Map<String, Object> toMap() {
    return {
      'synonyms': word,
      'definition': definition,
      'synonyms': synonyms,
      'antonyms': antonyms,
    };
  }
}
