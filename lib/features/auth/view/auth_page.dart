import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/primary_button.dart';
import '../controller/auth_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _controller = AuthController();
  final _aliasCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();

  String _role = 'acteur';
  bool _loading = false;

  @override
  void dispose() {
    _aliasCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    setState(() => _loading = true);
    try {
      final user = await _controller.startSession(
        alias: _aliasCtrl.text.trim(),
        role: _role,
        title: _titleCtrl.text.trim(),
      );

      // MVP: on route Acteur vers Acting Home.
      // Plus tard: role superviseur ira vers Monitoring (web).
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Session: ${user.alias} • ${user.title}')),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.actingHome);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SEC-DRC • Accès')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Démarrer une session (portable)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            const Text('Pas de mot de passe pour le MVP.'),
            const SizedBox(height: 16),

            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'acteur', label: Text('Acteur')),
                ButtonSegment(value: 'superviseur', label: Text('Superviseur')),
              ],
              selected: {_role},
              onSelectionChanged: (s) => setState(() => _role = s.first),
            ),

            const SizedBox(height: 16),
            TextField(
              controller: _aliasCtrl,
              decoration: const InputDecoration(
                labelText: 'Nom / Alias (optionnel)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Titre (optionnel)',
                hintText: 'Ex: Acteur terrain',
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),
            PrimaryButton(
              label: _loading ? 'Chargement…' : 'Continuer',
              icon: Icons.arrow_forward,
              onPressed: _loading ? null : _continue,
            ),
          ],
        ),
      ),
    );
  }
}

