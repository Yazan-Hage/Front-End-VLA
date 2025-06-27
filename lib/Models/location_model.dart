import 'package:latlong2/latlong.dart';

class LocationModel {
  final int? id;
  final int userId;
  final double latitude;
  final double longitude;
  final DateTime? recordedAt;

  LocationModel({
    this.id,
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.recordedAt,
  });

  LatLng get latLng => LatLng(latitude, longitude);

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      recordedAt: json['recorded_at'] != null
          ? DateTime.parse(json['recorded_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'latitude': latitude,
    'longitude': longitude,
  };
}
