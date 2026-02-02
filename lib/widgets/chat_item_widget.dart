import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:education_app/models/chat_model.dart';

class ChatItemWidget extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatItemWidget({super.key, required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            if (chat.avatarUrl != null)
              SizedBox(
                width: 56, // 2 * radius
                height: 56, // 2 * radius
                child: ClipOval(
                  child: Image.asset(
                    chat.avatarUrl!,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              )
            else
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryColor,
                child: Text(
                  chat.avatarText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.senderName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.time,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                if (chat.isUnread) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
