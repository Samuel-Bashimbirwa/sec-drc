import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/alert_controller.dart';
import '../../model/alert_model.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  String _label(AlertType t) => switch (t) {
        AlertType.signal => 'Signalement',
        AlertType.help => 'Aide',
        AlertType.vigilance => 'Vigilance',
        AlertType.urgent => 'Urgence',
      };

  IconData _icon(AlertType t) => switch (t) {
        AlertType.signal => Icons.report_problem_outlined,
        AlertType.help => Icons.support_agent_outlined,
        AlertType.vigilance => Icons.visibility_outlined,
        AlertType.urgent => Icons.warning_amber_outlined,
      };

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AlertController>();

    // charge au premier affichage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (c.alerts.isEmpty && !c.loading.value) c.refresh();
    });

    return Obx(() {
      if (c.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (c.error.value != null) {
        return Center(child: Text(c.error.value!));
      }

      if (c.alerts.isEmpty) {
        return const Center(child: Text('Aucune alerte pour le moment.'));
      }

      return ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: c.alerts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final a = c.alerts[i];
          return Card(
            child: ListTile(
              leading: Icon(_icon(a.type)),
              title: Text(_label(a.type)),
              subtitle: Text(
                '${a.createdAt}\nLat: ${a.position.latitude}, Lng: ${a.position.longitude}',
              ),
              isThreeLine: true,
            ),
          );
        },
      );
    });
  }
}