import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JobMediaGallery extends StatelessWidget {
  final String jobId;
  const JobMediaGallery({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: supabase.from('job_files').select().eq('job_id', jobId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final items = snapshot.data!;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (context, i) {
            final file = items[i];
            final path = file['storage_path'];
            final url = supabase.storage.from('job_files').getPublicUrl(path);

            return GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (_) => Dialog(
                  child: Image.network(url, fit: BoxFit.contain),
                ),
              ),
              child: Image.network(url, fit: BoxFit.cover),
            );
          },
        );
      },
    );
  }
}
