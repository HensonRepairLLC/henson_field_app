import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpenMapButton extends StatelessWidget {
  final String address;
  const OpenMapButton({super.key, required this.address});

  Future<void> _open() async {
    final encoded = Uri.encodeComponent(address);
    final google = Uri.parse("https://www.google.com/maps/search/?api=1&query=$encoded");
    await launchUrl(google, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.map),
      label: const Text("Open in Maps"),
      onPressed: _open,
    );
  }
}
