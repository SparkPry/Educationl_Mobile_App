class Chat {
  final String senderName;
  final String lastMessage;
  final String time;
  final String avatarText; // Using initials for avatar
  final String? avatarUrl; // Using for avatar
  final bool isUnread;

  const Chat({
    required this.senderName,
    required this.lastMessage,
    required this.time,
    required this.avatarText,
    this.avatarUrl,
    this.isUnread = false,
  });
}
