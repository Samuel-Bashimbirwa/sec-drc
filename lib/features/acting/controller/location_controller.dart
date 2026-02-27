import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../model/location_state.dart';

class LocationController extends GetxController {
  LocationState state = const LocationState.initial();

  bool _started = false;
  bool _loadingNow = false;

  /// Appel safe : tu peux l'appeler depuis Home et Map sans casser.
  Future<void> init() async {
    if (_loadingNow) return;

    // Empêche de relancer 20 fois (mais autorise un "re-try" si erreur)
    if (_started && state.position != null) return;
    _started = true;

    // Web fallback
    if (kIsWeb) {
      state = state.copyWith(
        loading: false,
        position: const LatLng(-4.4419, 15.2663),
        error: 'Localisation non supportée (web).',
      );
      update(); // ✅ GetX refresh
      return;
    }

    _loadingNow = true;
    state = state.copyWith(loading: true, error: null);
    update();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          loading: false,
          error: "Le service de localisation est désactivé.",
        );
        update();
        _loadingNow = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        state = state.copyWith(
          loading: false,
          error: "Permission localisation refusée.",
        );
        update();
        _loadingNow = false;
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          loading: false,
          error:
              "Permission refusée définitivement. Active-la dans les paramètres.",
        );
        update();
        _loadingNow = false;
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      state = state.copyWith(
        loading: false,
        position: LatLng(pos.latitude, pos.longitude),
        error: null,
      );
      update();
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: "Erreur localisation: $e",
      );
      update();
    } finally {
      _loadingNow = false;
    }
  }
}