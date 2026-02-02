import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';



import '../../controller/location_controller.dart';
import '../../widgets/acting_action_buttons.dart';


class ActingMapPage extends StatefulWidget {
  const ActingMapPage({super.key});

  @override
  State<ActingMapPage> createState() => _ActingMapPageState();
}

class _ActingMapPageState extends State<ActingMapPage> {
  final _mapController = MapController();
  final _loc = LocationController();

  static const LatLng _kinshasa = LatLng(-4.4419, 15.2663);

  @override
  void initState() {
    super.initState();

    debugPrint('ActingMapPage mounted');

    _loc.addListener(() {
      if (!mounted) return;

      final p = _loc.state.position;
      if (p != null) {
        _mapController.move(p, 16);
      }
      setState(() {});
    });

    _loc.init();
  }

  @override
  void dispose() {
    _loc.dispose();
    super.dispose();
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
    final state = _loc.state;
    final center = state.position ?? _kinshasa;


  return Stack(
  children: [

  //Carte  
    Positioned.fill(
      child: SizedBox.expand(
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: state.position == null ? 13 : 16,
            minZoom: 3,
            maxZoom: 19,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.secdrc.actingmode',
            ),
            MarkerLayer(
              markers: [
                if (state.position != null)
                  Marker(
                    point: state.position!,
                    width: 42,
                    height: 42,
                    child: const Icon(Icons.my_location, size: 34),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),

    // Bouton centrer sur utilisateur
    Positioned(
      right: 12,
      bottom: 170, // Au-dessus des boutons d'action
      child: SafeArea(
        child: FloatingActionButton(
          onPressed: _centerOnUser,
          child: const Icon(Icons.my_location),
        ),
      ),
    ),

    
    //Overlay état (loading / error)
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

    //Overlay boutons (Tactile / Urgence)
    Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: SafeArea(
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ActingActionButtons(
              onSignal: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signaler (vert)')),
                );
              },
              onHelp: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Demander aide (orange)')),
                );
              },
              onUrgent: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Danger imminent (rouge)')),
                );
              },
              onVigilance: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Point de vigilance')),
                );
              },
            ),
          ),
        ),
      ),
    ),
  ],
);    

 }   

}  


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
