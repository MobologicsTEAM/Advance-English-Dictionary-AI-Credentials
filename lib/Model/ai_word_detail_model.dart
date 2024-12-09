import 'dart:convert';

// class WordDataAI {
//   final String? word;
//   final String? meaning;
//   final List<String>? synonyms;
//   final List<String>? antonyms;
//   final String? partOfSpeech;
//   final List<String>? examples;

//   WordDataAI({
//     required this.word,
//     required this.meaning,
//     required this.synonyms,
//     required this.antonyms,
//     required this.partOfSpeech,
//     required this.examples,
//   });

//   factory WordDataAI.fromJson(Map<String, dynamic> json) {
//     return WordDataAI(
//       word: json['word'],
//       meaning: json['meaning'],
//       partOfSpeech: json['partOfSpeech'],
//       synonyms: List<String>.from(json['synonyms']),
//       antonyms: List<String>.from(json['antonyms']),
//       examples: List<String>.from(json['examples']),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'word': word,
//       'meaning': meaning,
//       'partOfSpeech': partOfSpeech,
//       'synonyms': jsonEncode(synonyms),
//       'antonyms': jsonEncode(antonyms),
//       'examples': jsonEncode(examples),
//     };
//   }

//   factory WordDataAI.fromMap(Map<String, dynamic> map) {
//     return WordDataAI(
//       word: map['word'],
//       meaning: map['meaning'],
//       partOfSpeech: map['partOfSpeech'],
//       synonyms: List<String>.from(jsonDecode(map['synonyms'])),
//       antonyms: List<String>.from(jsonDecode(map['antonyms'])),
//       examples: List<String>.from(jsonDecode(map['examples'])),
//     );
//   }
// }

class WordDataAI {
  final String word;
  final String meaning;
  final List<String> synonyms;
  final List<String> antonyms;
  final String partOfSpeech;
  final List<String> examples;

  WordDataAI({
    required this.word,
    required this.meaning,
    required this.synonyms,
    required this.antonyms,
    required this.partOfSpeech,
    required this.examples,
  });

  factory WordDataAI.fromJson(Map<String, dynamic> json) {
    return WordDataAI(
      word: json['word'],
      meaning: json['meaning'],
      partOfSpeech: json['partOfSpeech'],
      synonyms: List<String>.from(json['synonyms']),
      antonyms: List<String>.from(json['antonyms']),
      examples: List<String>.from(json['examples']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'meaning': meaning,
      'partOfSpeech': partOfSpeech,
      'synonyms': jsonEncode(synonyms),
      'antonyms': jsonEncode(antonyms),
      'examples': jsonEncode(examples),
    };
  }

  factory WordDataAI.fromMap(Map<String, dynamic> map) {
    return WordDataAI(
      word: map['word'],
      meaning: map['meaning'],
      partOfSpeech: map['partOfSpeech'],
      synonyms: List<String>.from(jsonDecode(map['synonyms'])),
      antonyms: List<String>.from(jsonDecode(map['antonyms'])),
      examples: List<String>.from(jsonDecode(map['examples'])),
    );
  }
}
