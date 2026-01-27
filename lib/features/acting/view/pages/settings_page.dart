import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text(
          'Paramètres',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Notifications'),
            subtitle: Text('MVP: ON/OFF'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.language_outlined),
            title: Text('Langue'),
            subtitle: Text('Français'),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Confidentialité'),
            subtitle: Text('MVP: anonymisation & règles'),
          ),
        ),
      ],
    );
  }
}
