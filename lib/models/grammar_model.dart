class GrammarResponse {
  final String category;
  final String language;
  final int level;
  final String raw;

  GrammarResponse({
    required this.category,
    required this.language,
    required this.level,
    required this.raw,
  });

  factory GrammarResponse.fromJson(Map<String, dynamic> json) {
    return GrammarResponse(
      category: json['category'] as String,
      language: json['language'] as String,
      level: json['level'] as int,
      raw: json['raw'] as String,
    );
  }
}

class GrammarContent {
  final String topic;
  final String explanation;
  final List<GrammarExample> examples;
  final List<CommonMistakes> commonMistakes;
  final List<PracticeExercises> practiceExercise;

  GrammarContent({
    required this.topic,
    required this.explanation,
    required this.commonMistakes,
    required this.examples,
    required this.practiceExercise,
  });

  factory GrammarContent.fromJson(Map<String, dynamic> json) {
    return GrammarContent(
      topic: json['topic'] as String,
      explanation: json['explanation'] as String,
      // Fix these JSON key names - they should match the API response
      commonMistakes:
          (json['common_mistakes'] as List<dynamic>)
              .map(
                (item) => CommonMistakes.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      examples:
          (json['examples'] as List<dynamic>)
              .map(
                (item) => GrammarExample.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
      practiceExercise:
          (json['practice_exercises'] as List<dynamic>)
              .map(
                (item) =>
                    PracticeExercises.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}

class GrammarExample {
  final String correct;
  final String translation;
  final String explanation;

  GrammarExample({
    required this.correct,
    required this.explanation,
    required this.translation,
  });

  factory GrammarExample.fromJson(Map<String, dynamic> json) {
    return GrammarExample(
      correct: json['correct'] as String,
      explanation: json['explanation'] as String,
      translation: json['translation'] as String,
    );
  }
}

class CommonMistakes {
  final String incorrect;
  final String correct;
  final String explanation;

  CommonMistakes({
    required this.correct,
    required this.incorrect,
    required this.explanation,
  });
  factory CommonMistakes.fromJson(Map<String, dynamic> json) {
    return CommonMistakes(
      correct: json['correct'] as String,
      incorrect: json['incorrect'] as String,
      explanation: json['explanation'] as String,
    );
  }
}

class PracticeExercises {
  final String question;
  final String answer;
  final String explanation;

  PracticeExercises({
    required this.question,
    required this.answer,
    required this.explanation,
  });
  factory PracticeExercises.fromJson(Map<String, dynamic> json) {
    return PracticeExercises(
      question: json['question'] as String,
      answer: json['answer'] as String,
      explanation: json['explanation'] as String,
    );
  }
}
