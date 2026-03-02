import 'package:flutter/material.dart';

// Color Scheme
const Color kPrimaryColor = Color(0xFF5B5CF6);
const Color kBackgroundColor = Color(0xFFF5F5F5);
const Color kPrimaryTextColor = Color(0xFF424242);
const Color kSecondaryTextColor = Color(0xFF9E9E9E);
const Color kCardBackgroundColor = Colors.white;

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimaryTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: kPrimaryTextColor, size: 28),
            onPressed: () {
              // Navigate to profile or show profile options
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              _buildHeroSection(),
              const SizedBox(height: 24),
              _buildSearchBar(),
              const SizedBox(height: 32),
              _buildSectionHeader('Top Articles'),
              const SizedBox(height: 16),
              _buildArticleCard(
                'Getting Started',
                'Learn the basics and set up your account in a few simple steps.',
              ),
              const SizedBox(height: 12),
              _buildArticleCard(
                'How to Manage Your Profile',
                'Find out how to update your personal information and preferences.',
              ),
              const SizedBox(height: 32),
              _buildSectionHeader('Latest Discussions'),
              const SizedBox(height: 16),
              _buildDiscussionsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kPrimaryColor.withOpacity(0.1),
          ),
          child: const Icon(
            Icons.support_agent,
            color: kPrimaryColor,
            size: 60,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'How can we help you today?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kPrimaryTextColor,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Find articles, discussions, and answers from our support team.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kSecondaryTextColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search for articles or discussions',
          hintStyle: TextStyle(color: kSecondaryTextColor),
          prefixIcon: Icon(Icons.search, color: kSecondaryTextColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: kPrimaryTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 3,
          width: 40,
          color: kPrimaryColor,
        ),
      ],
    );
  }

  Widget _buildArticleCard(String title, String preview) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kCardBackgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: kPrimaryTextColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              preview,
              style: const TextStyle(
                color: kSecondaryTextColor,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscussionsList() {
    return Container(
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          _buildDiscussionItem(Icons.question_answer_outlined, 'Account Access Issues', 'Account'),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildDiscussionItem(Icons.payment, 'Payment Failed', 'Billing'),
          const Divider(height: 1, indent: 20, endIndent: 20),
          _buildDiscussionItem(Icons.school_outlined, 'Course Content Not Loading', 'Courses'),
        ],
      ),
    );
  }

  Widget _buildDiscussionItem(IconData icon, String title, String category) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: CircleAvatar(
        backgroundColor: kPrimaryColor.withOpacity(0.1),
        child: Icon(icon, color: kPrimaryColor),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: kPrimaryTextColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        category,
        style: const TextStyle(color: kSecondaryTextColor, fontSize: 13),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: kSecondaryTextColor, size: 16),
      onTap: () {},
    );
  }
}
