import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../model/location_state.dart';

class LocationController extends ChangeNotifier {
  LocationState state = const LocationState.initial();

  Future<void> init() async {
    // Pour éviter bugs sur Flutter Web, on ne lance pas le GPS.
    if (kIsWeb) {
      state = state.copyWith(
        loading: false,
        position: const LatLng(-4.4419, 15.2663), // Kinshasa fallback
        error: 'Localisation non supportée (web).',
      );
      notifyListeners();
      return;
    }

    state = state.copyWith(loading: true, error: null);
    notifyListeners();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          loading: false,
          error: "Le service de localisation est désactivé.",
        );
        notifyListeners();
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
        notifyListeners();
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        state = state.copyWith(
          loading: false,
          error: "Permission refusée définitivement. Active-la dans les paramètres.",
        );
        notifyListeners();
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
      notifyListeners();
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: "Erreur localisation: $e",
      );
      notifyListeners();
    }
  }
}
