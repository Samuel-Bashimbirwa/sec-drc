import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/alert_controller.dart';
import '../../model/alert_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final AlertController c = Get.find<AlertController>();

  @override
  void initState() {
    super.initState();

    if (c.alerts.isEmpty && !c.loading.value) {
      c.refresh();
    }
  }

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

  Color _color(AlertType t) => switch (t) {
        AlertType.signal => Colors.green,
        AlertType.help => Colors.orange,
        AlertType.vigilance => Colors.blue,
        AlertType.urgent => Colors.red,
      };

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy • HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (c.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (c.error.value != null) {
        return Center(child: Text(c.error.value!));
      }

      if (c.alerts.isEmpty) {
        return const Center(
          child: Text('Aucune alerte pour le moment.'),
        );
      }

      final alerts = c.alerts.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: alerts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final a = alerts[i];

          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _color(a.type).withOpacity(0.15),
                child: Icon(
                  _icon(a.type),
                  color: _color(a.type),
                ),
              ),
              title: Text(
                _label(a.type),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${_formatDate(a.createdAt)}\n'
                'Lat: ${a.position.latitude.toStringAsFixed(4)}, '
                'Lng: ${a.position.longitude.toStringAsFixed(4)}',
              ),
              isThreeLine: true,
            ),
          );
        },
      );
    });
  }
}