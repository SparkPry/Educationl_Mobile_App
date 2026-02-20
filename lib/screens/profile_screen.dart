import 'package:education_app/screens/edit_profile_screen.dart';
import 'package:education_app/screens/payment_method_screen.dart';
import 'package:education_app/screens/security_screen.dart';
import 'package:education_app/screens/privacy_policy_screen.dart';
import 'package:education_app/screens/help_center_screen.dart';
import 'package:education_app/screens/invite_friends_screen.dart';
import 'package:education_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:education_app/screens/home_screen.dart';
import 'package:education_app/utils/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            const ProfileHeader(),
            const ProfileSection(),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  ProfileMenuItem(
                    icon: Icons.edit,
                    text: 'Edit Profile',
                    iconColor: AppColors.primaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.favorite_border,
                    text: 'My Favorite',
                    iconColor: AppColors.primaryColor,
                  ),
                  ProfileMenuItem(
                    icon: Icons.credit_card,
                    text: 'Payment Method',
                    iconColor: AppColors.primaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentMethodScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.shield_outlined,
                    text: 'Security',
                    iconColor: AppColors.primaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SecurityScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.privacy_tip_outlined,
                    text: 'Privacy policy',
                    iconColor: AppColors.primaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.help_outline,
                    text: 'Help Center',
                    iconColor: AppColors.primaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpCenterScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.person_add_alt,
                    text: 'Invite friends',
                    iconColor: AppColors.primaryColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InviteFriendsScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    text: 'Sign out',
                    textColor: Colors.red,
                    iconColor: AppColors.primaryColor,
                    onTap: () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Sign out"),
                          content: const Text(
                            "Are you sure you want to sign out?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                "Sign out",
                                style: TextStyle(
                                  color: Colors.red, // 🔥 RED COLOR
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) return;

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();

                      if (!context.mounted) return;

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                  ),

                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: const Color(0xFFF7F7F7),
      child: Row(
        children: [
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF222222)),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false,
              );
            },
          ),
          const Spacer(),
          const Text(
            'My Profile',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF222222),
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class ProfileSection extends StatefulWidget {
  const ProfileSection({super.key});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://e-learning-api-production-a6d4.up.railway.app',
    ),
  );

  String _name = '';
  String _email = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) return;

      final response = await _dio.get(
        '/api/auth/profile',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (!mounted) return;

      setState(() {
        _name = response.data['name'] ?? '';
        _email = response.data['email'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return '';

    final parts = name.trim().split(' ');

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 24),

        /// 🔥 Avatar with Initials
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primaryColor,
          child: Text(
            _getInitials(_name),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// 🔥 Name from API
        Text(
          _name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
          ),
        ),

        const SizedBox(height: 4),

        /// 🔥 Email from API
        Text(
          _email,
          style: const TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
        ),
      ],
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? textColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    this.textColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? AppColors.primaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      color: textColor ?? const Color(0xFF222222),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: Color(0xFFC7C7CC)),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E5EA), indent: 68),
        ],
      ),
    );
  }
}
