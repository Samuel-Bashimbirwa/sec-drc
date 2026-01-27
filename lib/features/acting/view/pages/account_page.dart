import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Compte',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('Nom / Alias'),
              subtitle: Text('MVP: à renseigner'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.badge_outlined),
              title: Text('Titre'),
              subtitle: Text('Ex: Agent, Chef de poste, Volontaire…'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.security_outlined),
              title: Text('Rôle'),
              subtitle: Text('ACTING (fixé pour MVP)'),
            ),
          ),
        ],
      ),
    );
  }
}
