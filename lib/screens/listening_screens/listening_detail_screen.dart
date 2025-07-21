import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'dart:convert';
import '../../models/vocab_model.dart';

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
  List<VocabItem> _vocabList = [];
  bool _isLoading = true;
  String? _error;

  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _fetchVocabData();
  }

  Future<void> audioPlayer(String url) async {
    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      ScaffoldMessenger(child: Text("Audio Playback Error: $e"));
    }
  }

  Future<void> _fetchVocabData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final vocabItems = await fetchVocabData(widget.level);
      setState(() {
        _vocabList = vocabItems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<List<VocabItem>> fetchVocabData(int level) async {
    final url = Uri.parse(
      'http://13.60.208.182:8000/listening/?t=${DateTime.now().millisecondsSinceEpoch}',
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
        final vocabResponse = VocabularyResponse.fromJson(jsonResponse);
        final rawContent = VocabularyContent.fromJson(
          jsonDecode(vocabResponse.raw),
        );

        final vocabItems =
            rawContent.vocabulary.map((vocabItem) {
              final audioItem = vocabResponse.audio.firstWhere(
                (audio) => audio.text == vocabItem.word,
                orElse: () => AudioItem(text: vocabItem.word, audio: ''),
              );
              return vocabItem.copyWith(
                audioUrl: audioItem.audio.isNotEmpty ? audioItem.audio : null,
              );
            }).toList();

        return vocabItems;
      } else {
        throw Exception('Failed to load vocabulary: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load vocabulary: $e');
    }
  }

  void markAsCompleted(int index) {
    setState(() {
      _vocabList[index].isCompleted = !_vocabList[index].isCompleted;
      _vocabList[index].lastReviewed = DateTime.now();
    });
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
                        onPressed: _fetchVocabData,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
                : _vocabList.isEmpty
                ? const Center(
                  child: Text(
                    'No vocabulary items found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
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
                            '${_vocabList.length} Words',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Progress: ${_vocabList.where((item) => item.isCompleted).length}/${_vocabList.length}',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    // Expanded section for the list
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: _vocabList.length,
                          itemBuilder: (context, index) {
                            final item = _vocabList[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(16),
                                title: Text(
                                  item.word,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                subtitle: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8),
                                    Text(
                                      item.translation,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (item.pronunciation.isNotEmpty) ...[
                                      SizedBox(height: 4),
                                      Text(
                                        'Pronunciation: ${item.pronunciation}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                    if (item.example.isNotEmpty) ...[
                                      SizedBox(height: 8),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          item.example,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue.shade800,
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (item.lastReviewed != null) ...[
                                      SizedBox(height: 8),
                                      Text(
                                        'Last reviewed: ${item.lastReviewed!.toLocal().toString().split('.')[0]}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (item.audioUrl != null)
                                      Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: IconButton(
                                          onPressed: () {
                                            // print(item.audioUrl);
                                            audioPlayer(item.audioUrl!);
                                          },
                                          icon: Icon(
                                            Icons.volume_up,
                                            color: Colors.blue.shade300,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    IconButton(
                                      icon: Icon(
                                        item.isCompleted
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color:
                                            item.isCompleted
                                                ? Colors.green
                                                : Colors.grey,
                                        size: 16,
                                      ),
                                      onPressed: () => markAsCompleted(index),
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(
                                        minWidth: 24,
                                        minHeight: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchVocabData,
        backgroundColor: Colors.blue.shade700,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
