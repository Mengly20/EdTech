class ScanResult {
  final String nameKhmer;
  final String nameEnglish;
  final double confidence;
  final String category;
  final String categoryKhmer;
  final String usage;
  final String detectedClass;
  final List<String> tags;

  ScanResult({
    required this.nameKhmer,
    required this.nameEnglish,
    required this.confidence,
    required this.category,
    required this.categoryKhmer,
    required this.usage,
    required this.detectedClass,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'nameKhmer': nameKhmer,
      'nameEnglish': nameEnglish,
      'confidence': confidence,
      'category': category,
      'categoryKhmer': categoryKhmer,
      'usage': usage,
      'detectedClass': detectedClass,
      'tags': tags,
    };
  }

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      nameKhmer: json['nameKhmer'] ?? '',
      nameEnglish: json['nameEnglish'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      category: json['category'] ?? '',
      categoryKhmer: json['categoryKhmer'] ?? '',
      usage: json['usage'] ?? '',
      detectedClass: json['detectedClass'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
