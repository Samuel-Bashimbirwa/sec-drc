import 'package:flutter/material.dart';
import '../widgets/acting_action_buttons.dart';

class ActingHomePage extends StatefulWidget {
  const ActingHomePage({super.key});

  @override
  State<ActingHomePage> createState() => _ActingHomePageState();
}

class _ActingHomePageState extends State<ActingHomePage> {
  int _tab = 0;

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  String get _title => switch (_tab) {
        0 => 'Carte',
        1 => 'Ma localisation',
        2 => 'Historique',
        3 => 'Compte',
        _ => 'Paramètres',
      };

  bool get _isMapTab => _tab == 0;

  PreferredSizeWidget? _buildSearchBar() {
    if (!_isMapTab) return null;

    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: SearchBar(
          hintText: 'Rechercher une zone / avenue / repère…',
          leading: const Icon(Icons.search),
          onSubmitted: (v) => _toast('Recherche: $v'),
        ),
      ),
    );
  }

  Widget _buildMapBody() {
    return Stack(
      children: [
        // Carte placeholder (MVP UI)
        Positioned.fill(
          child: Container(
            color: const Color(0xFFF2F4F7),
            child: const Center(
              child: Text(
                'Carte (placeholder)\nNext: flutter_map + markers + zones',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),

        // Boutons tactiles (overlay)
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: SafeArea(
            child: Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ActingActionButtons(
                  onSignal: () => _toast('Signaler (vert)'),
                  onHelp: () => _toast('Demander aide (orange)'),
                  onUrgent: () => _toast('Danger imminent (rouge)'),
                  onVigilance: () => _toast('Point de vigilance'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderPage({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return switch (_tab) {
      0 => _buildMapBody(),
      1 => _buildPlaceholderPage(
          icon: Icons.my_location_outlined,
          title: 'Ma localisation',
          subtitle: 'MVP: permission GPS + coordonnées + état précision.',
        ),
      2 => _buildPlaceholderPage(
          icon: Icons.history_outlined,
          title: 'Historique',
          subtitle: 'MVP: liste de tes signalements.',
        ),
      3 => _buildPlaceholderPage(
          icon: Icons.account_circle_outlined,
          title: 'Compte',
          subtitle: 'MVP: alias, titre, informations du compte.',
        ),
      _ => _buildPlaceholderPage(
          icon: Icons.settings_outlined,
          title: 'Paramètres',
          subtitle: 'MVP: préférences, notifications, langue.',
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SEC-DRC • Acting • $_title'),
        actions: [
          IconButton(
            tooltip: 'Infos',
            onPressed: () => _toast('Infos (MVP)'),
            icon: const Icon(Icons.info_outline),
          ),
          IconButton(
            tooltip: 'Compte',
            onPressed: () => setState(() => _tab = 3),
            icon: const Icon(Icons.account_circle_outlined),
          ),
          IconButton(
            tooltip: 'Paramètres',
            onPressed: () => setState(() => _tab = 4),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
        bottom: _buildSearchBar(),
      ),
      body: _buildBody(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Carte'),
          NavigationDestination(
            icon: Icon(Icons.my_location_outlined),
            label: 'Localisation',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            label: 'Historique',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Compte',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }
}
