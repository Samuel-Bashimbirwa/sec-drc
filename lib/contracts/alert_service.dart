import 'package:latlong2/latlong.dart';
import '../features/acting/model/alert_model.dart';

abstract class AlertService {
  Future<AlertModel> createAlert({
    required AlertType type,
    required LatLng position,
    double radiusMeters,
  });

  Future<List<AlertModel>> listAlerts();
  
  Future<List<AlertModel>> listNearAlerts({
    required LatLng position,
    double radiusMeters = 5000,
    bool onlyUrgent = false,
  });
}