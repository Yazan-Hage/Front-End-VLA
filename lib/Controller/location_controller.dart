import 'package:flutter/material.dart';
import '../model/location_model.dart';
import '../services/location_service.dart';

class LocationController extends ChangeNotifier {
  final LocationService _service = LocationService();

  bool isLoading = false;
  String? errorMessage;
  List<LocationModel> locations = [];

  Future<void> reportLocation(LocationModel loc) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final saved = await _service.saveLocation(loc);
      locations.insert(0, saved);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLocations({int? userId}) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      locations = await _service.fetchLocations(userId: userId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
