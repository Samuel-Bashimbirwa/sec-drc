import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../contracts/alert_service.dart';
import '../model/alert_model.dart';

class AlertController extends GetxController {
  final AlertService _service;

  AlertController(this._service);

  // ==============================
  // STATE
  // ==============================

  final RxList<AlertModel> alerts = <AlertModel>[].obs;
  final RxBool loading = false.obs;
  final RxnString error = RxnString();

  // ==============================
  // REFRESH ALERTS
  // ==============================

  Future<void> refreshAlerts() async {
    if (loading.value) return;

    try {
      loading.value = true;
      error.value = null;

      final items = await _service.listAlerts();
      alerts.assignAll(items);
    } catch (e) {
      error.value = "Erreur lors du chargement des alertes";
    } finally {
      loading.value = false;
    }
  }

  // ==============================
  // CREATE ALERT
  // ==============================

  Future<AlertModel?> createAlert({
    required AlertType type,
    required LatLng position,
    double radiusMeters = 120,
  }) async {
    try {
      loading.value = true;
      error.value = null;

      final created = await _service.createAlert(
        type: type,
        position: position,
        radiusMeters: radiusMeters,
      );

      // insertion immédiate en haut
      alerts.insert(0, created);

      return created;
    } catch (e) {
      error.value = "Erreur lors de la création de l'alerte";
      return null;
    } finally {
      loading.value = false;
    }
  }

  // ==============================
  // REMOVE ALERT (local only)
  // ==============================

  void removeAlert(AlertModel alert) {
    alerts.remove(alert);
  }

  // ==============================
  // CLEAR
  // ==============================

  void clear() {
    alerts.clear();
  }
}