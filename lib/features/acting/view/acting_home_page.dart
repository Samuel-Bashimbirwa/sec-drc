import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'pages/acting_map_page.dart';
import 'pages/account_page.dart';
import 'pages/my_location_page.dart';
import 'pages/history_page.dart';
import '../controller/alert_controller.dart';
import '../controller/location_controller.dart';
import '../model/alert_model.dart';
import '../widgets/acting_action_buttons.dart';

class ActingHomePage extends StatefulWidget {
  const ActingHomePage({super.key});

  @override
  State<ActingHomePage> createState() => _ActingHomePageState();
}

class _ActingHomePageState extends State<ActingHomePage> {
  int _tab = 0;
  late final AlertController _alert;
  late final LocationController _loc;

  @override
  void initState() {
    super.initState();

    // GetX : enregistrés dans les bindings
    _alert = Get.find<AlertController>();
    _loc = Get.find<LocationController>();

    // Lance la localisation (si pas déjà lancée ailleurs)
    _loc.init();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  /// Crée une alerte uniquement si on a une position
  /// (sinon on informe l’utilisateur — MVP propre)
  void _createAlertSafe(AlertType type, {String? okMsg}) {
    // `state` is an Rx<LocationState>, unwrap it first
    final LatLng? pos = _loc.state.position;

    if (pos == null) {
      _toast("Position indisponible. Active le GPS puis réessaie.");
      return;
    }

    _alert.createAlert(type: type, position: pos);
    if (okMsg != null) _toast(okMsg);
  }

  String get _title => switch (_tab) {
        0 => 'Carte',
        1 => 'Ma localisation',
        2 => 'Historique',
        3 => 'Compte',
        _ => 'Paramètres',
      };

  bool get _showSearch => _tab == 0 || _tab == 1;

  PreferredSizeWidget? _buildSearchBar() {
    if (!_showSearch) return null;

    String hint = _tab == 0 
        ? 'Rechercher une zone / avenue / repère…'
        : 'Rechercher Communes / Quartiers / Avenues…';

    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: SearchBar(
          hintText: hint,
          leading: const Icon(Icons.search),
          onSubmitted: (v) {
            _loc.search(v);
            if (_tab != 1) {
              setState(() => _tab = 1); // Switch to location tab to see results
            }
          },
        ),
      ),
    );
  }

  Widget _buildMapBody() {
    return Stack(
      children: [
        // Carte réelle
        const ActingMapPage(),

        // FAB urgence (toujours visible)
        Positioned(
          right: 12,
          bottom: 140,
          child: SafeArea(
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () => _createAlertSafe(
                AlertType.urgent,
                okMsg: "URGENCE déclenchée 🚨",
              ),
              child: const Icon(Icons.warning),
            ),
          ),
        ),

        // Panneau repliable (Signaler / Aide / Vigilance)
        DraggableScrollableSheet(
          initialChildSize: 0.12,
          minChildSize: 0.12,
          maxChildSize: 0.35,
          builder: (context, scrollController) {
            return SafeArea(
              top: false,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26,
                    )
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    child: Column(
                      children: [
                        // petit handle (UX)
                        Container(
                          width: 46,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(height: 12),

                        ActingActionButtons(
                          onSignal: () => _createAlertSafe(
                            AlertType.signal,
                            okMsg: 'Signal envoyé ✅',
                          ),
                          onHelp: () => _createAlertSafe(
                            AlertType.help,
                            okMsg: 'Aide envoyée ✅',
                          ),
                          onVigilance: () => _createAlertSafe(
                            AlertType.vigilance,
                            okMsg: 'Point de vigilance ajouté ✅',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
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
            Text(subtitle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return switch (_tab) {
      0 => _buildMapBody(),
      1 => const MyLocationPage(),
      2 => const HistoryPage(),
      3 => const AccountPage(),
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