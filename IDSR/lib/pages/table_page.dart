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
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading cases: $e')));
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
    });
  }

  List<IdsrCase> get _currentPageCases {
    final start = _currentPage * _pageSize;
    return _filteredCases.skip(start).take(_pageSize).toList();
  }

  void _nextPage() {
    if ((_currentPage + 1) * _pageSize < _filteredCases.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
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
        title: const Text('Cases Table'),
        actions: [  
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCases,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(labelText: 'Search by Name, Disease or District'),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Patient ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Age')),
                  DataColumn(label: Text('Sex')),
                  DataColumn(label: Text('Disease')),
                  DataColumn(label: Text('District')),
                  DataColumn(label: Text('Outcome')),
                  // Add more columns as needed
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
                  ]);
                }).toList(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _previousPage, child: const Text('Previous')),
              const SizedBox(width: 20),
              ElevatedButton(onPressed: _nextPage, child: const Text('Next')),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
   