// lib/services/auth_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../constants/main_constants.dart';
import '../model/auth_models.dart';

class AuthService {

  /// Login with email & password.
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(APIs.authUrl);
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'action': 'login',
        'email': email,
        'password': password,
      },
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return AuthResponse.fromJson(data);
    } else {
      final err = jsonDecode(resp.body)['error'] ?? resp.body;
      throw Exception('Login failed: $err');
    }
  }

  /// Register a new user
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String nationalNumber,
    required DateTime dateOfBirth,
    required String bloodType,
    required File cardFront,
    required File cardBack,
  }) async {
    final uri = Uri.parse(APIs.authUrl);
    final req = http.MultipartRequest('POST', uri)
      ..fields['action'] = 'register'
      ..fields['name'] = name
      ..fields['email'] = email
      ..fields['password'] = password
      ..fields['phone'] = phone
      ..fields['national_number'] = nationalNumber
      ..fields['date_of_birth'] = dateOfBirth.toIso8601String().split('T').first
      ..fields['blood_type'] = bloodType
      ..files.add(await http.MultipartFile.fromPath(
        'card_front',
        cardFront.path,
        filename: basename(cardFront.path),
      ))
      ..files.add(await http.MultipartFile.fromPath(
        'card_back',
        cardBack.path,
        filename: basename(cardBack.path),
      ));

    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      final data = jsonDecode(resp.body);
      return AuthResponse.fromJson(data);
    } else {
      final err = jsonDecode(resp.body)['error'] ?? resp.body;
      throw Exception('Registration failed: $err');
    }
  }
}
