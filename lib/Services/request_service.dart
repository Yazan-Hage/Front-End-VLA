// lib/services/request_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../controller/auth_controller.dart';
import '../model/request_model.dart';
import '../constants/main_constants.dart';

class RequestService {
  final String token;
  RequestService({required this.token});

  Future<List<RequestWithUser>> fetchUserRequests() async {
    if (token.isEmpty) throw Exception('No auth token');
    final uri = Uri.parse(APIs.requestUrl);
    final resp = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (resp.statusCode == 200) {
      final List<dynamic> arr = jsonDecode(resp.body);
      return arr
          .map((e) => RequestWithUser.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (resp.statusCode == 401) {
      throw Exception('Unauthorized – invalid token');
    } else {
      throw Exception('Failed to load requests (status ${resp.statusCode})');
    }
  }

  Future<int> createRequest(String licenseType) async {
    if (token.isEmpty) throw Exception('No auth token');

    final uri = Uri.parse(APIs.requestUrl);
    final resp = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'license_type': licenseType}),
    );

    if (resp.statusCode == 201) {
      final data = jsonDecode(resp.body);
      return (data['request_id'] as num).toInt();
    } else if (resp.statusCode == 401) {
      throw Exception('Unauthorized – invalid token');
    } else {
      final err = jsonDecode(resp.body)['error'] ?? resp.body;
      throw Exception('Create request failed: $err');
    }
  }
}
