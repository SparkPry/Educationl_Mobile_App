import 'dart:io';
import 'package:education_app/screens/student_courses_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:education_app/models/user_model.dart';
import 'package:education_app/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:education_app/providers/user_provider.dart';
import 'package:education_app/screens/profile_screen.dart';

class StudentProfileScreen extends StatelessWidget {
  final UserModel student;

  const StudentProfileScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Use provider data if viewing current user, otherwise use passed student model
        final currentUser = userProvider.user;
        final bool isCurrentUser = student.email == currentUser.email;
        final displayUser = isCurrentUser ? currentUser : student;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Student Profile', style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            actions: isCurrentUser ? [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
            ] : null,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildProfileHeader(displayUser, isCurrentUser),
                const SizedBox(height: 24),
                _buildStatsSection(context, userProvider, displayUser, isCurrentUser),
                const SizedBox(height: 32),
                _buildBioSection(displayUser),
                const SizedBox(height: 32),
                _buildCertificatesSection(displayUser),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }

    Widget _buildProfileHeader(UserModel user, bool isCurrentUser) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: isCurrentUser
                        ? _buildAvatarImage(user.avatar)
                        : const Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              style: TextStyle(
                color: Colors.grey.shade600, 
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Follow'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primaryColor),
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('Message',
                          style: TextStyle(color: AppColors.primaryColor)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

  Widget _buildAvatarImage(String avatar) {
    if (avatar.startsWith('assets/')) {
      return Image.asset(
        avatar,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      );
    } else if (avatar.startsWith('http')) {
      return Image.network(
        avatar,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      );
    } else {
      return Image.file(
        File(avatar),
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/John Doe.jpg',
          fit: BoxFit.cover,
        ),
      );
    }
  }

  Widget _buildStatsSection(BuildContext context, UserProvider userProvider, UserModel user, bool isCurrentUser) {
    String courseCount = isCurrentUser 
        ? userProvider.totalCoursesCount.toString() 
        : (user.coursesCompleted?.toString() ?? '0');
    
    String hourCount = isCurrentUser 
        ? userProvider.totalEstimatedHours.toString() 
        : (user.learningHours?.toString() ?? '0');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard(
            'Courses',
            courseCount,
            Icons.menu_book,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentCoursesListScreen(
                    studentName: user.name,
                    courses: isCurrentUser 
                        ? userProvider.allEnrolledCourseNames 
                        : (user.enrolledCourseNames ?? []),
                  ),
                ),
              );
            },
          ),
          _buildStatCard(
              'Hours', hourCount, Icons.timer),
          _buildStatCard(
              'Joined', user.joinDate ?? 'Jan 2024', Icons.calendar_today),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildBioSection(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About Me', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            user.bio ?? "This student hasn't added a bio yet.",
            style: TextStyle(color: Colors.grey.shade700, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificatesSection(UserModel user) {
    final certificates = user.certificates ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Certificates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: Text('View All', style: TextStyle(color: AppColors.primaryColor))),
            ],
          ),
          const SizedBox(height: 12),
          if (certificates.isEmpty)
            const Text('No certificates earned yet.', style: TextStyle(color: Colors.grey))
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: certificates.length > 3 ? 3 : certificates.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final cert = certificates[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.workspace_premium, color: Colors.orange),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cert.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(cert.organization, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(cert.date, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
