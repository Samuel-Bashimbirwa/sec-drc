import 'package:flutter/material.dart';

class ActingActionButtons extends StatelessWidget {
  final VoidCallback? onSignal;
  final VoidCallback? onHelp;
  final VoidCallback? onUrgent;
  final VoidCallback? onVigilance;

  const ActingActionButtons({
    super.key,
    this.onSignal,
    this.onHelp,
    this.onUrgent,
    this.onVigilance,
  });

  Widget _bigBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return Expanded(
      child: SizedBox(
        height: 56,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: color),
          onPressed: onTap,
          icon: Icon(icon),
          label: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _bigBtn(
              icon: Icons.report_problem_outlined,
              label: 'Signaler',
              color: const Color(0xFF16A34A), // vert
              onTap: onSignal,
            ),
            const SizedBox(width: 10),
            _bigBtn(
              icon: Icons.support_agent_outlined,
              label: 'Aide',
              color: const Color(0xFFF59E0B), // orange
              onTap: onHelp,
            ),
            const SizedBox(width: 10),
            _bigBtn(
              icon: Icons.warning_amber_outlined,
              label: 'Urgence',
              color: const Color(0xFFDC2626), // rouge
              onTap: onUrgent,
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: onVigilance,
            icon: const Icon(Icons.visibility_outlined),
            label: const Text(
              'Point de vigilance',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}
