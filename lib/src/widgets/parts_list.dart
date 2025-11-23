import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PartsList extends StatefulWidget {
  final String jobId;
  const PartsList({super.key, required this.jobId});

  @override
  State<PartsList> createState() => _PartsListState();
}

class _PartsListState extends State<PartsList> {
  final supabase = Supabase.instance.client;
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController qtyCtrl = TextEditingController();

  Future<List<Map<String, dynamic>>> _load() async {
    return await supabase.from('job_parts').select().eq('job_id', widget.jobId);
  }

  Future<void> _add() async {
    await supabase.from('job_parts').insert({
      'job_id': widget.jobId,
      'name': nameCtrl.text,
      'qty': int.tryParse(qtyCtrl.text) ?? 1,
    });

    nameCtrl.clear();
    qtyCtrl.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Parts & Materials", style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Part name"),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 80,
              child: TextField(
                controller: qtyCtrl,
                decoration: const InputDecoration(labelText: "Qty"),
                keyboardType: TextInputType.number,
              ),
            ),
            IconButton(icon: const Icon(Icons.add), onPressed: _add)
          ],
        ),

        FutureBuilder(
          future: _load(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            final items = snapshot.data!;

            return Column(
              children: items
                  .map((p) => ListTile(
                        title: Text(p['name']),
                        trailing: Text("x${p['qty']}")
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
