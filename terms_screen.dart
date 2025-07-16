import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terms of Service")),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Text(
            '''
By using this School Management App, you agree to:

- Use the app only for legitimate school-related purposes.
- Not attempt to access or modify data you are not authorized for.
- Keep your login credentials private and secure.
- Report any bugs or suspicious activity to the school administration.

Violation of these terms may result in your account being suspended.
''',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}