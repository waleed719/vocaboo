class SpeakingResponse {
  final String category;
  final String language;
  final int level;
  final String raw;
  final List<AudioParser> audioList;

  SpeakingResponse({
    required this.category,
    required this.language,
    required this.level,
    required this.raw,
    required this.audioList,
  });
  factory SpeakingResponse.fromJson(Map<String, dynamic> json) {
    return SpeakingResponse(
      category: json['category'] as String,
      language: json['language'] as String,
      level: json['level'] as int,
      raw: json['raw'] as String,
      audioList:
          (json['audio'] as List)
              .map((item) => AudioParser.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }
}

class AudioParser {
  final String text;
  final String audio;
  AudioParser({required this.text, required this.audio});

  factory AudioParser.fromJson(Map<String, dynamic> json) {
    return AudioParser(
      text: json['text'] as String,
      audio: json['audio'] as String,
    );
  }
}

class SpeakingContent {
  final String scenario;
  final String rolePlayInstructions;
  final List<Phrase> usefulPhrases;
  final List<PronunciationTip> pronunciationTips;
  final List<String> discussionQuestions;

  SpeakingContent({
    required this.scenario,
    required this.rolePlayInstructions,
    required this.usefulPhrases,
    required this.pronunciationTips,
    required this.discussionQuestions,
  });

  factory SpeakingContent.fromJson(Map<String, dynamic> json) {
    return SpeakingContent(
      scenario: json['scenario'] as String,
      rolePlayInstructions: json['role_play_instructions'] as String,
      usefulPhrases:
          (json['useful_phrases'] as List)
              .map((item) => Phrase.fromJson(item))
              .toList(),
      pronunciationTips:
          (json['pronunciation_tips'] as List)
              .map((item) => PronunciationTip.fromJson(item))
              .toList(),
      discussionQuestions: List<String>.from(json['discussion_questions']),
    );
  }
}

class Phrase {
  final String phrase;
  final String translation;
  final String usageContext;

  Phrase({
    required this.phrase,
    required this.translation,
    required this.usageContext,
  });

  factory Phrase.fromJson(Map<String, dynamic> json) {
    return Phrase(
      phrase: json['phrase'] as String,
      translation: json['translation'] as String,
      usageContext: json['usage_context'] as String,
    );
  }
}

class PronunciationTip {
  final String sound;
  final String tip;

  PronunciationTip({required this.sound, required this.tip});

  factory PronunciationTip.fromJson(Map<String, dynamic> json) {
    return PronunciationTip(
      sound: json['sound'] as String,
      tip: json['tip'] as String,
    );
  }
}
