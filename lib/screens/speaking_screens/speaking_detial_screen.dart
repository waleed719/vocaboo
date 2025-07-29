// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:just_audio/just_audio.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import '../../models/speaking_model.dart';

// class SpeakingDetailScreen extends StatefulWidget {
//   final int level;
//   final String theme;

//   const SpeakingDetailScreen({
//     super.key,
//     required this.level,
//     required this.theme,
//   });

//   @override
//   State<SpeakingDetailScreen> createState() => _SpeakingDetailScreenState();
// }

// class _SpeakingDetailScreenState extends State<SpeakingDetailScreen> {
//   bool _isLoading = true;
//   String? _error;
//   SpeakingResponse? _data;
//   final AudioPlayer _player = AudioPlayer();
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   String _spokenText = "";
//   String _feedback = "";
//   int _currentIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _fetchSpeakingData();
//   }

//   Future<void> _fetchSpeakingData() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     final url = Uri.parse(
//       'http://13.60.208.182:8000/speaking/?t=${DateTime.now().millisecondsSinceEpoch}',
//     );
//     final headers = {'Content-Type': 'application/json'};
//     final body = jsonEncode({'language': 'Japanese', 'level': widget.level});

//     try {
//       final response = await http.post(url, headers: headers, body: body);
//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         final parsed = SpeakingResponse.fromJson(jsonResponse);
//         setState(() {
//           _data = parsed;
//           _isLoading = false;
//         });
//       } else {
//         throw Exception("Failed: ${response.statusCode}");
//       }
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _playAudio(String url) async {
//     try {
//       await _player.setUrl(url);
//       await _player.play();
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Audio error: $e")));
//     }
//   }

//   Future<void> _startListening(String expectedText) async {
//     bool available = await _speech.initialize();
//     if (available) {
//       _speech.listen(
//         onResult: (result) {
//           setState(() {
//             _spokenText = result.recognizedWords;
//             _evaluateSpeech(expectedText, _spokenText);
//           });
//         },
//       );
//     }
//   }

//   void _evaluateSpeech(String expected, String spoken) {
//     double score = _calculateSimilarity(expected, spoken);
//     if (score > 0.9) {
//       _feedback = "✅ Excellent!";
//     } else if (score > 0.7) {
//       _feedback = "⚠️ Good, but try again.";
//     } else {
//       _feedback =
//           "❌ Incorrect. Tips:\n• Speak slowly\n• Break into syllables\n• Re-listen the audio";
//     }
//   }

//   double _calculateSimilarity(String a, String b) {
//     a = a.toLowerCase();
//     b = b.toLowerCase();
//     int matches = 0;
//     int minLen = a.length < b.length ? a.length : b.length;
//     for (int i = 0; i < minLen; i++) {
//       if (a[i] == b[i]) matches++;
//     }
//     return matches / a.length;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentItem = _data?.audioList[_currentIndex];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('${widget.theme} - Level ${widget.level}'),
//         backgroundColor: Colors.blue.shade700,
//         foregroundColor: Colors.white,
//       ),
//       body:
//           _isLoading
//               ? Center(child: CircularProgressIndicator(color: Colors.blue))
//               : _error != null
//               ? Center(child: Text("Error: $_error"))
//               : _data == null || _data!.audioList.isEmpty
//               ? Center(child: Text("No data found"))
//               : Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Text(
//                       currentItem!.text,
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blue.shade800,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton.icon(
//                       icon: Icon(Icons.volume_up),
//                       label: Text("Play Audio"),
//                       onPressed: () => _playAudio(currentItem.audio),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton.icon(
//                       icon: Icon(Icons.mic),
//                       label: Text("Speak Now"),
//                       onPressed: () => _startListening(currentItem.text),
//                     ),
//                     const SizedBox(height: 12),
//                     if (_spokenText.isNotEmpty)
//                       Text(
//                         "You said: $_spokenText",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     const SizedBox(height: 8),
//                     if (_feedback.isNotEmpty)
//                       Text(
//                         _feedback,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color:
//                               _feedback.contains("✅")
//                                   ? Colors.green
//                                   : _feedback.contains("⚠️")
//                                   ? Colors.orange
//                                   : Colors.red,
//                         ),
//                       ),
//                     const Spacer(),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ElevatedButton(
//                           onPressed:
//                               _currentIndex > 0
//                                   ? () {
//                                     setState(() {
//                                       _currentIndex--;
//                                       _spokenText = "";
//                                       _feedback = "";
//                                     });
//                                   }
//                                   : null,
//                           child: Text("Prev"),
//                         ),
//                         ElevatedButton(
//                           onPressed:
//                               _currentIndex < _data!.audioList.length - 1
//                                   ? () {
//                                     setState(() {
//                                       _currentIndex++;
//                                       _spokenText = "";
//                                       _feedback = "";
//                                     });
//                                   }
//                                   : null,
//                           child: Text("Next"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }
// }
