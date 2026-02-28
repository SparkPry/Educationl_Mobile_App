import 'package:education_app/screens/find_friends_screen.dart';
import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:education_app/models/chat_model.dart';
import 'package:education_app/screens/message_conversation_screen.dart';
import 'package:education_app/widgets/chat_item_widget.dart';
import 'package:education_app/screens/home_screen.dart';
import 'package:education_app/screens/my_courses_screen.dart';
import 'package:education_app/screens/profile_screen.dart';
import 'package:education_app/screens/student_profile_screen.dart';
import 'package:education_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:education_app/models/user_model.dart'; // Add this import

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  // Dummy chat data
  final List<Chat> _chats = [
    const Chat(
      senderName: 'Student Service',
      lastMessage: 'Okay, see you then!',
      time: '10:30 AM',
      avatarText: 'SS',
      isUnread: true,
    ),
    const Chat(
      senderName: 'Eve',
      lastMessage: 'Hi there! How are you doing today?',
      time: '10:00 AM',
      avatarText: 'EV',
      avatarUrl: 'assets/images/Eve.jpg',
      isUnread: true,
      isMentor: true,
    ),

    const Chat(
      senderName: 'Alice',
      lastMessage: 'Sure, I will send the files.',
      time: 'Yesterday',
      avatarText: 'AL',
      avatarUrl: 'assets/images/Alice.jpg',
      isUnread: false,
      isMentor: true,
    ),
    const Chat(
      senderName: 'Bob',
      lastMessage: 'Thank you for your feedback.',
      time: 'Mon',
      avatarText: 'BO',
      avatarUrl: 'assets/images/Bob.jpg',
      isUnread: true,
      isMentor: true,
    ),
    const Chat(
      senderName: 'Charlie',
      lastMessage: 'Meeting rescheduled to 3 PM.',
      time: 'Sun',
      avatarText: 'CH',
      avatarUrl: 'assets/images/Charlie.jpg',
      isUnread: false,
      isMentor: true,
    ),
    const Chat(
      senderName: 'Diana',
      lastMessage: 'Your application has been approved.',
      time: '23/01',
      avatarText: 'DI',
      avatarUrl: 'assets/images/Diana.jpg',
      isUnread: true,
      isMentor: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FindFriendsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: ListView.separated(
        itemCount: _chats.length,
        itemBuilder: (context, index) {
          final chat = _chats[index];
          return ChatItemWidget(
            chat: chat,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageConversationScreen(
                    chatUser: UserModel(
                      name: chat.senderName,
                      email: '${chat.senderName.toLowerCase().replaceAll(' ', '')}@example.com', // Dummy email
                      avatar: chat.avatarUrl ?? '', // Use avatarUrl from chat, or empty string
                      // Other UserModel properties can be left as default or fetched if necessary
                    ),
                    isMentor: chat.isMentor,
                  ),
                ),
              );
            },
          );
        },
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(height: 1, color: Colors.grey.shade300),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Inbox tab
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0: // Home
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              break;
            case 1: // My Courses
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyCoursesScreen(),
                ),
              );
              break;
            case 2: // Inbox (current screen)
              // Do nothing, already on InboxScreen
              break;
            case 3: // Profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
              break;
          }
        },
      ),
    );
  }
}