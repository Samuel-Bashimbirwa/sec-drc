import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../common/storage_service.dart';
import '../../../auth/controller/auth_controller.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();
    final auth = Get.find<AuthController>();
    final user = storage.user;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Profile
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        (user?.firstName?.isNotEmpty == true) 
                            ? user!.firstName![0].toUpperCase() 
                            : '?',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          onPressed: () {}, // Action future
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '${user?.firstName ?? ""} ${user?.lastName ?? ""}'.trim().isEmpty 
                      ? "Utilisateur" 
                      : '${user?.firstName} ${user?.lastName}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  user?.email ?? "",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Section Personal Info
          _buildSectionTitle('Informations personnelles'),
          _buildInfoCard([
            _buildInfoTile(Icons.person_outline, 'Prénom', user?.firstName ?? 'N/A'),
            _buildInfoTile(Icons.person, 'Nom', user?.lastName ?? 'N/A'),
            _buildInfoTile(Icons.cake_outlined, 'Date de naissance', _formatDate(user?.birthDate)),
          ]),
          const SizedBox(height: 24),

          // Section Address
          _buildSectionTitle('Localisation de référence'),
          _buildInfoCard([
            _buildInfoTile(Icons.home_outlined, 'Adresse', user?.addressReference ?? 'N/A'),
          ]),
          const SizedBox(height: 24),

          // Section Account
          _buildSectionTitle('Compte'),
          _buildInfoCard([
            _buildInfoTile(Icons.security, 'Rôle', user?.role ?? 'USER'),
            _buildInfoTile(Icons.calendar_today_outlined, 'Membre depuis', _formatDate(user?.createdAt)),
            _buildInfoTile(Icons.fingerprint, 'ID Sec-DRC', user?.id.substring(0, 8) ?? '---'),
          ]),

          const SizedBox(height: 48),

          ElevatedButton.icon(
            onPressed: () => auth.logout(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.1),
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Se déconnecter', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade700, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
      dense: true,
    );
  }
}
