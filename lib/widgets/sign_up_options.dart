import 'package:flutter/material.dart';

class SignUpOptions extends StatelessWidget {
  const SignUpOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'How do you want to sign up?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.phone_android),
            title: const Text('Sign up with phone number'),
            onTap: () {
              // TODO: Implement sign up with phone number
              Navigator.pop(context);
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign up with phone number (not implemented)')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Sign up with email'),
            onTap: () {
              // TODO: Implement sign up with email
              Navigator.pop(context);
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign up with email (not implemented)')),
              );
            },
          ),
        ],
      ),
    );
  }
}
