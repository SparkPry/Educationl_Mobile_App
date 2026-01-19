import 'package:education_app/widgets/sign_up_prompt.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignIn = true; // Default to Sign In
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordError = false; // New state for password error

  // Mock user data
  final List<Map<String, String>> _users = [
    {'email': 'test@test.com', 'password': 'password'},
    {'email': 'user@example.com', 'password': 'password123'},
  ];

  void _handleAuthAction() {
    if (isSignIn) {
      final email = _emailController.text;
      final password = _passwordController.text;

      // Reset password error before new validation
      setState(() {
        _passwordError = false;
      });

      // Find user by email
      final user = _users.firstWhere(
        (user) => user['email'] == email,
        orElse: () => <String, String>{},
      );

      if (user.isEmpty) {
        // User not found, show sign up prompt
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return SignUpPrompt(
              onSignUp: () {
                Navigator.pop(context);
                setState(() {
                  isSignIn = false;
                });
              },
            );
          },
        );
      } else if (user['password'] != password) {
        // User found, but password incorrect
        setState(() {
          _passwordError = true;
        });
      } else {
        // User found and password correct
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      // This is the case where the user is already on the Sign Up tab
      // and clicks the "Sign Up" button.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign Up button pressed (not implemented)'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(child: _toggleBtn("Sign In", isSignIn)),
                    Expanded(child: _toggleBtn("Sign Up", !isSignIn)),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                "Hello there,",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                "We are happy to see you here",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              if (!isSignIn)
                _inputField(
                  "Username",
                  Icons.person_outline,
                  controller: _usernameController,
                ),
              _inputField(
                "Example@gmail.com",
                Icons.email_outlined,
                controller: _emailController,
              ),
              _inputField(
                "Password",
                Icons.lock_outline,
                pass: true,
                controller: _passwordController,
                hasError: _passwordError, // Pass the error state
                errorText:
                    'Incorrect password!, Try again.', // Pass the error message
              ),
              if (isSignIn)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forgot_password');
                    },
                    child: const Text(
                      "Forgot password",
                      style: TextStyle(color: Color(0xFF6B66FF)),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleAuthAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B66FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    isSignIn ? "Sign In" : "Sign Up",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleBtn(String label, bool active) {
    return GestureDetector(
      onTap: () => setState(() {
        isSignIn = label == "Sign In";
      }),
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String hint,
    IconData icon, {
    bool pass = false,
    TextEditingController? controller,
    bool hasError = false, // New parameter
    String? errorText, // New parameter
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 5), // Adjusted margin
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: hasError
                  ? Colors.red
                  : Colors.transparent, // Red border if hasError
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha((255 * 0.1).round()),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: pass,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 20,
              ),
            ),
          ),
        ),
        if (hasError && errorText != null) // Display error text
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 20.0),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        if (!hasError) // Add SizedBox only if no error to maintain spacing
          const SizedBox(height: 20),
      ],
    );
  }
}
