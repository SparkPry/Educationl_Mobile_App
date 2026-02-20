import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:education_app/models/chat_model.dart';
import 'package:education_app/screens/message_conversation_screen.dart';
import 'package:education_app/widgets/chat_item_widget.dart';
import 'package:education_app/screens/home_screen.dart';
import 'package:education_app/screens/my_courses_screen.dart';
import 'package:education_app/screens/profile_screen.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> with TickerProviderStateMixin {
  // Dummy chat data
  final List<Chat> _allChats = [
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
    ),
    const Chat(
      senderName: 'Alice',
      lastMessage: 'Sure, I will send the files.',
      time: 'Yesterday',
      avatarText: 'AL',
      avatarUrl: 'assets/images/Alice.jpg',
      isUnread: false,
    ),
    const Chat(
      senderName: 'Bob',
      lastMessage: 'Thank you for your feedback.',
      time: 'Mon',
      avatarText: 'BO',
      avatarUrl: 'assets/images/Bob.jpg',
      isUnread: true,
    ),
    const Chat(
      senderName: 'Charlie',
      lastMessage: 'Meeting rescheduled to 3 PM.',
      time: 'Sun',
      avatarText: 'CH',
      avatarUrl: 'assets/images/Charlie.jpg',
      isUnread: false,
    ),
    const Chat(
      senderName: 'Diana',
      lastMessage: 'Your application has been approved.',
      time: '23/01',
      avatarText: 'DI',
      avatarUrl: 'assets/images/Diana.jpg',
      isUnread: true,
    ),
  ];

  late TabController _tabController;
  List<Chat> _filteredChats = [];
  final TextEditingController _searchController = TextEditingController();
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _filteredChats = _allChats;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      _selectedTabIndex = _tabController.index;
      _applyFilters();
    });
  }

  void _applyFilters() {
    String searchQuery = _searchController.text.toLowerCase();

    List<Chat> filtered = _allChats;

    // Apply tab filter
    if (_selectedTabIndex == 1) {
      filtered = filtered.where((chat) => chat.isUnread).toList();
    } else if (_selectedTabIndex == 2) {
      filtered = filtered.where((chat) => !chat.isUnread).toList();
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((chat) =>
              chat.senderName.toLowerCase().contains(searchQuery) ||
              chat.lastMessage.toLowerCase().contains(searchQuery))
          .toList();
    }

    setState(() {
      _filteredChats = filtered;
    });
  }

  int get _unreadCount => _allChats.where((chat) => chat.isUnread).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTabBar(),
          Expanded(
            child: _buildChatList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Start new chat feature coming soon!'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: const Icon(Icons.message, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Messages',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          if (_unreadCount > 0)
            Text(
              '$_unreadCount unread message${_unreadCount > 1 ? 's' : ''}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      backgroundColor: const Color(0xFFF6F6F6),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call, color: Colors.black),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Call feature coming soon!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.video_call, color: Colors.black),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Video call feature coming soon!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (_) => _applyFilters(),
          decoration: InputDecoration(
            hintText: 'Search messages...',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey.shade400),
                    onPressed: () {
                      _searchController.clear();
                      _applyFilters();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primaryColor,
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        tabs: [
          Tab(
            text: 'All (${_allChats.length})',
          ),
          Tab(
            text: 'Unread ($_unreadCount)',
          ),
          Tab(
            text: 'Read (${_allChats.where((c) => !c.isUnread).length})',
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    if (_filteredChats.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchController.text.isEmpty
                  ? Icons.mail_outline
                  : Icons.search_off,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'No messages yet'
                  : 'No messages found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _searchController.text.isEmpty
                  ? 'Start a conversation with a mentor or friend'
                  : 'Try a different search',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _filteredChats.length,
      itemBuilder: (context, index) {
        final chat = _filteredChats[index];
        return ChatItemWidget(
          chat: chat,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MessageConversationScreen(
                  chatUser: chat.senderName,
                  avatarText: chat.avatarText,
                  avatarUrl: chat.avatarUrl,
                ),
              ),
            );
          },
        );
      },
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(height: 1, color: Colors.grey.shade200),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 2,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 8,
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
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const MyCoursesScreen(),
              ),
            );
            break;
          case 2:
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
            break;
        }
      },
    );
  }
}
