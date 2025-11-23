import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;

  Future<void> _signIn() async {
    setState(() => loading = true);
    final supabase = Supabase.instance.client;
    final res = await supabase.auth.signInWithPassword(
      email: emailCtrl.text.trim(),
      password: passCtrl.text.trim(),
    );
    setState(() => loading = false);
    if (res.error == null) {
      if (mounted) Navigator.of(context).pushReplacementNamed('/home');
    } else {
      final msg = res.error!.message;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: loading ? null : _signIn, child: loading ? const CircularProgressIndicator() : const Text('Sign In'))
          ],
        ),
      ),
    );
  }
}
