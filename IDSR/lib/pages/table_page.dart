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

  int? _sortColumnIndex;
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
        _sort<num>((c) => c.id ?? 0, 0, true);
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
      _sort<num>((c) => c.id ?? 0, 0, _sortAscending);
    });
  }

  void _sort<T>(
    Comparable<T>? Function(IdsrCase c) getField,
    int columnIndex,
    bool ascending,
  ) {
    _filteredCases.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue ?? '' as Comparable<T>, bValue ?? '' as Comparable<T>)
          : Comparable.compare(bValue ?? '' as Comparable<T>, aValue ?? '' as Comparable<T>);
    });

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
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
        title: const Text('IDSR Cases'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCases,
            tooltip: 'Refresh Table',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
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
            const SizedBox(height: 8),
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
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAscending,
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blueGrey.shade50,
                      ),
                      columnSpacing: 20,
                      horizontalMargin: 12,
                      columns: [
                        DataColumn(
                          label: const Text('ID',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onSort: (colIndex, asc) =>
                              _sort<num>((c) => c.id ?? 0, colIndex, asc),
                        ),
                        DataColumn(
                          label: const Text('Name',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onSort: (colIndex, asc) =>
                              _sort<String>((c) => c.fullName ?? '', colIndex, asc),
                        ),
                        DataColumn(
                          label: const Text('Age',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          numeric: true,
                          onSort: (colIndex, asc) =>
                              _sort<num>((c) => c.age ?? 0, colIndex, asc),
                        ),
                        DataColumn(
                          label: const Text('Sex',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onSort: (colIndex, asc) =>
                              _sort<String>((c) => c.sex ?? '', colIndex, asc),
                        ),
                        DataColumn(
                          label: const Text('Disease',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onSort: (colIndex, asc) =>
                              _sort<String>((c) => c.disease ?? '', colIndex, asc),
                        ),
                        DataColumn(
                          label: const Text('District',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onSort: (colIndex, asc) =>
                              _sort<String>((c) => c.district ?? '', colIndex, asc),
                        ),
                        DataColumn(
                          label: const Text('Outcome',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onSort: (colIndex, asc) =>
                              _sort<String>((c) => c.outcome ?? '', colIndex, asc),
                        ),
                        DataColumn(
                          label: const Text('Region',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onSort: (colIndex, asc) =>
                              _sort<String>((c) => c.region ?? '', colIndex, asc),
                        ),
                      ],
                      rows: _currentPageCases.map((c) {
                        return DataRow(cells: [
                          DataCell(Text(c.id?.toString() ?? '')),
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
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _previousPage,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _nextPage,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
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
