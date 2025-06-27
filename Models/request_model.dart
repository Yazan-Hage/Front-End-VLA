// lib/models/request_with_user.dart

class RequestWithUser {
  final int    requestId;
  final String licenseType;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  // embedded user
  final int      userId;
  final String   name;
  final String   email;
  final String   phone;
  final String   nationalNumber;
  final DateTime dateOfBirth;
  final String   bloodType;
  final String   cardFrontPath;
  final String   cardBackPath;

  RequestWithUser({
    required this.requestId,
    required this.licenseType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.nationalNumber,
    required this.dateOfBirth,
    required this.bloodType,
    required this.cardFrontPath,
    required this.cardBackPath,
  });

  factory RequestWithUser.fromJson(Map<String, dynamic> json) {
    return RequestWithUser(
      requestId:      json['id'] as int,
      licenseType:    json['license_type'] as String,
      status:         json['status'] as String,
      createdAt:      DateTime.parse(json['created_at'] as String),
      updatedAt:      DateTime.parse(json['updated_at'] as String),
      userId:         json['user_id'] as int,
      name:           json['name'] as String,
      email:          json['email'] as String,
      phone:          json['phone'] as String,
      nationalNumber: json['national_number'] as String,
      dateOfBirth:    DateTime.parse(json['date_of_birth'] as String),
      bloodType:      json['blood_type'] as String,
      cardFrontPath:  json['card_front_path'] as String,
      cardBackPath:   json['card_back_path'] as String,
    );
  }
}
