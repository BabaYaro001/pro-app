import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import 'role_dashboard.dart'; // Placeholder for dashboards (to implement)
import 'package:url_launcher/url_launcher.dart';

enum UserRole { admin, teacher, student, parent }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole? _role;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select your role.')),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement role-based authentication using your database logic
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RoleDashboard(role: _role!), // Implement this per role
        ),
      );
    }
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  void _applyToSchool() async {
    const url = "https://your-school-website.com/apply"; // <-- Set your real link here later
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/wallpaper.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: SingleChildScrollView(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/logo.png', width: 70),
                      const SizedBox(height: 8),
                      const Text("Login", style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<UserRole>(
                        value: _role,
                        decoration: const InputDecoration(
                          labelText: "Select Role",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: UserRole.admin, child: Text("Admin")),
                          DropdownMenuItem(value: UserRole.teacher, child: Text("Teacher")),
                          DropdownMenuItem(value: UserRole.student, child: Text("Student")),
                          DropdownMenuItem(value: UserRole.parent, child: Text("Parent")),
                        ],
                        onChanged: (val) => setState(() => _role = val),
                      ),
                      const SizedBox(height: 18),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(labelText: "Username", border: OutlineInputBorder()),
                              validator: (v) => v == null || v.isEmpty ? "Enter username" : null,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                              validator: (v) => v == null || v.isEmpty ? "Enter password" : null,
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text("Login"),
                            ),
                            TextButton(
                              onPressed: _forgotPassword,
                              child: const Text("Forgot password?"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _applyToSchool,
                        child: const Text(
                          "Apply to School",
                          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}