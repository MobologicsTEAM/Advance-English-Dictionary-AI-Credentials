// class ModelClass {
//   final word;
//   final partOfSpeech;
//   final definition;
//   final synonyms;
//   final antonyms;

//   ModelClass(
//       {required this.word,
//       required this.partOfSpeech,
//       required this.definition,
//       required this.synonyms,
//       required this.antonyms});
// }

import 'dart:convert';

class ModelClass {
  final String word;
  final partOfSpeech;
  final String definition;
  final synonyms;
  final antonyms;

  ModelClass({
    required this.word,
    required this.partOfSpeech,
    required this.definition,
    required this.synonyms,
    required this.antonyms,
  });

  /// Factory constructor to create an instance from a JSON object
  factory ModelClass.fromJson(Map<String, dynamic> json) {
    return ModelClass(
      word: json['word'],
      partOfSpeech: json['partOfSpeech'],
      definition: json['definition'],
      synonyms: List<String>.from(json['synonyms']),
      antonyms: List<String>.from(json['antonyms']),
    );
  }

  /// Method to convert the instance into a Map (useful for saving in SQLite)
  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'partOfSpeech': partOfSpeech,
      'definition': definition,
      'synonyms': jsonEncode(synonyms), // Convert List to JSON String
      'antonyms': jsonEncode(antonyms), // Convert List to JSON String
    };
  }

  /// Factory constructor to create an instance from a Map (e.g., from SQLite)
  factory ModelClass.fromMap(Map<String, dynamic> map) {
    return ModelClass(
      word: map['word'],
      partOfSpeech: map['partOfSpeech'],
      definition: map['definition'],
      synonyms: List<String>.from(jsonDecode(map['synonyms'])),
      antonyms: List<String>.from(jsonDecode(map['antonyms'])),
    );
  }
}
