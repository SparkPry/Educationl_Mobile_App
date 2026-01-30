import 'package:education_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:education_app/models/message_model.dart';

class MessageBubbleWidget extends StatelessWidget {
  final Message message;

  const MessageBubbleWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSentByMe = message.type == MessageType.sent;
    final Color bubbleColor =
        isSentByMe ? AppColors.primaryColor : Colors.grey.shade200;
    final Color textColor = isSentByMe ? Colors.white : Colors.black87;
    final BorderRadius borderRadius = BorderRadius.circular(12);

    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment:
              isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isSentByMe && message.senderAvatarText != null) ...[
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primaryColor.withAlpha((255 * 0.1).round()),
                    child: Text(
                      message.senderAvatarText!,
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: isSentByMe
                        ? borderRadius.copyWith(bottomRight: Radius.zero)
                        : borderRadius.copyWith(bottomLeft: Radius.zero),
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(color: textColor, fontSize: 15),
                  ),
                ),
                if (isSentByMe) const SizedBox(width: 8), // Add space for sender bubbles
              ],
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
