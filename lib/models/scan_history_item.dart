import 'scan_result.dart';

class ScanHistoryItem {
  final String id;
  final String image;
  final ScanResult result;
  final DateTime timestamp;

  ScanHistoryItem({
    required this.id,
    required this.image,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'result': result.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ScanHistoryItem.fromJson(Map<String, dynamic> json) {
    return ScanHistoryItem(
      id: json['id'] ?? '',
      image: json['image'] ?? '',
      result: ScanResult.fromJson(json['result'] ?? {}),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
