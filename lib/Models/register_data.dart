// lib/models/register_data.dart
import 'dart:io';

class RegisterData {
  String name = '';
  String email = '';
  String password = '';
  String phone = '';
  String nationalNumber = '';
  String bloodType = '';
  DateTime? dateOfBirth;
  File? cardFront;
  File? cardBack;
}
