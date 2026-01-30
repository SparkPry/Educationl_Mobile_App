import 'package:flutter/material.dart';

// Color Scheme
const Color kPrimaryColor = Color(0xFF5B5CF6);
const Color kBackgroundColor = Color(0xFFF5F5F5);
const Color kPrimaryTextColor = Color(0xFF424242);
const Color kSecondaryTextColor = Color(0xFF9E9E9E);
const Color kCardBackgroundColor = Colors.white;

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  // Placeholder text for the content sections
  final String _loremIpsum =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Terms & Privacy',
          style: TextStyle(
            color: kPrimaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: kCardBackgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildSection('1. Terms of Use', _loremIpsum),
                const SizedBox(height: 16),
                _buildSection('2. User Responsibilities',
                    '$_loremIpsum $_loremIpsum'),
                const SizedBox(height: 16),
                const Divider(color: kBackgroundColor),
                const SizedBox(height: 16),
                _buildSection('3. Privacy Policy', _loremIpsum),
                const SizedBox(height: 16),
                _buildSection(
                    '4. Data Collection', '$_loremIpsum $_loremIpsum'),
                const SizedBox(height: 16),
                const Divider(color: kBackgroundColor),
                const SizedBox(height: 16),
                _buildSection('5. Changes to This Policy', _loremIpsum),
                const SizedBox(height: 32),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          'Terms of Use & Privacy Policy',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kPrimaryTextColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Please read carefully before continuing',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kSecondaryTextColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: kPrimaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600, // Semi-bold
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            color: kSecondaryTextColor,
            fontSize: 15,
            height: 1.5, // Comfortable line height
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return const Text(
      'Last updated: January 2026',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: kSecondaryTextColor,
        fontSize: 12,
      ),
    );
  }
}
