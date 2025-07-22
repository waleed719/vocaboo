class ListeningResponse {
  final String category;
  final String language;
  final int level;
  final String raw;
  final List<AudioParser> audio;
  ListeningResponse({
    required this.category,
    required this.language,
    required this.level,
    required this.raw,
    required this.audio,
  });

  factory ListeningResponse.fromJson(Map<String, dynamic> json) {
    return ListeningResponse(
      category: json['category'] as String,
      language: json['language'] as String,
      level: json['level'] as int,
      raw: json['raw'] as String,
      audio:
          (json['audio'] as List)
              .map((item) => AudioParser.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }
}

class ListeningContent {
  final String title;
  final String audioScript;
  final List<Questions> questions;

  ListeningContent({
    required this.title,
    required this.audioScript,
    required this.questions,
  });

  factory ListeningContent.fromJson(Map<String, dynamic> json) {
    return ListeningContent(
      title: json['title'] as String,
      audioScript: json['audio_script'] as String,
      questions:
          (json['comprehension_questions'] as List<dynamic>)
              .map((item) => Questions.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }
}

class Questions {
  final String question;
  final List<String> options;
  final String correctOption;
  final String explanation;
  Questions({
    required this.question,
    required this.correctOption,
    required this.explanation,
    required this.options,
  });

  factory Questions.fromJson(Map<String, dynamic> json) {
    return Questions(
      question: json['question'] as String,
      correctOption: json['correct_answer'] as String,
      explanation: json['explanation'] as String,
      options:
          (json['options'] as List<dynamic>)
              .map((item) => item.toString())
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
