import 'package:flutter/material.dart';
import 'job_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Henson Field Service - Home')),
      body: const JobListScreen(),
    );
  }
}
