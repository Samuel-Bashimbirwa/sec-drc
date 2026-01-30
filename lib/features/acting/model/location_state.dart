import 'package:latlong2/latlong.dart';

class LocationState {
  final bool loading;
  final LatLng? position;
  final String? error;

  const LocationState({
    required this.loading,
    required this.position,
    required this.error,
  });

  const LocationState.initial()
      : loading = false,
        position = null,
        error = null;

  LocationState copyWith({
    bool? loading,
    LatLng? position,
    String? error,
  }) {
    return LocationState(
      loading: loading ?? this.loading,
      position: position ?? this.position,
      error: error,
    );
  }
}
