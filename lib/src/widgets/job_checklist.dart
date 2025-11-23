import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JobChecklist extends StatefulWidget {
  final String jobId;
  const JobChecklist({super.key, required this.jobId});

  @override
  State<JobChecklist> createState() => _JobChecklistState();
}

class _JobChecklistState extends State<JobChecklist> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> _load() async {
    return await supabase
        .from('job_checklist')
        .select()
        .eq('job_id', widget.jobId)
        .order('position', ascending: true);
  }

  Future<void> _toggle(Map<String, dynamic> item) async {
    await supabase
        .from('job_checklist')
        .update({'completed': !(item['completed'] ?? false)})
        .eq('id', item['id']);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _load(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final items = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Checklist", style: TextStyle(fontWeight: FontWeight.bold)),
            ...items.map((i) => CheckboxListTile(
                  value: i['completed'],
                  onChanged: (_) => _toggle(i),
                  title: Text(i['text']),
                )),
          ],
        );
      },
    );
  }
}
