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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false, // ✅ Left aligned
        title: const Text(
          "IDSR",   
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            fontSize: 24, 
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6, color: Colors.grey),
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
