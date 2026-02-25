import 'package:flutter/material.dart';

class ActingActionButtons extends StatelessWidget {
  final VoidCallback? onSignal;
  final VoidCallback? onHelp;
  final VoidCallback? onVigilance;

  const ActingActionButtons({
    super.key,
    this.onSignal,
    this.onHelp,
    this.onVigilance,
  });

  Widget _bigbtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
        height: 54,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: color),
          onPressed: onTap,
          icon: Icon(icon),
          label: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w800),
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
            _bigbtn(
              icon: Icons.report_problem_outlined,
              label: 'Signal',
              color: const Color.fromARGB(255, 28, 86, 1), // vert
              onTap: onSignal,
            ),
            const SizedBox(width: 10),
            _bigbtn(
              icon: Icons.support_agent_outlined,
              label: 'Aide ',
              color: const Color.fromARGB(199, 184, 193, 3), // jaune
              onTap: onHelp,
            ),
            const SizedBox(width: 10),
            _bigbtn(
              icon: Icons.visibility_outlined,
              label: 'Vigilance',
              color: const Color.fromARGB(255, 4, 87, 125), // bleu
              onTap: onVigilance,
            ),
          ],
        ),
      ],
    );
  }
}
