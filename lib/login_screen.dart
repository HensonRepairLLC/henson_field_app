// lib/login_screen.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// LoginScreen: email/password login using Supabase.
/// After successful login it looks up the user's role in `profiles` table
/// and navigates to the AdminDashboard if role == 'admin'.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _supabase = Supabase.instance.client;

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _showMessage(String message, {bool error = false}) async {
    final snack = SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.redAccent : Colors.green,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter email and password', error: true);
      return;
    }

    setState(() => _loading = true);

    try {
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;
      final session = res.session;

      if (user == null) {
        // If signIn didn't return user, surface message from res
        final msg = res.error?.message ?? 'Login failed';
        await _showMessage(msg, error: true);
        setState(() => _loading = false);
        return;
      }

      // Success — optionally you can persist extra data, but now fetch role
      await _showMessage('Login successful');

      // Query the profiles (or users) table to get the role
      // Assumes `profiles` table with columns: id (uuid/text), role (text)
      final profileRes = await _supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      String role = '';

      if (profileRes != null && profileRes is Map && profileRes['role'] != null) {
        role = profileRes['role'] as String;
      } else {
        // Fallback: if there's no profile row, you may want to default to 'tech' or create one.
        role = 'tech';
      }

      // NAVIGATION: Replace the login route so the user can't press back to return to login.
      if (!mounted) return;

      if (role == 'admin') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      } else {
        // If it's not admin, send to a tech dashboard (placeholder)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const TechnicianHome()),
        );
      }
    } on AuthException catch (e) {
      await _showMessage(e.message, error: true);
    } catch (e) {
      await _showMessage('Unexpected error: $e', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _goToSignUp() async {
    // Implement sign-up or forgot password flow if you want.
    // Example: Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Henson Field — Login'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo or image
                  SizedBox(
                    height: 120,
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.build_circle_outlined, size: 96),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    onSubmitted: (_) => _signIn(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    onSubmitted: (_) => _signIn(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _signIn,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign in'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _goToSignUp,
                        child: const Text('Sign up / Forgot password'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Quick dev helper: fill test creds (remove in prod)
                          _emailController.text = 'admin@example.com';
                          _passwordController.text = 'password123';
                        },
                        child: const Text('Fill test'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Minimal Admin Dashboard placeholder
class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    // Replace current screen with login again
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome, Admin!\nReplace this with your full Admin Dashboard.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Minimal Technician home placeholder for non-admin users
class TechnicianHome extends StatelessWidget {
  const TechnicianHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Technician Home'),
      ),
      body: const Center(child: Text('Technician UI goes here')),
    );
  }
}
