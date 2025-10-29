import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/models/idsr_case.dart';
import '/api/idsr_api.dart';

class ChartsPage extends StatefulWidget {
  final IdsrApi api;

  const ChartsPage({Key? key, required this.api}) : super(key: key);

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}   

class _ChartsPageState extends State<ChartsPage> {
  List<IdsrCase> _cases = [];
  Map<String, int> _diseaseCounts = {};
  Map<String, int> _groupedCounts = {};

  String _groupBy = 'district';
  String? _selectedYear;
  String? _selectedClassification;
  int? _touchedPieIndex;

  @override
  void initState() {
    super.initState();
    _loadCases();
  }

  Future<void> _loadCases() async {
    try {
      final cases = await widget.api.fetchCases();
      setState(() {
        _cases = cases;
        _calculateDiseaseCounts();
        _calculateGroupedCounts();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading cases: $e')),
      );
    }
  }

  bool _filterCase(IdsrCase c) {
    if (_selectedYear != null && c.year?.toString() != _selectedYear) return false;
    if (_selectedClassification != null &&
        c.caseClassification?.toLowerCase() != _selectedClassification?.toLowerCase()) return false;
    return true;
  }

  void _calculateDiseaseCounts() {
    final counts = <String, int>{};
    for (var c in _cases) {
      if (_filterCase(c)) {
        final disease = c.disease ?? 'Unknown';
        counts[disease] = (counts[disease] ?? 0) + 1;
      }
    }
    _diseaseCounts = counts;
  }

  void _calculateGroupedCounts() {
    final counts = <String, int>{};
    for (var c in _cases) {
      if (_filterCase(c)) {
        final key = _groupBy == 'district'
            ? c.district ?? 'Unknown'
            : _groupBy == 'region'
                ? c.region ?? 'Unknown'
                : c.outcome ?? 'Unknown';
        counts[key] = (counts[key] ?? 0) + 1;
      }
    }
    _groupedCounts = counts;
  }

  @override
  Widget build(BuildContext context) {
    final diseaseEntries = _diseaseCounts.entries.toList();
    final barGroups = diseaseEntries.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.value.toDouble(),
            color: Colors.blue,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          )
        ],
      );
    }).toList();

    final pieEntries = _groupedCounts.entries.toList();
    final availableYears = _cases.map((e) => e.year?.toString()).whereType<String>().toSet().toList();
    final classifications = _cases.map((e) => e.caseClassification).whereType<String>().toSet().toList();

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), // charts close to AppBar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: _selectedYear,
                    hint: const Text("Filter by year"),
                    items: availableYears
                        .map((year) => DropdownMenuItem(value: year, child: Text(year)))
                        .toList(),
                    onChanged: (val) => setState(() {
                      _selectedYear = val;
                      _calculateDiseaseCounts();
                      _calculateGroupedCounts();
                    }),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: _selectedClassification,
                    hint: const Text("Filter by classification"),
                    items: classifications
                        .map((cls) => DropdownMenuItem(value: cls, child: Text(cls)))
                        .toList(),
                    onChanged: (val) => setState(() {
                      _selectedClassification = val;
                      _calculateDiseaseCounts();
                      _calculateGroupedCounts();
                    }),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: _groupBy,
                    items: ['district', 'region', 'outcome']
                        .map((g) => DropdownMenuItem(value: g, child: Text('Group by $g')))
                        .toList(),
                    onChanged: (val) => setState(() {
                      _groupBy = val!;
                      _calculateGroupedCounts();
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bar Chart in Card
            if (_diseaseCounts.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Cases by Disease",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 250,
                        child: BarChart(
                          BarChartData(
                            barGroups: barGroups,
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true), // Y-axis counts
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true, // show disease names
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    if (index < 0 || index >= diseaseEntries.length) {
                                      return const SizedBox.shrink();
                                    }
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        diseaseEntries[index].key,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    );
                                  },
                                  reservedSize: 48,
                                ),
                              ),
                              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            barTouchData: BarTouchData(
                              enabled: false, // tooltips disabled
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Pie Chart in Card
            if (_groupedCounts.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Cases by ${_groupBy[0].toUpperCase()}${_groupBy.substring(1)}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 300,
                        child: PieChart(
                          PieChartData(
                            sections: pieEntries.asMap().entries.map((entry) {
                              final index = entry.key;
                              final e = entry.value;
                              final total = _groupedCounts.values.fold<int>(0, (a, b) => a + b);
                              final percent = (e.value / total) * 100;
                              final isTouched = _touchedPieIndex == index;
                              return PieChartSectionData(
                                value: e.value.toDouble(),
                                color: Colors.primaries[index % Colors.primaries.length],
                                radius: isTouched ? 90 : 80,
                                title: '${percent.toStringAsFixed(1)}%',
                                titleStyle: TextStyle(
                                  fontSize: isTouched ? 14 : 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            pieTouchData: PieTouchData(
                              touchCallback: (event, pieTouchResponse) {
                                setState(() {
                                  _touchedPieIndex =
                                      pieTouchResponse?.touchedSection?.touchedSectionIndex;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Legend
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: pieEntries.asMap().entries.map((entry) {
                          final index = entry.key;
                          final e = entry.value;
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.primaries[index % Colors.primaries.length],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(e.key, style: const TextStyle(fontSize: 12)),
                            ],
                          );
                        }).toList(),
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
}
