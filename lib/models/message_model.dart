enum MessageType { sent, received }

class Message {
  final String text;
  final String time;
  final MessageType type;
  final String? senderAvatarText; // Only for received messages

  const Message({
    required this.text,
    required this.time,
    required this.type,
    this.senderAvatarText,
  });
}
