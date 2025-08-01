import 'package:flutter/material.dart';
import 'pages/form_page.dart';
import 'pages/charts_page.dart';
import 'pages/table_page.dart';
import 'api/idsr_api.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme; 
  final IdsrApi api;

  const HomePage({super.key, required this.toggleTheme, required this.api});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      FormPage(api: widget.api),
      ChartsPage(api: widget.api),
      TablePage(api: widget.api),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return "IDSR Form";
      case 1:
        return "Charts";
      case 2:
        return "Reports Table";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getAppBarTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: "Toggle Light/Dark Mode",
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue[700],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt),
            label: 'Form',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_rows),
            label: 'Table',
          ),
        ],
      ),
    );
  }
}
