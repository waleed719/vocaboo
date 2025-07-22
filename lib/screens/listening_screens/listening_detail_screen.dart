import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:vocaboo/models/listening_model.dart';

class ListeningDetailScreen extends StatefulWidget {
  final int level;
  final String theme;

  const ListeningDetailScreen({
    super.key,
    required this.level,
    required this.theme,
  });

  @override
  State<ListeningDetailScreen> createState() => _ListeningDetailScreenState();
}

class _ListeningDetailScreenState extends State<ListeningDetailScreen> {
  final AudioPlayer _player = AudioPlayer();
  ListeningContent? _content;
  List<AudioParser> _audioList = [];
  bool _isLoading = true;
  String? _error;
  Map<int, String> selectedAnswers = {};

  bool _isPlaying = false;
  double _currentSpeed = 1.0;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  final List<double> _speedOptions = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _fetchListeningData();

    // Add these listeners
    _player.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _player.durationStream.listen((duration) {
      setState(() {
        _totalDuration = duration ?? Duration.zero;
      });
    });

    _player.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  Future<void> _fetchListeningData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await fetchListeningData(widget.level);
      final content = ListeningContent.fromJson(jsonDecode(response.raw));
      setState(() {
        _audioList = response.audio;
        _content = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<ListeningResponse> fetchListeningData(int level) async {
    final url = Uri.parse(
      'http://13.60.208.182:8000/listening/?t=${DateTime.now().millisecondsSinceEpoch}',
    );
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'language': 'Japanese', 'level': level});

    final response = await http
        .post(url, headers: headers, body: body)
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return ListeningResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load listening: ${response.statusCode}');
    }
  }

  Future<void> _playAudio(String url) async {
    try {
      if (_player.audioSource == null) {
        await _player.setUrl(url);
        await _player.setSpeed(_currentSpeed);
      }
      await _player.play();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Audio error: $e")));
    }
  }

  Future<void> _pauseAudio() async {
    await _player.pause();
  }

  Future<void> _resumeAudio() async {
    await _player.play();
  }

  Future<void> _changeSpeed(double speed) async {
    setState(() {
      _currentSpeed = speed;
    });
    await _player.setSpeed(speed);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Widget buildScriptTile() {
    return ExpansionTile(
      title: const Text(
        "View Audio Script",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            _content!.audioScript,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget buildAudioPlayer() {
    if (_audioList.isEmpty) return const SizedBox();

    return Column(
      children: [
        const Text(
          "Listen to Audio",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        // Progress slider
        if (_totalDuration.inSeconds > 0)
          Slider(
            value: _currentPosition.inSeconds.toDouble(),
            max: _totalDuration.inSeconds.toDouble(),
            onChanged: (value) async {
              final position = Duration(seconds: value.toInt());
              await _player.seek(position);
            },
            activeColor: Colors.blue.shade700,
          ),

        // Time display
        if (_totalDuration.inSeconds > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_currentPosition)),
                Text(_formatDuration(_totalDuration)),
              ],
            ),
          ),

        const SizedBox(height: 8),

        // Control buttons row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Play/Pause button
            ElevatedButton.icon(
              onPressed: () {
                if (_isPlaying) {
                  _pauseAudio();
                } else {
                  if (_player.audioSource == null) {
                    _playAudio(_audioList.first.audio);
                  } else {
                    _resumeAudio();
                  }
                }
              },
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              label: Text(_isPlaying ? "Pause" : "Play"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
            ),

            // Speed control button
            PopupMenuButton<double>(
              onSelected: _changeSpeed,
              itemBuilder:
                  (context) =>
                      _speedOptions
                          .map(
                            (speed) => PopupMenuItem<double>(
                              value: speed,
                              child: Row(
                                children: [
                                  Text("${speed}x"),
                                  if (speed == _currentSpeed)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Icon(Icons.check, size: 16),
                                    ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.speed, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "${_currentSpeed}x",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildQuestions() {
    if (_content == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_content!.questions.length, (index) {
        final q = _content!.questions[index];
        final selected = selectedAnswers[index];
        final correctLetter = q.correctOption;
        final selectedLetter =
            selected != null
                ? String.fromCharCode(65 + q.options.indexOf(selected))
                : null;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  q.question,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(q.options.length, (i) {
                    final option = q.options[i];
                    // final label = String.fromCharCode(65 + i);

                    return RadioListTile<String>(
                      value: option,
                      groupValue: selected,
                      onChanged: (value) {
                        setState(() {
                          selectedAnswers[index] = value!;
                        });
                      },
                      title: Text(
                        option.replaceFirst(RegExp(r'^[A-Z]\.\s*'), ''),
                      ),
                      activeColor: Colors.blue,
                    );
                  }),
                ),
                if (selected != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color:
                          selectedLetter == correctLetter
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedLetter == correctLetter
                              ? "✅ Correct!"
                              : "❌ Incorrect",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                selectedLetter == correctLetter
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text("Explanation: ${q.explanation}"),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(child: Text("Error: $_error"))
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.theme} - Level ${widget.level}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildScriptTile(),
                      const SizedBox(height: 16),
                      buildAudioPlayer(),
                      const SizedBox(height: 24),
                      const Text(
                        "Questions",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      buildQuestions(),
                    ],
                  ),
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchListeningData,
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
