class Badge {
  final String name;
  final String description;
  final String iconUrl;
  final bool isEarned;

  Badge({
    required this.name,
    required this.description,
    required this.iconUrl,
    this.isEarned = false,
  });
}
