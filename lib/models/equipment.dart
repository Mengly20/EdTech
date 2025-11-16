class Equipment {
  final String className;
  final String nameEnglish;
  final String nameKhmer;
  final String category;
  final String categoryKhmer;
  final String usage;
  final String icon;
  final List<String> tags;

  Equipment({
    required this.className,
    required this.nameEnglish,
    required this.nameKhmer,
    required this.category,
    required this.categoryKhmer,
    required this.usage,
    required this.icon,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'class': className,
      'nameEnglish': nameEnglish,
      'nameKhmer': nameKhmer,
      'category': category,
      'categoryKhmer': categoryKhmer,
      'usage': usage,
      'icon': icon,
      'tags': tags,
    };
  }

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      className: json['class'] ?? '',
      nameEnglish: json['nameEnglish'] ?? '',
      nameKhmer: json['nameKhmer'] ?? '',
      category: json['category'] ?? '',
      categoryKhmer: json['categoryKhmer'] ?? '',
      usage: json['usage'] ?? '',
      icon: json['icon'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
