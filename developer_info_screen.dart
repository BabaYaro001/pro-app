import 'package:flutter/material.dart';

class DeveloperInfoScreen extends StatelessWidget {
  const DeveloperInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Developer Info")),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Developer Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text("Developed by: [Your Name or School Name]"),
            Text("Contact: [your@email.com]"),
            Text("GitHub: github.com/[yourusername]"),
            SizedBox(height: 20),
            Text("For any issues or suggestions, please contact the developer or school admin."),
          ],
        ),
      ),
    );
  }
}