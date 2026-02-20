import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard

// Color Scheme
const Color kPrimaryColor = Color(0xFF5B5CF6);
const Color kBackgroundColor = Color(0xFFF5F5F5);
const Color kPrimaryTextColor = Color(0xFF424242);
const Color kSecondaryTextColor = Color(0xFF9E9E9E);
const Color kCardBackgroundColor = Colors.white;

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({super.key});

  final String _inviteLink = 'https://example.com/invite/YOUR_INVITE_CODE_HERE';

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
          'Invite Friends',
          style: TextStyle(
            color: kPrimaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeroIllustration(),
              const SizedBox(height: 32),
              _buildHeadline(),
              const SizedBox(height: 12),
              _buildDescription(),
              const SizedBox(height: 40),
              _buildShareLinkSection(context),
              const SizedBox(height: 40),
              _buildSharePlatformSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroIllustration() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kPrimaryColor.withOpacity(0.1),
      ),
      child: const Icon(
        Icons.group_add,
        color: kPrimaryColor,
        size: 80,
      ),
    );
  }

  Widget _buildHeadline() {
    return const Text(
      'Invite your friends to join!',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: kPrimaryTextColor,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDescription() {
    return const Text(
      'Share your unique invitation link and earn rewards when your friends sign up.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: kSecondaryTextColor,
        fontSize: 16,
        height: 1.5,
      ),
    );
  }

  Widget _buildShareLinkSection(BuildContext context) {
    final TextEditingController linkController = TextEditingController(text: _inviteLink);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Invitation Link',
          style: TextStyle(
            color: kPrimaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: kCardBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: linkController,
                  readOnly: true,
                  style: const TextStyle(
                    color: kPrimaryTextColor,
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _inviteLink));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link copied to clipboard!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text('Copy Link'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSharePlatformSection(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Share to other platforms',
          style: TextStyle(
            color: kPrimaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(context, Icons.chat, 'WhatsApp'),
            _buildSocialIcon(context, Icons.facebook, 'Facebook'),
            _buildSocialIcon(context, Icons.link, 'Twitter'), // Using link icon as placeholder
            _buildSocialIcon(context, Icons.mail_outline, 'Email'),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(BuildContext context, IconData icon, String platform) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: kPrimaryColor.withOpacity(0.1),
            child: IconButton(
              icon: Icon(icon, color: kPrimaryColor, size: 28),
              onPressed: () {
                // In a real app, you would use a sharing package like 'share_plus'
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Sharing to $platform is not fully implemented yet.')),
                );
              },
            ),
          ),
          const SizedBox(height: 5),
          Text(
            platform,
            style: const TextStyle(color: kSecondaryTextColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
