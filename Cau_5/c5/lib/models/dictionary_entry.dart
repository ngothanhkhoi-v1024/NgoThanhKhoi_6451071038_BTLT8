class DictionaryEntry {
  final int? id;
  final String word;
  final String meaning;

  const DictionaryEntry({
    this.id,
    required this.word,
    required this.meaning,
  });

  factory DictionaryEntry.fromJson(Map<String, dynamic> json) {
    return DictionaryEntry(
      word: (json['word'] as String).trim(),
      meaning: (json['meaning'] as String).trim(),
    );
  }

  factory DictionaryEntry.fromMap(Map<String, dynamic> map) {
    return DictionaryEntry(
      id: map['id'] as int?,
      word: map['word'] as String,
      meaning: map['meaning'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'word': word,
      'meaning': meaning,
    };
  }
}
