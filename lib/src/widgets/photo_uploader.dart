import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class PhotoUploader extends StatefulWidget {
  final String jobId;
  const PhotoUploader({super.key, required this.jobId});

  @override
  State<PhotoUploader> createState() => _PhotoUploaderState();
}

class _PhotoUploaderState extends State<PhotoUploader> {
  final picker = ImagePicker();
  bool uploading = false;
  final supabase = Supabase.instance.client;

  Future<void> _pick() async {
    final img = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (img == null) return;
    await _upload(File(img.path));
  }

  Future<void> _upload(File file) async {
    setState(() => uploading = true);
    try {
      final path = "job_photos/${widget.jobId}/${const Uuid().v4()}.jpg";
      await supabase.storage.from('job_files').upload(path, file);

      await supabase.from('job_files').insert({
        'job_id': widget.jobId,
        'storage_path': path,
        'file_type': 'photo',
        'created_by': supabase.auth.currentUser!.id,
      });
    } catch (e) {
      debugPrint("Photo upload error: $e");
    } finally {
      setState(() => uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Photos", style: TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: uploading ? null : _pick,
            ),
          ],
        ),
        if (uploading) const LinearProgressIndicator(),
      ],
    );
  }
}
