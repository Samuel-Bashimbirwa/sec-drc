import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../model/location_state.dart';

class LocationController extends GetxController {
  LocationState state = const LocationState.initial();

  bool _started = false;
  bool _loadingNow = false;

  final RxList<String> searchResults = <String>[].obs;
  final RxnString currentZone = RxnString('Recherche de zone...');

  /// Appel safe : tu peux l''appeler depuis Home et Map sans casser.
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
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
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

  void search(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      update();
      return;
    }

    // Simulation de données pour Kinshasa
    final mockData = [
      'Gombe',
      'Lingwala',
      'Kintambo',
      'Ngaliema',
      'Bandalungwa',
      'Limete',
      'Matete',
      'Ndjili',
      'Masina',
      'Kimbanseke',
      'Avenue de la Justice',
      'Avenue du 24 Novembre',
      'Boulevard du 30 Juin',
      'Quartier Joli Parc',
      'Quartier Macampagne',
      'Avenue Colonel Mondjiba',
      'Quartier GB',
      'Commune de Lemba',
    ];

    searchResults.assignAll(mockData
        .where((element) =>
            element.toLowerCase().contains(query.toLowerCase()))
        .toList());

    if (searchResults.isNotEmpty) {
      currentZone.value = searchResults.first;
    }
    update();
  }
}