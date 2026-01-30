import 'package:flutter/material.dart';


class MyLocationPage extends StatelessWidget {
  const MyLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Ma localisation',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 10),
          Text('MVP: ici on affichera la position GPS + état permission.'),
          SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: Icon(Icons.gps_fixed),
              title: Text('Permission localisation'),
              subtitle: Text('À implémenter'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.my_location),
              title: Text('Coordonnées actuelles'),
              subtitle: Text('Lat: ---, Lng: ---'),
            ),
          ),
        ],
      ),
    );
  }
}
