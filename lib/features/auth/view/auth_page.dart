import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/widgets/primary_button.dart';
import '../controller/auth_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final AuthController _controller = Get.find<AuthController>();

  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  DateTime? _birthDate;
  bool _isLogin = true;
  String _role = 'USER'; // USER, SUPERVISOR

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    if (email.isEmpty || pass.length < 6) {
      Get.snackbar(
        'Erreur',
        'Email invalide ou mot de passe trop court.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (_isLogin) {
      _controller.login(email, pass);
    } else {
      _controller.register(
        email: email,
        password: pass,
        role: _role,
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        birthDate: _birthDate?.toIso8601String().split('T')[0], // YYYY-MM-DD
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SEC-DRC • Accès')),
      body: Obx(() {
        if (_controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isLogin ? 'Connexion' : 'Inscription',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              if (!_isLogin) ...[
                const Text('Choisir un rôle :'),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'USER', label: Text('Acteur')),
                    ButtonSegment(
                        value: 'SUPERVISOR', label: Text('Superviseur')),
                  ],
                  selected: {_role},
                  onSelectionChanged: (s) => setState(() => _role = s.first),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _firstNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lastNameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _addressCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Adresse de référence',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.home_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date de naissance',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.cake_outlined),
                    ),
                    child: Text(
                      _birthDate == null
                          ? 'Choisir une date'
                          : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe (6 car. min)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              if (_controller.error.value != null) ...[
                const SizedBox(height: 16),
                Text(
                  _controller.error.value!,
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 32),
              PrimaryButton(
                label: _isLogin ? 'Se connecter' : 'Créer un compte',
                icon: Icons.arrow_forward,
                onPressed: _submit,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    _controller.error.value = null;
                  });
                },
                child: Text(_isLogin
                    ? "Pas de compte ? S'inscrire"
                    : "Déjà un compte ? Se connecter"),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      }),
    );
  }
}
