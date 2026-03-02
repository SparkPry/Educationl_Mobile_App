class ApiCourse {
  final int id;
  final String slug;
  final String title;
  final String description;
  final String longDescription;
  final double price;
  final double? discountPrice;
  final String level;
  final String category;
  final String thumbnail;
  final String duration;

  ApiCourse({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.longDescription,
    required this.price,
    this.discountPrice,
    required this.level,
    required this.category,
    required this.thumbnail,
    required this.duration,
  });

  factory ApiCourse.fromJson(Map<String, dynamic> json) {
    return ApiCourse(
      id: json['id'],
      slug: json['slug'],
      title: json['title'],
      description: json['description'],
      longDescription: json['long_description'],
      price: double.parse(json['price']),
      discountPrice: json['discount_price'] != null
          ? double.parse(json['discount_price'])
          : null,
      level: json['level'],
      category: json['category'],
      thumbnail: json['thumbnail'],
      duration: json['duration'],
    );
  }
}
