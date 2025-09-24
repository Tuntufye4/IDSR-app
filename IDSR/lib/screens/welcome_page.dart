// lib/screens/welcome_page.dart
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _acknowledged = false;

  void _proceed() {
    if (_acknowledged) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please acknowledge before proceeding.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // ✅ Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 60),

                      // Centered IDSR text
                      const Text(
                        "IDSR",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 120),

                      // ✅ Move description closer to bottom
                      const Text(
                        "This app is for Integrated Disease Surveillance and Response (IDSR) "
                        "data collection and reporting. Please acknowledge before continuing.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Checkbox(
                            value: _acknowledged,
                            onChanged: (value) {
                              setState(() {
                                _acknowledged = value ?? false;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              "I acknowledge that I have read and understood the purpose of this application.",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ✅ Sticky bottom button
              SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _proceed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blue, // 🔵 Blue background
                      foregroundColor: Colors.white, // ⚪ White text     
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 16),
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
}
