import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  String? _sentOtp;
  bool _otpPhase = false;

  void _sendOtp() {
    // TODO: Connect with DB and send OTP here
    setState(() {
      _sentOtp = "123456"; // Simulated OTP
      _otpPhase = true;
    });
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("OTP Sent"),
        content: const Text("An OTP has been sent to your registered email."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK")),
        ],
      ),
    );
  }

  void _verifyOtp() {
    if (_otpController.text == _sentOtp) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Success"),
          content: const Text("You can now reset your password."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Back to login
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect OTP!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Forgot Password"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _otpPhase
                ? _buildOtpCard()
                : _buildRecoveryCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildRecoveryCard() {
    return Card(
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          key: const ValueKey('recovery'),
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Recover Account",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone),
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _sendOtp,
                icon: const Icon(Icons.send),
                label: const Text("Send OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpCard() {
    return Card(
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          key: const ValueKey('otp'),
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Verify OTP",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                labelText: "Enter OTP",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _verifyOtp,
                icon: const Icon(Icons.verified),
                label: const Text("Verify OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
