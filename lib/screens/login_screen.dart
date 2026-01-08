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

  void _handleAuthAction() {
    if (isSignIn) {
      if (_emailController.text == 'test@test.com' &&
          _passwordController.text == 'password') {
        Navigator.pushNamed(context, '/home');
      } else {
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
      }
    } else {
      // This is the case where the user is already on the Sign Up tab
      // and clicks the "Sign Up" button. We can show a simple success message
      // for now, as the actual sign up logic is not implemented.
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
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
    );
  }
}
