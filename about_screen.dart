import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.draw, size: 80, color: Colors.indigo),
              SizedBox(height: 16),
              Text('Handwritten Notes App',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Version 1.0'),
              SizedBox(height: 16),
              Text(
                  'Write notes by hand, organise them in folders and plan your day.',
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
