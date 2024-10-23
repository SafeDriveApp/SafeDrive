import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Center(
        child: Text(
          'Forgot Password Page',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
