import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'home_page.dart';
import 'api/idsr_api.dart';

void main() {
  runApp(const IdsrApp());
}  

class IdsrApp extends StatefulWidget {
  const IdsrApp({super.key});

  @override
  State<IdsrApp> createState() => _IdsrAppState();
}

class _IdsrAppState extends State<IdsrApp> {
  bool _isDark = false;

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  // ✅ USE THE CORRECT BASE URL FOR YOUR ENVIRONMENT
  // For Android Emulator, use 10.0.2.2
  // For Android Device or iOS Simulator, replace with your local IP address
  final IdsrApi _api = IdsrApi(baseUrl: 'http://127.0.0.1:8000/api');             

  @override   
  Widget build(BuildContext context) {      
    return MaterialApp(  
      title: 'IDSR',
      debugShowCheckedModeBanner: false,
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => HomePage(toggleTheme: _toggleTheme, api: _api),
      },
    );
  }
}
