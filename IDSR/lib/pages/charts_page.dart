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

  bool _filterCase(IdsrCase c) {
    if (_selectedYear != null && c.year?.toString() != _selectedYear) {
      return false;
    }
    if (_selectedClassification != null &&
        c.caseClassification?.toLowerCase() != _selectedClassification?.toLowerCase()) {
      return false;
    }
    return true;
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
        showingTooltipIndicators: [0],
      );
    }).toList();

    final pieEntries = _groupedCounts.entries.toList();

    final availableYears = _cases.map((e) => e.year?.toString()).whereType<String>().toSet().toList();
    final classifications = _cases.map((e) => e.caseClassification).whereType<String>().toSet().toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Disease Charts')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
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
            const SizedBox(height: 24),

            // Bar Chart
            if (_diseaseCounts.isNotEmpty)
              SizedBox(
                height: 250,
                child: BarChart(
                  BarChartData(
                    barGroups: barGroups,
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
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
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 32),

            // Pie Chart
            if (_groupedCounts.isNotEmpty)
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sections: pieEntries.map((e) {
                      final percentage = (e.value / _groupedCounts.values.reduce((a, b) => a + b)) * 100;
                      return PieChartSectionData(
                        title: '${e.key} (${percentage.toStringAsFixed(1)}%)',
                        value: e.value.toDouble(),
                        radius: 80,
                        titleStyle: const TextStyle(fontSize: 12),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
  