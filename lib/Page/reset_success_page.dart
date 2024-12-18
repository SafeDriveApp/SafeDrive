import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter your new password.'),
            // Tambahkan TextField dan elemen lain yang dibutuhkan
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tampilkan pop-up setelah menekan tombol reset
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Success'),
                      content: const Text('Your password has been reset successfully!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Tutup dialog dan navigasi kembali ke halaman login atau home
                            Navigator.of(context).pop();
                            Navigator.of(context).pop(); // Close reset page
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
