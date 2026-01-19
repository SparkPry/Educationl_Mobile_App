import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Dark background for the overall screen
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((255 * 0.1).round()),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              // Custom AppBar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Notification',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Placeholder to balance the row since back button takes space
                    const SizedBox(width: 48), 
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Today Section
                        _buildSectionHeader(
                          context, 
                          'Today', 
                          () { /* Handle 'Make all as read' for Today */ },
                        ),
                        _buildNotificationList(), // Placeholder for Today's notifications
                        const SizedBox(height: 20),

                        // Yesterday Section
                        _buildSectionHeader(
                          context, 
                          'Yesterday', 
                          () { /* Handle 'Make all as read' for Yesterday */ },
                        ),
                        _buildNotificationList(), // Placeholder for Yesterday's notifications
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onReadTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: onReadTap,
            child: const Text(
              'Make all as read',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationList() {
    return Column(
      children: const [
        NotificationListItem(
          title: 'New Course Added',
          description: 'A new Flutter course "Advanced UI with Flutter" has been added.',
        ),
        NotificationListItem(
          title: 'Quiz Reminder',
          description: 'Don\'t forget to complete your "Dart Basics" quiz by 5 PM.',
        ),
        NotificationListItem(
          title: 'Live Session Starting',
          description: 'Your live coding session with John Doe is starting in 10 minutes. Join now!',
        ),
      ],
    );
  }
}

class NotificationListItem extends StatelessWidget {
  final String title;
  final String description;

  const NotificationListItem({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.lightBlue[100], // Soft light blue
                radius: 20,
                child: const Icon(Icons.notifications, color: Colors.blue),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey[300],
          height: 1,
          thickness: 1,
          indent: 55, // Align divider with text content
          endIndent: 0,
        ),
      ],
    );
  }
}
