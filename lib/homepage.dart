import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          'Smart Home Dashboard (Coming Soon)',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
