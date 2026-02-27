import 'dart:math';

import 'package:latlong2/latlong.dart';

import '../../contracts/alert_service.dart';
import '../../features/acting/model/alert_model.dart';

class FakeAlertService implements AlertService {
  final List<AlertModel> _items = [];

  String _id() {
    final r = Random();
    return '${DateTime.now().millisecondsSinceEpoch}-${r.nextInt(999999)}';
  }

  @override
  Future<AlertModel> createAlert({ 
    required AlertType type,
    required LatLng position,
    double radiusMeters = 100,
  }) async {
    final model = AlertModel(
      id: _id(),
      type: type,
      position: position,
      createdAt: DateTime.now(),
      radiusMeter: radiusMeters,
    );

    _items.insert(0, model); // le plus récent en premier
    return model;
  }

  @override
  Future<List<AlertModel>> listAlerts() async {
    return List.unmodifiable(_items);
  }
}