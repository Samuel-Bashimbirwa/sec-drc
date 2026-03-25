import 'package:latlong2/latlong.dart';
import '../../../common/api_client.dart';
import '../../../contracts/alert_service.dart';
import '../model/alert_model.dart';

class AlertServiceImpl implements AlertService {
  final ApiClient _api;

  AlertServiceImpl(this._api);

  @override
  Future<AlertModel> createAlert({
    required AlertType type,
    required LatLng position,
    double radiusMeters = 100,
  }) async {
    final response = await _api.post('/alerts', data: {
      'type': type.name.toUpperCase(),
      'lng': position.longitude,
      'lat': position.latitude,
      'radius': radiusMeters,
    });
    
    return _parseAlert(response.data);
  }

  @override
  Future<List<AlertModel>> listAlerts() async {
    // Admin/Supervisor only
    final response = await _api.get('/alerts');
    return (response.data as List).map((json) => _parseAlert(json)).toList();
  }

  @override
  Future<List<AlertModel>> listNearAlerts({
    required LatLng position,
    double radiusMeters = 5000,
    bool onlyUrgent = false,
  }) async {
    final endpoint = onlyUrgent ? '/alerts/near/urgent' : '/alerts/near';
    
    final response = await _api.get(
      endpoint,
      queryParameters: {
        'lng': position.longitude,
        'lat': position.latitude,
        'radius': radiusMeters,
      },
    );
    
    return (response.data as List).map((json) => _parseAlert(json)).toList();
  }

  AlertModel _parseAlert(Map<String, dynamic> json) {
    // The geometry comes from PostGIS: { type: 'Point', coordinates: [lng, lat] }
    final coords = json['location']['coordinates'] as List;
    final alertTypeStr = json['type'] as String;
    
    AlertType type = AlertType.signal;
    switch (alertTypeStr) {
      case 'URGENT': type = AlertType.urgent; break;
      case 'HELP': type = AlertType.help; break;
      case 'VIGILANCE': type = AlertType.vigilance; break;
      case 'SIGNAL': type = AlertType.signal; break;
    }

    return AlertModel(
      id: json['id'],
      type: type,
      position: LatLng(coords[1], coords[0]), // PostGIS is [lng, lat], LatLng is (lat, lng)
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      radiusMeter: (json['radius_meters'] ?? 100).toDouble(),
    );
  }
}
