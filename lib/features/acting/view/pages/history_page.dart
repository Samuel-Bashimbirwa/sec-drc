import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historique',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          const Text('MVP: liste des signalements envoyés.'),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: const [
                Card(
                  child: ListTile(
                    leading: Icon(Icons.report_problem_outlined),
                    title: Text('Signalement - Vert'),
                    subtitle: Text('Avenue … • Aujourd’hui • 20:30'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.support_agent_outlined),
                    title: Text('Demande d’aide - Orange'),
                    subtitle: Text('Quartier … • Hier • 21:10'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
