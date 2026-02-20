import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:education_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _passwordError = false;
  bool _emailError = false;
  bool _usernameError = false;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;
  String? _emailErrorMessage;
  String? _passwordErrorMessage;
  String? _usernameErrorMessage;

  Future<void> _handleAuthAction() async {
    // Reset all validation states
    setState(() {
      _passwordError = false;
      _emailError = false;
      _usernameError = false;
      _errorMessage = null;
      _emailErrorMessage = null;
      _passwordErrorMessage = null;
      _usernameErrorMessage = null;
    });

    // Validate inputs
    bool isValid = true;

    if (isSignIn) {
      // Sign In Validation
      if (_emailController.text.trim().isEmpty) {
        setState(() {
          _emailError = true;
          _emailErrorMessage = "Email is required";
        });
        isValid = false;
      } else if (!_isValidEmail(_emailController.text.trim())) {
        setState(() {
          _emailError = true;
          _emailErrorMessage = "Please enter a valid email";
        });
        isValid = false;
      }

      if (_passwordController.text.trim().isEmpty) {
        setState(() {
          _passwordError = true;
          _passwordErrorMessage = "Password is required";
        });
        isValid = false;
      } else if (_passwordController.text.trim().length < 6) {
        setState(() {
          _passwordError = true;
          _passwordErrorMessage = "Password must be at least 6 characters";
        });
        isValid = false;
      }
    } else {
      // Sign Up Validation
      if (_usernameController.text.trim().isEmpty) {
        setState(() {
          _usernameError = true;
          _usernameErrorMessage = "Username is required";
        });
        isValid = false;
      } else if (_usernameController.text.trim().length < 3) {
        setState(() {
          _usernameError = true;
          _usernameErrorMessage = "Username must be at least 3 characters";
        });
        isValid = false;
      }

      if (_emailController.text.trim().isEmpty) {
        setState(() {
          _emailError = true;
          _emailErrorMessage = "Email is required";
        });
        isValid = false;
      } else if (!_isValidEmail(_emailController.text.trim())) {
        setState(() {
          _emailError = true;
          _emailErrorMessage = "Please enter a valid email";
        });
        isValid = false;
      }

      if (_passwordController.text.trim().isEmpty) {
        setState(() {
          _passwordError = true;
          _passwordErrorMessage = "Password is required";
        });
        isValid = false;
      } else if (_passwordController.text.trim().length < 6) {
        setState(() {
          _passwordError = true;
          _passwordErrorMessage = "Password must be at least 6 characters";
        });
        isValid = false;
      }
    }

    // If validation failed, don't proceed
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (isSignIn) {
        final response = await _apiService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        final token = response.data['token'];

        // Save token first
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // 🔥 NOW call profile API to get user data
        final profileResponse = await _apiService.getProfile(token);

        final role = profileResponse.data['role'];

        await prefs.setString('role', role);

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        await _apiService.register(
          _usernameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        setState(() {
          isSignIn = true;
          _usernameController.clear();
          _emailController.clear();
          _passwordController.clear();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration successful. Please log in.")),
          );
        }
      }
    } on DioException catch (e) {
      String errorMessage = "Authentication failed";
      
      // Parse API error response
      if (e.response?.data is Map && e.response?.data.containsKey('message') == true) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
      } else if (e.response?.statusCode == 401) {
        errorMessage = "Invalid email or password";
      } else if (e.response?.statusCode == 409) {
        errorMessage = "Email already exists";
      } else if (e.response?.statusCode == 400) {
        errorMessage = "Invalid input. Please check your information.";
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = "Connection timeout. Please check your internet.";
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Server timeout. Please try again.";
      }

      setState(() {
        _errorMessage = errorMessage;
        if (isSignIn) {
          _passwordError = true;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Something went wrong: $e";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
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
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _handleAuthAction,
                          icon: const Icon(Icons.refresh, size: 16),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            disabledBackgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.white,
                            disabledForegroundColor: Colors.grey.shade600,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              if (!isSignIn)
                _inputField(
                  "Username",
                  Icons.person_outline,
                  controller: _usernameController,
                  hasError: _usernameError,
                  errorText: _usernameErrorMessage,
                ),
              _inputField(
                "Example@gmail.com",
                Icons.email_outlined,
                controller: _emailController,
                hasError: _emailError,
                errorText: _emailErrorMessage,
              ),
              _inputField(
                "Password",
                Icons.lock_outline,
                pass: true,
                controller: _passwordController,
                hasError: _passwordError,
                errorText: _passwordErrorMessage,
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
                  onPressed: _isLoading ? null : _handleAuthAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B66FF),
                    disabledBackgroundColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          isSignIn ? "Sign In" : "Sign Up",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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
    bool hasError = false,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: hasError ? Colors.red : Colors.transparent,
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
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(icon, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 20,
              ),
            ),
          ),
        ),
        if (hasError && errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 20.0),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          )
        else
          const SizedBox(height: 20),
      ],
    );
  }
}
