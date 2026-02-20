import 'package:flutter/material.dart';

// Color Scheme
const Color kPrimaryColor = Color(0xFF5B5CF6);
const Color kBackgroundColor = Color(0xFFF5F5F5);
const Color kPrimaryTextColor = Color(0xFF9E9E9E);
const Color kSecondaryTextColor = Color(0xFF424242);
const Color kCardBackgroundColor = Colors.white;
final Color kDangerColor = Colors.red.shade700;

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _isTwoFactorEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kSecondaryTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Security',
          style: TextStyle(
            color: kSecondaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSectionCard(
                title: 'Password',
                children: [
                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    label: 'Change Password',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Two-Factor Authentication',
                children: [
                  _buildMenuItem(
                    icon: Icons.shield_outlined,
                    label: 'Enable 2FA',
                    trailing: Switch(
                      value: _isTwoFactorEnabled,
                      onChanged: (value) {
                        setState(() {
                          _isTwoFactorEnabled = value;
                        });
                      },
                      activeThumbColor: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Login Activity',
                children: [
                  _buildMenuItem(
                    icon: Icons.history,
                    label: 'Recent Login Activity',
                    subtext: 'View devices and locations',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                children: [
                  _buildMenuItem(
                    icon: Icons.warning_amber_rounded,
                    label: 'Sign out from all devices',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSectionCard(
                title: 'Danger Zone',
                children: [
                  _buildMenuItem(
                    icon: Icons.delete_outline,
                    label: 'Deactivate Account',
                    labelColor: kDangerColor,
                    iconColor: kDangerColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({String? title, required List<Widget> children}) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                title,
                style: const TextStyle(
                  color: kSecondaryTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    String? subtext,
    Widget? trailing,
    Color? labelColor,
    Color? iconColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Icon(icon, color: iconColor ?? kSecondaryTextColor),
      title: Text(
        label,
        style: TextStyle(
          color: labelColor ?? kSecondaryTextColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtext != null
          ? Text(
              subtext,
              style: const TextStyle(color: kPrimaryTextColor, fontSize: 14),
            )
          : null,
      trailing:
          trailing ??
          const Icon(
            Icons.arrow_forward_ios,
            color: kPrimaryTextColor,
            size: 16,
          ),
      onTap: () {
        // Handle tap
      },
    );
  }
}
