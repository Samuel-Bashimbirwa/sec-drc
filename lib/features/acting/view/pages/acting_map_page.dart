import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';

import '../../controller/location_controller.dart';
import '../../controller/alert_controller.dart';
import '../../model/alert_model.dart';

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}

class ActingMapPage extends StatefulWidget {
  const ActingMapPage({super.key});

  @override
  State<ActingMapPage> createState() => _ActingMapPageState();
}

class _ActingMapPageState extends State<ActingMapPage> {
  late final AlertController _alert;
  late final LocationController _loc;

  final MapController _mapController = MapController();

  static const LatLng _kinshasa = LatLng(-4.4419, 15.2663);

  @override
  void initState() {
    super.initState();

    _alert = Get.find<AlertController>();
    _loc = Get.find<LocationController>();

    debugPrint('ActingMapPage mounted');

    // Safe (ne casse pas si Home l'a déjà appelé)
    _loc.init();
  }

  void _centerOnUser() {
    final p = _loc.state.position;
    if (p != null) {
      _mapController.move(p, 16);
    } else {
      _mapController.move(_kinshasa, 13);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Position indisponible (fallback Kinshasa)."),
        ),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return GetBuilder<LocationController>(
    builder: (loc) {
      final state = loc.state;
      final center = state.position ?? _kinshasa;

      return Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: center,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.secdrc.actingmode',
              ),

              // 🔵 Zones alertes
              Obx(() {
                final alerts = _alert.alerts;

                return CircleLayer(
                  circles: alerts.map((a) {
                    Color color;

                    switch (a.type) {
                      case AlertType.urgent:
                        color = Colors.red;
                        break;
                      case AlertType.help:
                        color = Colors.orange;
                        break;
                      case AlertType.vigilance:
                        color = Colors.blue;
                        break;
                      case AlertType.signal:
                        color = Colors.green;
                        break;
                    }

                    return CircleMarker(
                      point: a.position,
                      radius: 100,
                      useRadiusInMeter: true,
                      color: color.withOpacity(0.15),
                      borderColor: color,
                      borderStrokeWidth: 2,
                    );
                  }).toList(),
                );
              }),

              // 📍 Position utilisateur
              if (state.position != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: state.position!,
                      width: 42,
                      height: 42,
                      child: const Icon(
                        Icons.my_location,
                        size: 34,
                      ),
                    ),
                  ],
                ),

              // 🚨 Markers alertes
              Obx(() {
                final alerts = _alert.alerts;

                return MarkerLayer(
                  markers: alerts.map((a) {
                    IconData icon;
                    Color color;

                    switch (a.type) {
                      case AlertType.urgent:
                        icon = Icons.warning;
                        color = Colors.red;
                        break;
                      case AlertType.help:
                        icon = Icons.volunteer_activism;
                        color = Colors.orange;
                        break;
                      case AlertType.vigilance:
                        icon = Icons.visibility;
                        color = Colors.blue;
                        break;
                      case AlertType.signal:
                        icon = Icons.report;
                        color = Colors.green;
                        break;
                    }

                    return Marker(
                      point: a.position,
                      width: 40,
                      height: 40,
                      child: Icon(icon, color: color, size: 32),
                    );
                  }).toList(),
                );
              }),
            ],
          ),

          // 🎯 FAB centrer
          Positioned(
            right: 12,
            bottom: 12,
            child: SafeArea(
              child: FloatingActionButton(
                heroTag: 'fab_center_user',
                onPressed: _centerOnUser,
                child: const Icon(Icons.my_location),
              ),
            ),
          ),

          // ℹ Overlay loading / error
          Positioned(
            left: 12,
            right: 12,
            top: 12,
            child: SafeArea(
              child: Column(
                children: [
                  if (state.loading)
                    const _InfoChip(
                      icon: Icons.timelapse,
                      text: 'Récupération localisation…',
                    ),
                  if (state.error != null)
                    _InfoChip(
                      icon: Icons.error_outline,
                      text: state.error!,
                    ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
  }
}