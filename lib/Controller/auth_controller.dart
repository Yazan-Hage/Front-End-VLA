// lib/providers/auth_provider.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/auth_models.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  bool _loading = false;
  String? _token;
  UserProfile? _user;

  bool get loading => _loading;
  String? get token => _token;
  UserProfile? get user => _user;

  // PRIVATE keys
  static const _kTokenKey     = 'auth_token';
  static const _kUserIdKey    = 'user_id';
  static const _kNameKey      = 'user_name';
  static const _kEmailKey     = 'user_email';
  static const _kPhoneKey     = 'user_phone';
  static const _kNatNumKey    = 'user_national_number';
  static const _kDobKey       = 'user_date_of_birth';
  static const _kBloodKey     = 'user_blood_type';
  static const _kCardFrontKey = 'user_card_front_path';
  static const _kCardBackKey  = 'user_card_back_path';

  /// NEW: Persist user role
  static const _kRoleKey      = 'user_role';

  /// Public key for AccidentPage lookup
  static const userIdKey = _kUserIdKey;

  /// Load saved auth data
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_kTokenKey);

    final id    = prefs.getInt(_kUserIdKey);
    final name  = prefs.getString(_kNameKey);
    final email = prefs.getString(_kEmailKey);
    final phone = prefs.getString(_kPhoneKey) ?? '';
    final nat   = prefs.getString(_kNatNumKey) ?? '';
    final dobStr= prefs.getString(_kDobKey);
    final blood = prefs.getString(_kBloodKey) ?? '';
    final front = prefs.getString(_kCardFrontKey) ?? '';
    final back  = prefs.getString(_kCardBackKey) ?? '';
    final role  = prefs.getString(_kRoleKey) ?? '';

    DateTime? dob;
    if (dobStr != null && dobStr.isNotEmpty) {
      dob = DateTime.tryParse(dobStr);
    }

    if (_token != null && id != null && name != null && email != null) {
      _user = UserProfile(
        id: id,
        name: name,
        email: email,
        phone: phone,
        role: role,
        nationalNumber: nat,
        dateOfBirth: dob,
        bloodType: blood,
        cardFrontPath: front,
        cardBackPath: back,
      );
    }

    notifyListeners();
  }

  Future<void> _saveToken(String t) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTokenKey, t);
    _token = t;
  }

  Future<void> _saveUserData(AuthResponse resp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kUserIdKey, resp.user.id);
    await prefs.setString(_kNameKey, resp.user.name);
    await prefs.setString(_kEmailKey, resp.user.email);
    await prefs.setString(_kPhoneKey, resp.user.phone);
    await prefs.setString(_kRoleKey, resp.user.role);           // save role
    await prefs.setString(_kNatNumKey, resp.user.nationalNumber);
    if (resp.user.dateOfBirth != null) {
      await prefs.setString(_kDobKey, resp.user.dateOfBirth!.toIso8601String());
    }
    await prefs.setString(_kBloodKey, resp.user.bloodType);
    await prefs.setString(_kCardFrontKey, resp.user.cardFrontPath);
    await prefs.setString(_kCardBackKey, resp.user.cardBackPath);

    // mirror into memory
    _user = UserProfile(
      id: resp.user.id,
      name: resp.user.name,
      email: resp.user.email,
      phone: resp.user.phone,
      role: resp.user.role,
      nationalNumber: resp.user.nationalNumber,
      dateOfBirth: resp.user.dateOfBirth,
      bloodType: resp.user.bloodType,
      cardFrontPath: resp.user.cardFrontPath,
      cardBackPath: resp.user.cardBackPath,
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenKey);
    await prefs.remove(_kUserIdKey);
    await prefs.remove(_kNameKey);
    await prefs.remove(_kEmailKey);
    await prefs.remove(_kPhoneKey);
    await prefs.remove(_kRoleKey);
    await prefs.remove(_kNatNumKey);
    await prefs.remove(_kDobKey);
    await prefs.remove(_kBloodKey);
    await prefs.remove(_kCardFrontKey);
    await prefs.remove(_kCardBackKey);
    _token = null;
    _user  = null;
    notifyListeners();
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final resp = await _service.login(email: email, password: password);
      await _saveToken(resp.token);
      await _saveUserData(resp);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register({
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
    _setLoading(true);
    try {
      final resp = await _service.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        nationalNumber: nationalNumber,
        dateOfBirth: dateOfBirth,
        bloodType: bloodType,
        cardFront: cardFront,
        cardBack: cardBack,
      );
      await _saveToken(resp.token);
      await _saveUserData(resp);
    } finally {
      _setLoading(false);
    }
  }
}
