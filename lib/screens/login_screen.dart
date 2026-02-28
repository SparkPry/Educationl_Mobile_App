import 'package:education_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool _passwordError = false; // New state for password error
  bool _emailError = false;
  bool _usernameError = false;
  bool _showPassword = false; // New state for password visibility
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
        await _performLogin();
      } else {
        final response = await _apiService.register(
          _usernameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        if (response.statusCode == 409) {
          // Email exists? Just log them in instead to fulfill "unlimited" feel
          await _performLogin();
        } else if (response.statusCode >= 200 && response.statusCode < 300) {
          await _processAuthResponse(response);
        } else {
          _handleResponseError(response);
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Something went wrong: $e";
        _passwordError = true;
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _performLogin() async {
    final response = await _apiService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      await _processAuthResponse(response);
    } else {
      _handleResponseError(response);
    }
  }

  Future<void> _processAuthResponse(http.Response response) async {
    final data = jsonDecode(response.body);
    if (data != null && data['token'] != null) {
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      try {
        final profileResponse = await _apiService.getProfile(token);
        if (profileResponse.statusCode == 200) {
          final profileData = jsonDecode(profileResponse.body);
          final role = profileData['role'];
          await prefs.setString('role', role);
        }
      } catch (e) {
        debugPrint("Could not fetch profile: $e");
      }
    }

    await Provider.of<UserProvider>(context, listen: false)
        .updateEmail(_emailController.text.trim());

    if (mounted) {
      if (isSignIn) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Success! Please fill your profile.")),
        );
        Navigator.pushReplacementNamed(context, '/nickname');
      }
    }
  }

  void _handleResponseError(http.Response response) {
    String errorMessage = "An unexpected error occurred. Please try again.";
    bool isEmailError = false;
    bool isPasswordError = false;
    bool isUsernameError = false;

    dynamic data;
    try {
      data = jsonDecode(response.body);
    } catch (_) {}

    if (response.statusCode == 429) {
      errorMessage =
          "Limit reached: 10 sign-ups/ins per 15 mins. Please wait 15 minutes.";
      isEmailError = true;
      isPasswordError = true;
    } else if (data is Map && data.containsKey('message') == true) {
      errorMessage = data['message'] ?? errorMessage;
    } else if (response.statusCode == 401) {
      errorMessage = (data is Map ? data['message'] : null) ?? "Invalid input data.";
    } else {
      // Handle other non-2xx responses with a generic server message
      errorMessage = "Server error (${response.statusCode}). Please try again later.";
    }

    // Smart mapping based on keywords if not already assigned
    final lowerMsg = errorMessage.toLowerCase();
    if (lowerMsg.contains("email")) isEmailError = true;
    if (lowerMsg.contains("password") || lowerMsg.contains("credential") || lowerMsg.contains("unauthorized")) isPasswordError = true;
    if (lowerMsg.contains("username") || lowerMsg.contains("name")) isUsernameError = true;

    // Fallback: if nothing is matched, show it on the password field
    if (!isEmailError && !isPasswordError && !isUsernameError) {
      isPasswordError = true;
    }

    setState(() {
      _errorMessage = errorMessage;
      _emailError = isEmailError;
      _emailErrorMessage = isEmailError ? errorMessage : null;
      _passwordError = isPasswordError;
      _passwordErrorMessage = isPasswordError ? errorMessage : null;
      _usernameError = isUsernameError;
      _usernameErrorMessage = isUsernameError ? errorMessage : null;
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
        child: SingleChildScrollView(
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
                Text(
                  isSignIn ? "We are happy to see you here" : "Create an account to get started",
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),
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
                  hasError: _passwordError, // Pass the error state
                  errorText: _passwordErrorMessage ??
                      _errorMessage, // Pass the error message
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
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            isSignIn ? "Sign In" : "Sign Up",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
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
            obscureText: pass ? !_showPassword : false,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: Icon(icon, color: Colors.grey),
              suffixIcon: pass
                  ? IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    )
                  : null,
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
