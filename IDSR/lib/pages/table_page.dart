import 'package:flutter/material.dart';
import '/models/idsr_case.dart';
import '/api/idsr_api.dart';

class TablePage extends StatefulWidget {
  final IdsrApi api;

  const TablePage({Key? key, required this.api}) : super(key: key);
  
  @override
  State<TablePage> createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  List<IdsrCase> _cases = [];
  List<IdsrCase> _filteredCases = [];
  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _loadCases();
    _searchController.addListener(_filterCases);
  }

  Future<void> _loadCases() async {
    try {
      final cases = await widget.api.fetchCases();
      setState(() {
        _cases = cases;
        _filteredCases = cases;
        _currentPage = 0;
        _sortByPatientId();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading cases: $e')),
      );
    }
  }

  void _filterCases() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCases = _cases.where((c) {
        return (c.fullName?.toLowerCase().contains(query) ?? false) ||
            (c.disease?.toLowerCase().contains(query) ?? false) ||
            (c.district?.toLowerCase().contains(query) ?? false);
      }).toList();
      _currentPage = 0;
      _sortByPatientId();
    });
  }

  void _sortByPatientId() {
    _filteredCases.sort((a, b) {
      final idA = a.patientId ?? 0;
      final idB = b.patientId ?? 0;
      return _sortAscending ? idA.compareTo(idB) : idB.compareTo(idA);
    });
  }

  void _toggleSort() {
    setState(() {
      _sortAscending = !_sortAscending;
      _sortByPatientId();
    });
  }

  List<IdsrCase> get _currentPageCases {
    final start = _currentPage * _pageSize;
    return _filteredCases.skip(start).take(_pageSize).toList();
  }

  void _nextPage() {
    if ((_currentPage + 1) * _pageSize < _filteredCases.length) {
      setState(() => _currentPage++);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCases,
            tooltip: 'Refresh Table',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0), // only horizontal padding
        child: Column(
          children: [
            const SizedBox(height: 8), // minimal top spacing
            // Search Box
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Name, Disease, or District',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 8), // minimal spacing before table

            // Table inside card
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      sortColumnIndex: 0,
                      sortAscending: _sortAscending,
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blueGrey.shade50),
                      columnSpacing: 20,
                      horizontalMargin: 12,
                      columns: [
                        DataColumn(
                          label: Row(
                            children: [
                              const Text('Patient ID',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Icon(
                                _sortAscending
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                size: 20,
                              )
                            ],
                          ),
                          onSort: (columnIndex, _) {
                            _toggleSort();
                          },
                        ),
                        const DataColumn(
                            label: Text('Name',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(
                            label: Text('Age',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(
                            label: Text('Sex',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(
                            label: Text('Disease',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(
                            label: Text('District',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(
                            label: Text('Outcome',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        const DataColumn(
                            label: Text('Region',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: _currentPageCases.map((c) {
                        return DataRow(cells: [
                          DataCell(Text(c.patientId?.toString() ?? '')),
                          DataCell(Text(c.fullName ?? '')),
                          DataCell(Text(c.age?.toString() ?? '')),
                          DataCell(Text(c.sex ?? '')),
                          DataCell(Text(c.disease ?? '')),
                          DataCell(Text(c.district ?? '')),
                          DataCell(Text(c.outcome ?? '')),
                          DataCell(Text(c.region ?? '')),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8), // minimal spacing before pagination

            // Pagination Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _previousPage,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _nextPage,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
