import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../common/storage_service.dart';
import '../../../contracts/alert_service.dart';
import '../model/alert_model.dart';
import 'location_controller.dart';

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

      final storage = Get.find<StorageService>();
      final loc = Get.find<LocationController>();
      final role = storage.user?.role ?? 'USER';
      final pos = loc.state.position;

      List<AlertModel> items = [];

      if (role == 'USER') {
        if (pos != null) {
          items = await _service.listNearAlerts(
            position: pos, 
            onlyUrgent: true
          );
        } else {
          // Si on n'a pas la position d'un USER, on ne peut rien afficher de pertinent
          items = [];
          error.value = "Attente de la position GPS...";
        }
      } else {
        // ADMIN / SUPERVISOR
        items = await _service.listAlerts();
      }

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