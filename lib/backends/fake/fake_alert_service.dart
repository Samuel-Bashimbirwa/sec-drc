import 'dart:math';
import 'package:latlong2/latlong.dart';

import '../../contracts/alert_service.dart';
import '../../features/acting/model/alert_model.dart';

class FakeAlertService implements AlertService {
  final _rnd = Random();
  final List<AlertModel> _alerts = [];

  @override
  Future<AlertModel> createAlert({
    required AlertType type,
    required LatLng position,
    String? city,
    String? commune,
    String? quartier,
    String? avenue,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));

    final alert = AlertModel(
      id: 'fake-${DateTime.now().millisecondsSinceEpoch}-${_rnd.nextInt(9999)}',
      type: type,
      position: position,
      createdAt: DateTime.now(),
      city: city,
      commune: commune,
      quartier: quartier,
      avenue: avenue,
    );

    _alerts.insert(0, alert);
    return alert;
  }

  @override
  Future<List<AlertModel>> listAlerts() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return List.unmodifiable(_alerts);
  }
}