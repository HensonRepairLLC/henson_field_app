import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  final SupabaseService _svc = SupabaseService();
  List<Map<String, dynamic>> _jobs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final orgId = 'REPLACE_WITH_ORG_ID';
      final jobs = await _svc.fetchJobs(orgId);
      setState(() {
        _jobs = jobs;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      debugPrint('Error loading jobs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return ListView.builder(
      itemCount: _jobs.length,
      itemBuilder: (context, i) {
        final job = _jobs[i];
        final title = job['title'] ?? 'Untitled';
        final site = job['sites']?['name'] ?? 'No site';
        return ListTile(
          title: Text(title),
          subtitle: Text(site),
          onTap: () {
            Navigator.of(context).pushNamed('/job', arguments: job);
          },
        );
      },
    );
  }
}
