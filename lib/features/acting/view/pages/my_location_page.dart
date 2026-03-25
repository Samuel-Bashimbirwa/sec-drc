import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/location_controller.dart';

class MyLocationPage extends StatelessWidget {
  const MyLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = Get.find<LocationController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Ma Localisation',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // État GPS
          GetBuilder<LocationController>(
            builder: (c) {
              final state = c.state;
              final isOk = state.position != null;

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: isOk ? Colors.green.shade200 : Colors.orange.shade200),
                ),
                color: isOk ? Colors.green.shade50 : Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        isOk ? Icons.gps_fixed : Icons.gps_not_fixed,
                        color: isOk ? Colors.green : Colors.orange,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isOk ? 'Signal GPS Actif' : 'Recherche de signal…',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isOk ? Colors.green.shade900 : Colors.orange.shade900,
                              ),
                            ),
                            Text(
                              state.error ?? (isOk ? 'Position synchronisée' : 'En attente de précision'),
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                      if (state.loading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Coordonnées
          _buildInfoSection('Coordonnées précises'),
          GetBuilder<LocationController>(
            builder: (c) {
              final pos = c.state.position;
              return _buildCoordinateCard(
                lat: pos?.latitude.toStringAsFixed(6) ?? '---',
                lng: pos?.longitude.toStringAsFixed(6) ?? '---',
              );
            },
          ),

          const SizedBox(height: 32),

          // Recherche / Quartiers (Yeux des citoyens)
          _buildInfoSection('Yeux des Citoyens : Zone actuelle'),
          Obx(() {
            final zone = loc.currentZone.value;
            return Card(
              elevation: 0,
              color: Colors.blueGrey.shade800,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.location_city, color: Colors.white),
                title: Text(zone ?? 'Zone inconnue', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Basé sur votre position actuelle', style: TextStyle(color: Colors.white70)),
              ),
            );
          }),
          
          const SizedBox(height: 16),
          
          Obx(() {
            final results = loc.searchResults;
            if (results.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Utilisez la barre de recherche pour explorer communes, quartiers et avenues.', 
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 8),
                  child: Text('Résultats de recherche', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
                ...results.map((r) => Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.search_off_outlined), // should be a better icon
                    title: Text(r),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Get.snackbar('Yeux des Citoyens', 'Exploration de $r (à venir)');
                    },
                  ),
                )),
              ],
            );
          }),

          const SizedBox(height: 40),
          
          OutlinedButton.icon(
            onPressed: () => loc.init(),
            icon: const Icon(Icons.refresh),
            label: const Text('Forcer la synchronisation'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildCoordinateCard({required String lat, required String lng}) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: _buildCoordField('LATITUDE', lat),
            ),
            Container(width: 1, height: 40, color: Colors.grey.shade200),
            Expanded(
              child: _buildCoordField('LONGITUDE', lng),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordField(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
      ],
    );
  }
}
