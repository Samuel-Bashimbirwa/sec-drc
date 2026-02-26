import 'package:latlong2/latlong.dart';
import '../features/acting/model/alert_model.dart';

abstract class AlertService {
  Future<AlertModel> createAlert({
    required AlertType type,
    required LatLng position,
    String? city,
    String? commune,
    String? quartier,
    String? avenue,
  });

  Future<List<AlertModel>> listAlerts();
}