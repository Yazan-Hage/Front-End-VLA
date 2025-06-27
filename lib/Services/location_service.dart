import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/main_constants.dart';
import '../constants/name_of_pages.dart';
import '../model/location_model.dart';

class LocationService {
  // Change these to your real endpoint & key
  static const _baseUrl = 'https://your-domain.com/api';
  static const _adminKey = 'ReplaceWithYourSecretKey';

  /// Sends the current user location to the backend.
  Future<LocationModel> saveLocation(LocationModel loc) async {
    final uri = Uri.parse(APIs.locationUserUrl);
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loc.toJson()),
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      if (data['status'] == 'success') {
        // backend returns location_id and recorded_at
        return LocationModel(
          id: data['location_id'] as int,
          userId: loc.userId,
          latitude: loc.latitude,
          longitude: loc.longitude,
          recordedAt: DateTime.parse(data['recorded_at'] as String),
        );
      }
    }
    throw Exception('Failed to save location: ${resp.body}');
  }

  /// Fetches all locations (admin) or for a specific user if [userId] is provided.
  Future<List<LocationModel>> fetchLocations({int? userId}) async {
    final params = {'admin_key': _adminKey};
    if (userId != null) params['user_id'] = '$userId';
    final uri = Uri.parse('$_baseUrl/user_location_api.php')
        .replace(queryParameters: params);
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      if (data['status'] == 'success') {
        final list = data['locations'] as List<dynamic>;
        return list
            .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    throw Exception('Failed to fetch locations: ${resp.body}');
  }
}
