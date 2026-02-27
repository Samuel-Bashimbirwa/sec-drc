import 'package:latlong2/latlong.dart';

enum AlertType {
  signal,    // "Signaler"
  help,      // "Aide"
  urgent,    // "Urgence"
  vigilance, // "Point de vigilance"
}

class AlertModel {
  final String id;
  final AlertType type;
  final LatLng position;
  final DateTime createdAt;

final double radiusMeter;
  // Infos optionnelles (MVP extensible)
  final String? city;
  final String? commune;
  final String? quartier;
  final String? avenue;
  final String? description;

  const AlertModel({
    required this.id,
    required this.type,
    required this.position,
    required this.createdAt,
    this.radiusMeter = 100, // par défaut, on considère que l'alerte concerne un rayon de 100m
    this.city,
    this.commune,
    this.quartier,
    this.avenue,
    this.description,
  });

  AlertModel copyWith({
    String? id,
    AlertType? type,
    LatLng? position,
    DateTime? createdAt,
    String? city,
    String? commune,
    String? quartier,
    String? avenue,
    String? description,
  }) {
    return AlertModel(
      id: id ?? this.id,
      type: type ?? this.type,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      city: city ?? this.city,
      commune: commune ?? this.commune,
      quartier: quartier ?? this.quartier,
      avenue: avenue ?? this.avenue,
      description: description ?? this.description,
    );
  }
}