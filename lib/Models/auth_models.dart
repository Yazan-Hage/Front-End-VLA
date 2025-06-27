// lib/models/auth_models.dart

class AuthResponse {
  final String token;
  final UserProfile user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: (json['token'] ?? '') as String,
      user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class UserProfile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String nationalNumber;
  final DateTime? dateOfBirth;
  final String bloodType;
  final String cardFrontPath;
  final String cardBackPath;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.nationalNumber,
    required this.dateOfBirth,
    required this.bloodType,
    required this.cardFrontPath,
    required this.cardBackPath,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final id = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '') ?? 0;

    final name = json['name']?.toString() ?? '';
    final email = json['email']?.toString() ?? '';
    final phone = json['phone']?.toString() ?? '';
    final role = json['role']?.toString() ?? '';
    final nationalNumber = json['national_number']?.toString() ?? '';

    DateTime? dob;
    final dobString = json['date_of_birth']?.toString();
    if (dobString != null && dobString.isNotEmpty) {
      dob = DateTime.tryParse(dobString);
    }

    final bloodType = json['blood_type']?.toString() ?? '';
    final cardFront = json['card_front_path']?.toString() ?? '';
    final cardBack  = json['card_back_path']?.toString()  ?? '';

    return UserProfile(
      id: id,
      name: name,
      email: email,
      phone: phone,
      role: role,
      nationalNumber: nationalNumber,
      dateOfBirth: dob,
      bloodType: bloodType,
      cardFrontPath: cardFront,
      cardBackPath: cardBack,
    );
  }
}
