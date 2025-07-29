import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:vocaboo/models/grammar_model.dart';

Future<GrammarContent?> loadGrammarContentFromAssets({
  required String language,
  required int level,
}) async {
  final csvString = await rootBundle.loadString(
    'assets/content/grammar_data.csv',
  );
  final lines = const LineSplitter().convert(csvString);
  final headers = lines.first.split(',');

  for (var i = 1; i < lines.length; i++) {
    final values = _splitCsvLine(lines[i]);
    final row = Map<String, String>.fromIterables(headers, values);

    if (row['language']?.trim() == language &&
        row['level'] == level.toString()) {
      final raw = row['raw'];
      if (raw != null && raw.isNotEmpty) {
        try {
          final json = jsonDecode(raw);
          return GrammarContent.fromJson(json);
        } catch (e) {
          print('Error parsing raw: $e');
          return null;
        }
      }
    }
  }

  return null; // If no matching row found
}

List<String> _splitCsvLine(String line) {
  final regExp = RegExp(r'''((?:[^,"']|"[^"]*"|'[^']*')+)''');
  return regExp
      .allMatches(line)
      .map((m) => m.group(0)!.replaceAll(RegExp(r'^"|"$'), ''))
      .toList();
}
