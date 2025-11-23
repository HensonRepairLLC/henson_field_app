import 'package:flutter/material.dart';
import '../../widgets/photo_uploader.dart';
import '../../widgets/signature_pad.dart';
import '../../services/time_service.dart';
import '../../widgets/job_media_gallery.dart';
import '../../widgets/job_checklist.dart';
import '../../widgets/parts_list.dart';
import '../../widgets/open_map_button.dart';

class JobDetailScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final TimeService _time = TimeService();
  bool clockedIn = false;
  String? activeLogId;

  Future<void> _clockIn() async {
    await _time.clockIn(widget.job['id']);
    setState(() => clockedIn = true);
  }

  Future<void> _clockOut() async {
    if (activeLogId != null) {
      await _time.clockOut(activeLogId!);
      setState(() => clockedIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return Scaffold(
      appBar: AppBar(title: Text(job['title'] ?? 'Job Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job['description'] ?? 'No description'),
            const SizedBox(height: 20),

            Row(
              children: [
                ElevatedButton(
                  onPressed: clockedIn ? null : _clockIn,
                  child: const Text('Clock In'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: clockedIn ? _clockOut : null,
                  child: const Text('Clock Out'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            JobMediaGallery(jobId: job['id']),
            const SizedBox(height: 20),
            JobChecklist(jobId: job['id']),
            const SizedBox(height: 20),
            PartsList(jobId: job['id']),
            const SizedBox(height: 20),
            OpenMapButton(address: job['address'] ?? ''),
            const SizedBox(height: 20),
            PhotoUploader(jobId: job['id']),
            const SizedBox(height: 20),
            SignaturePad(jobId: job['id']),
          ],
        ),
      ),
    );
  }
}
