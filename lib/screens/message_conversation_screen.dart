import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:education_app/models/message_model.dart';
import 'package:education_app/widgets/message_bubble_widget.dart';
import 'package:education_app/models/user_model.dart';
import 'package:education_app/screens/student_profile_screen.dart';
import 'package:education_app/screens/mentor_profile_screen.dart';
import 'package:education_app/models/mentor_model.dart';
import 'package:education_app/data/mentor_list_data.dart'; // Import mentor_list_data.dart

class MessageConversationScreen extends StatefulWidget {
  final UserModel chatUser;
  final bool isMentor;

  const MessageConversationScreen({
    super.key,
    required this.chatUser,
    this.isMentor = false,
  });

  @override
  State<MessageConversationScreen> createState() =>
      _MessageConversationScreenState();
}

class _MessageConversationScreenState extends State<MessageConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  late final List<Message> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      Message(
        text: 'Hi there! How are you doing today?',
        time: '10:00 AM',
        type: MessageType.received,
        senderAvatarText: widget.chatUser.name[0],
        senderAvatarUrl: widget.chatUser.avatar,
      ),
      Message(
        text: 'I\'m doing great, thanks for asking!',
        time: '10:01 AM',
        type: MessageType.sent,
      ),
      Message(
        text: 'I have a question about the Flutter course.',
        time: '10:02 AM',
        type: MessageType.sent,
      ),
      Message(
        text: 'Sure, I\'d be happy to help! What is your question?',
        time: '10:05 AM',
        type: MessageType.received,
        senderAvatarText: widget.chatUser.name[0],
        senderAvatarUrl: widget.chatUser.avatar,
      ),
    ];
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(
          Message(
            text: _messageController.text,
            time: 'Just now', // Simplified for dummy data
            type: MessageType.sent,
          ),
        );
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          widget.chatUser.name,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                if (widget.isMentor) {
                  final mentor = allMentors.firstWhere(
                    (m) => m.name == widget.chatUser.name,
                    orElse: () => Mentor(
                      name: widget.chatUser.name,
                      profileImage: widget.chatUser.avatar,
                      title: "Mentor",
                      about: widget.chatUser.bio ?? "No bio available.",
                      courses: [],
                      students: "0",
                      rating: "0.0",
                      reviewsCount: "0",
                      reviews: [],
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MentorProfileScreen(mentor: mentor),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          StudentProfileScreen(student: widget.chatUser),
                    ),
                  );
                }
              },
              child: widget.isMentor && widget.chatUser.avatar.isNotEmpty
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(widget.chatUser.avatar),
                    )
                  : const Icon(Icons.person),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Today',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageBubbleWidget(message: _messages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            color: const Color(0xFFF6F6F6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message here...',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.primaryColor,
                  elevation: 0,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
