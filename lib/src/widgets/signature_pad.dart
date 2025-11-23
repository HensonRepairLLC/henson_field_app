import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SignaturePad extends StatefulWidget {
  final String jobId;
  const SignaturePad({super.key, required this.jobId});

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final SignatureController _controller = SignatureController(penStrokeWidth: 3, penColor: Colors.black);
  final supabase = Supabase.instance.client;
  bool saving = false;

  Future<void> _save() async {
    setState(() => saving = true);
    try {
      final data = await _controller.toPngBytes();
      if (data == null) return;

      final path = "signatures/${widget.jobId}/${const Uuid().v4()}.png";
      await supabase.storage.from('job_files').uploadBinary(path, data);

      await supabase.from('job_files').insert({
        'job_id': widget.jobId,
        'storage_path': path,
        'file_type': 'signature',
        'created_by': supabase.auth.currentUser!.id,
      });

      _controller.clear();
    } catch (e) {
      debugPrint("Signature upload error: $e");
    } finally {
      setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Customer Signature", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          height: 200,
          decoration: BoxDecoration(border: Border.all()),
          child: Signature(controller: _controller, backgroundColor: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: _controller.clear, child: const Text("Clear")),
            ElevatedButton(
              onPressed: saving ? null : _save,
              child: const Text("Save Signature"),
            ),
          ],
        ),
      ],
    );
  }
}
