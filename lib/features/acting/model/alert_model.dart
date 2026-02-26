import 'package:latlong2/latlong.dart';

enum AlertType { signal, help, vigilance, urgent }

class AlertModel {
  final String id;
  final AlertType type;
  final LatLng position;
  final DateTime createdAt;

  // Pour futur backend
  final String? city;
  final String? commune;
  final String? quartier;
  final String? avenue;

  const AlertModel({
    required this.id,
    required this.type,
    required this.position,
    required this.createdAt,
    this.city,
    this.commune,
    this.quartier,
    this.avenue,
  });
}