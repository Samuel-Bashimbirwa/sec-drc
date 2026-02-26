import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../contracts/alert_service.dart';
import '../model/alert_model.dart';

class AlertController extends GetxController {
  final AlertService _service;

  AlertController(this._service);

  final alerts = <AlertModel>[].obs;
  final loading = false.obs;
  final error = RxnString();

  Future<void> refresh() async {
    try {
      loading.value = true;
      error.value = null;
      final data = await _service.listAlerts();
      alerts.assignAll(data);
    } catch (e) {
      error.value = 'Erreur chargement alertes: $e';
    } finally {
      loading.value = false;
    }
  }

  Future<AlertModel?> createAlert({
    required AlertType type,
    required LatLng position,
    String? city,
    String? commune,
    String? quartier,
    String? avenue,
  }) async {
    try {
      error.value = null;
      final created = await _service.createAlert(
        type: type,
        position: position,
        city: city,
        commune: commune,
        quartier: quartier,
        avenue: avenue,
      );
      alerts.insert(0, created);
      return created;
    } catch (e) {
      error.value = 'Erreur création alerte: $e';
      return null;
    }
  }
}