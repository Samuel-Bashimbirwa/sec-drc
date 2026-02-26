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

  // ✅ copyWith "pro" :
  // - si tu ne passes pas error => il reste inchangé
  // - si tu passes error: "msg" => il devient "msg"
  // - si tu passes error: null => il s'efface
  LocationState copyWith({
    bool? loading,
    LatLng? position,
    Object? error = _noChange,
  }) {
    return LocationState(
      loading: loading ?? this.loading,
      position: position ?? this.position,
      error: identical(error, _noChange) ? this.error : error as String?,
    );
  }

  static const _noChange = Object();
}