import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Text(
            '''
This School Management App is committed to safeguarding your privacy. We do not share your personal data with third parties. All your information is securely stored locally on your device or on our school's secure servers.

We only collect information necessary for school operations, such as student, parent, teacher, and admin details. No unnecessary data is collected.

If you have questions about our privacy practices, please contact the school administration.
''',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}