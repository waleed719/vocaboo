// lib/models/vocab_model.dart

class VocabularyResponse {
  final String category;
  final String language;
  final int level;
  final String raw;
  final List<AudioItem> audio;

  VocabularyResponse({
    required this.category,
    required this.language,
    required this.level,
    required this.raw,
    required this.audio,
  });

  factory VocabularyResponse.fromJson(Map<String, dynamic> json) {
    return VocabularyResponse(
      category: json['category'] as String,
      language: json['language'] as String,
      level: json['level'] as int,
      raw: json['raw'] as String,
      audio:
          (json['audio'] as List<dynamic>?)
              ?.map((item) => AudioItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AudioItem {
  final String text;
  final String audio;

  AudioItem({required this.text, required this.audio});

  factory AudioItem.fromJson(Map<String, dynamic> json) {
    return AudioItem(
      text: json['text'] as String,
      audio: json['audio'] as String,
    );
  }
}

class VocabularyContent {
  final String theme;
  final String introduction;
  final List<VocabItem> vocabulary;

  VocabularyContent({
    required this.theme,
    required this.introduction,
    required this.vocabulary,
  });

  factory VocabularyContent.fromJson(Map<String, dynamic> json) {
    return VocabularyContent(
      theme: json['theme'] as String,
      introduction: json['introduction'] as String,
      vocabulary:
          (json['vocabulary'] as List<dynamic>)
              .map((item) => VocabItem.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }
}

class VocabItem {
  final String word;
  final String pronunciation;
  final String translation;
  final String example;
  final String exampleTranslation;
  final String? audioUrl; // Made nullable to handle missing audio
  bool isCompleted;
  DateTime? lastReviewed;

  VocabItem({
    required this.word,
    required this.pronunciation,
    required this.translation,
    required this.example,
    required this.exampleTranslation,
    this.audioUrl,
    this.isCompleted = false,
    this.lastReviewed,
  });

  factory VocabItem.fromJson(Map<String, dynamic> json) {
    return VocabItem(
      word: json['word'] as String,
      pronunciation: json['pronunciation'] as String,
      translation: json['translation'] as String,
      example: json['example'] as String,
      exampleTranslation: json['example_translation'] as String,
      audioUrl: null, // Will be set later when correlating with audio list
      isCompleted: false,
      lastReviewed: null,
    );
  }

  VocabItem copyWith({
    String? audioUrl,
    bool? isCompleted,
    DateTime? lastReviewed,
  }) {
    return VocabItem(
      word: word,
      pronunciation: pronunciation,
      translation: translation,
      example: example,
      exampleTranslation: exampleTranslation,
      audioUrl: audioUrl ?? this.audioUrl,
      isCompleted: isCompleted ?? this.isCompleted,
      lastReviewed: lastReviewed ?? this.lastReviewed,
    );
  }
}
