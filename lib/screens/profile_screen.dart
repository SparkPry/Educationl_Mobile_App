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
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text(
                              "Sign Out",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: const Text("Are you sure you want to sign out?"),
                            actions: [
                              TextButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: Text(
                                  "Sign Out",
                                  style: TextStyle(
                                    color: Colors.red.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context); // Close dialog
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                            ],
                          );
                        },
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

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24),
        ClipOval(
          child: SizedBox(
            width: 80,
            height: 80,
            child: Image.asset(
              'assets/images/John Doe.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'John Doe',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'johndoe@example.com',
          style: TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
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
