import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart

// --- Data Model for Bar Chart ---
class BarChartDataPoint {
  final String day;
  final double value1; // e.g., current week's progress
  final double value2; // e.g., previous week's progress for comparison

  BarChartDataPoint(this.day, this.value1, this.value2);
}

// Example data (adjust as per your actual data)
List<BarChartDataPoint> barChartData = [
  BarChartDataPoint('Mon', 38, 45),
  BarChartDataPoint('Tue', 48, 49),
  BarChartDataPoint('Wed', 29, 25),
  BarChartDataPoint('Thu', 58, 41),
  BarChartDataPoint('Fri', 14, 10),
  BarChartDataPoint('Sat', 2, 3),
  BarChartDataPoint('Sun', 3, 2),
];

// --- MyBarChart Widget (as provided previously) ---
class MyBarChart extends StatelessWidget {
  final List<BarChartDataPoint> data;

  const MyBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7, // Adjust aspect ratio as needed
      child: BarChart(
        BarChartData(
          barGroups: _buildBarGroups(),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Ensure value is within bounds of data list
                  if (value.toInt() >= 0 && value.toInt() < data.length) {
                    return Text(
                      data[value.toInt()].day,
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 22,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  String text = '';
                  if (value == 0) {
                    text = '0M';
                  } else if (value == 20) {
                    text = '20M';
                  } else if (value == 40) {
                    text = '40M';
                  } else if (value == 60) {
                    text = '60M';
                  }
                  return Text(text, style: const TextStyle(fontSize: 10));
                },
                reservedSize: 28,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) {
              return const FlLine(color: Colors.grey, strokeWidth: 0.5);
            },
          ),
          // barTouchData: BarTouchData(enabled: false),
          borderData: FlBorderData(show: false),
          minY: 0,
          maxY: 60,
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index].value1,
            color: Colors.blue.shade600, // Darker blue for the first bar
            width: 8,
            borderRadius: BorderRadius.zero,
          ),
          BarChartRodData(
            toY: data[index].value2,
            color: Colors.blue.shade300, // Lighter blue for the second bar
            width: 8,
            borderRadius: BorderRadius.zero,
          ),
        ],
        showingTooltipIndicators: [],
      );
    });
  }
}

class BarTouchData {}

// --- Your Original ProgressScreen with Graph Integration ---
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String selectedWeek = 'Dec, Week 3'; // State for the dropdown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade600, Colors.blue.shade900],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Progress',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                // Use Expanded to make the white container take remaining space
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    // Add SingleChildScrollView for potential overflow
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Progress This Week',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            // Dropdown for week selection
                            DropdownButton<String>(
                              value: selectedWeek,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(), // Remove the underline
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedWeek = newValue!;
                                });
                              },
                              items:
                                  <String>[
                                    'Dec, Week 3',
                                    'Dec, Week 2',
                                    'Dec, Week 1',
                                  ].map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ), // Spacing after title/dropdown
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween, // Use spaceBetween or spaceEvenly
                          children: [
                            Expanded(
                              child: _buildProgressCard(
                                title: '18H',
                                subtitle: 'Time Spend',
                                percentage: -4,
                                percentageText: '-4% than last week',
                                icon: Icons.trending_down,
                                iconColor: Colors.red,
                                backgroundColor: Colors.red.shade50,
                              ),
                            ),
                            const SizedBox(width: 16), // Spacing between cards
                            Expanded(
                              child: _buildProgressCard(
                                title: '1402',
                                subtitle: 'Total Stars',
                                percentage: 1,
                                percentageText: '+1% than last week',
                                icon: Icons.trending_up,
                                iconColor: Colors.green,
                                backgroundColor: Colors.green.shade50,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20), // Spacing before the graph
                        // --- Integrated Bar Chart ---
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color:
                                Colors
                                    .grey
                                    .shade100, // Slightly off-white background for graph
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ), // Light border
                          ),
                          child: MyBarChart(data: barChartData),
                        ),
                        const SizedBox(height: 20), // Spacing after the graph

                        Text(
                          '4 Main Lessons Progress',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Your Progress this week for 4 main lessons',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ), // Spacing before lesson cards
                        LessonProgress(
                          type: 'Grammer',
                          level: '8',
                          perc:
                              80, // Changed percentage to be out of 100 for progress bar
                          icondata: Icons.layers,
                        ),
                        LessonProgress(
                          type: 'Vocabulary',
                          level: '15',
                          perc: 40,
                          icondata: Icons.content_paste_search_sharp,
                        ),
                        LessonProgress(
                          type: 'Listening',
                          level: '4',
                          perc: 16,
                          icondata: Icons.volume_up,
                        ),
                        LessonProgress(
                          type: 'Speaking',
                          level: '10',
                          perc: 70,
                          icondata: Icons.mic,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the progress cards (Time Spend, Total Stars)
  Widget _buildProgressCard({
    required String title,
    required String subtitle,
    required int percentage,
    required String percentageText,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
  }) {
    return Card(
      elevation: 0, // No shadow for cards
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(subtitle, style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize
                        .min, // Keep this as it correctly sizes the outer Container
                children: [
                  Icon(icon, color: iconColor, size: 16),
                  const SizedBox(width: 4),
                  // FIX: Wrap the Text with Expanded
                  Expanded(
                    child: Text(
                      percentageText,
                      style: TextStyle(color: iconColor, fontSize: 12),
                      overflow:
                          TextOverflow
                              .ellipsis, // Add ellipsis for long text if it still overflows
                      maxLines: 1, // Ensure it stays on one line
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonProgress extends StatelessWidget {
  final String type;
  final String level;
  final int perc;
  final IconData icondata;
  const LessonProgress({
    super.key,
    required this.type,
    required this.level,
    required this.perc,
    required this.icondata,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0, // Removed card elevation for flatter look
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
      ), // Add vertical margin between cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Padding inside the card
        child: Column(
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50, // Light blue background for icon
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icondata, color: Colors.blue), // Blue icon color
              ),
              title: Text(
                type,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '$level level',
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: Text(
                '$perc%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ), // Padding for the progress bar
              child: LinearProgressIndicator(
                value: perc / 100, // Value should be between 0.0 and 1.0
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
                minHeight: 8, // Adjusted minHeight
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8), // Small space at the bottom of the card
          ],
        ),
      ),
    );
  }
}
