import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:vocaboo/models/grammar_model.dart';
import 'dart:convert';

class GrammarDetailScreen extends StatefulWidget {
  final int level;
  final String theme;

  const GrammarDetailScreen({
    super.key,
    required this.level,
    required this.theme,
  });

  @override
  State<GrammarDetailScreen> createState() => _GrammarDetailScreenState();
}

class _GrammarDetailScreenState extends State<GrammarDetailScreen> {
  late GrammarContent grammarContent;
  bool _isLoading = true;
  String? _error;

  // Track completion status for different sections
  List<bool> _completedExamples = [];
  List<bool> _completedMistakes = [];
  List<bool> _completedExercises = [];

  // Track expansion status for shrinkable tiles
  bool _explanationExpanded = false;
  List<bool> _expandedExamples = [];
  List<bool> _expandedMistakes = [];
  List<bool> _expandedExercises = [];

  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _fetchGrammarData();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _fetchGrammarData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final grammar = await fetchGrammarData(widget.level);
      setState(() {
        grammarContent = grammar;
        // Initialize completion and expansion states
        _completedExamples = List.filled(grammarContent.examples.length, false);
        _completedMistakes = List.filled(
          grammarContent.commonMistakes.length,
          false,
        );
        _completedExercises = List.filled(
          grammarContent.practiceExercise.length,
          false,
        );

        _expandedExamples = List.filled(grammarContent.examples.length, false);
        _expandedMistakes = List.filled(
          grammarContent.commonMistakes.length,
          false,
        );
        _expandedExercises = List.filled(
          grammarContent.practiceExercise.length,
          false,
        );

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<GrammarContent> fetchGrammarData(int level) async {
    final url = Uri.parse(
      'http://13.60.208.182:8000/grammar/?t=${DateTime.now().millisecondsSinceEpoch}',
    );
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'language': 'Japanese', 'level': level});

    try {
      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(
            Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timed out'),
          );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final grammarResponse = GrammarResponse.fromJson(jsonResponse);
        final grammarContent = GrammarContent.fromJson(
          jsonDecode(grammarResponse.raw),
        );

        return grammarContent;
      } else {
        throw Exception('Failed to load grammar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load grammar: $e');
    }
  }

  void markExampleAsCompleted(int index) {
    setState(() {
      _completedExamples[index] = !_completedExamples[index];
    });
  }

  void markMistakeAsCompleted(int index) {
    setState(() {
      _completedMistakes[index] = !_completedMistakes[index];
    });
  }

  void markExerciseAsCompleted(int index) {
    setState(() {
      _completedExercises[index] = !_completedExercises[index];
    });
  }

  Widget _buildTopicSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              grammarContent.topic,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                setState(() {
                  _explanationExpanded = !_explanationExpanded;
                });
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Explanation',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        Icon(
                          _explanationExpanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.blue.shade300,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      grammarContent.explanation,
                      style: TextStyle(fontSize: 14),
                      maxLines: _explanationExpanded ? null : 3,
                      overflow:
                          _explanationExpanded ? null : TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamplesSection() {
    if (grammarContent.examples.isEmpty) return SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Examples (${grammarContent.examples.length})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...grammarContent.examples.asMap().entries.map((entry) {
              int index = entry.key;
              GrammarExample example = entry.value;
              bool isCompleted = _completedExamples[index];
              bool isExpanded = _expandedExamples[index];

              return Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    example.correct,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                      color: Colors.orange.shade800,
                    ),
                  ),
                  subtitle:
                      isExpanded
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                'Translation: ${example.translation}',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Explanation: ${example.explanation}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          )
                          : Text(
                            example.translation,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.orange.shade300,
                        ),
                        onPressed: () {
                          setState(() {
                            _expandedExamples[index] =
                                !_expandedExamples[index];
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isCompleted
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isCompleted ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => markExampleAsCompleted(index),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _expandedExamples[index] = !_expandedExamples[index];
                    });
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCommonMistakesSection() {
    if (grammarContent.commonMistakes.isEmpty) return SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_outlined, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Common Mistakes (${grammarContent.commonMistakes.length})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...grammarContent.commonMistakes.asMap().entries.map((entry) {
              int index = entry.key;
              CommonMistakes mistake = entry.value;
              bool isCompleted = _completedMistakes[index];
              bool isExpanded = _expandedMistakes[index];

              return Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.close, color: Colors.red, size: 16),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              mistake.incorrect,
                              style: TextStyle(
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.check, color: Colors.green, size: 16),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              mistake.correct,
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                                decoration:
                                    isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle:
                      isExpanded
                          ? Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              mistake.explanation,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          )
                          : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.red.shade300,
                        ),
                        onPressed: () {
                          setState(() {
                            _expandedMistakes[index] =
                                !_expandedMistakes[index];
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isCompleted
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isCompleted ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => markMistakeAsCompleted(index),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _expandedMistakes[index] = !_expandedMistakes[index];
                    });
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeExercisesSection() {
    if (grammarContent.practiceExercise.isEmpty) return SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.quiz_outlined, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Practice Exercises (${grammarContent.practiceExercise.length})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ...grammarContent.practiceExercise.asMap().entries.map((entry) {
              int index = entry.key;
              PracticeExercises exercise = entry.value;
              bool isCompleted = _completedExercises[index];
              bool isExpanded = _expandedExercises[index];

              return Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    'Q${index + 1}: ${exercise.question}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                      color: Colors.purple.shade800,
                    ),
                  ),
                  subtitle:
                      isExpanded
                          ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Answer: ${exercise.answer}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Explanation: ${exercise.explanation}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          )
                          : Text(
                            'Tap to reveal answer',
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          isExpanded ? Icons.expand_less : Icons.expand_more,
                          color: Colors.purple.shade300,
                        ),
                        onPressed: () {
                          setState(() {
                            _expandedExercises[index] =
                                !_expandedExercises[index];
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          isCompleted
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isCompleted ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => markExerciseAsCompleted(index),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _expandedExercises[index] = !_expandedExercises[index];
                    });
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  int get totalItems {
    return grammarContent.examples.length +
        grammarContent.commonMistakes.length +
        grammarContent.practiceExercise.length;
  }

  int get completedItems {
    return _completedExamples.where((e) => e).length +
        _completedMistakes.where((e) => e).length +
        _completedExercises.where((e) => e).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.theme} - Level ${widget.level}'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child:
            _isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                : _error != null
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Error: $_error',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchGrammarData,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
                : Column(
                  children: [
                    // Fixed-height header
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$totalItems Items',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Progress: $completedItems/$totalItems',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    // Expanded section for the content
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildTopicSection(),
                              _buildExamplesSection(),
                              _buildCommonMistakesSection(),
                              _buildPracticeExercisesSection(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchGrammarData,
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
