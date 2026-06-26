import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../component/custom_button.dart';
import '../provider/auth_provider.dart';
import 'register_view.dart';
import 'widget/auth_textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    // Kalau akun terkunci, langsung block tanpa hit service
    final auth = context.read<AuthProvider>();
    if (auth.isLocked) {
      final remaining =
          auth.lockedUntil!.difference(DateTime.now()).inMinutes + 1;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Akun terkunci. Coba lagi dalam $remaining menit'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final success = await auth.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Login gagal'),
          backgroundColor: auth.isLocked ? Colors.orange : Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                // ===== HEADER =====
                const Text(
                  'Selamat Datang 👋',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Silakan login untuk melanjutkan',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 40),

                // ===== FORM =====
                AuthTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'contoh@email.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Masukkan password',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 8) {
                      return 'Password minimal 8 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ===== INFO GAGAL LOGIN =====
                // Muncul hanya kalau ada percobaan gagal
                if (auth.failedAttempts > 0) ...[
                  _LoginWarningBanner(auth: auth),
                  const SizedBox(height: 16),
                ],

                const SizedBox(height: 16),

                // ===== BUTTON =====
                CustomButton.mainButton(
                  label: 'Login',
                  onPressed: auth.isLocked ? null : _onLogin,
                  isLoading: auth.isLoading,
                ),
                const SizedBox(height: 16),

                // ===== REGISTER LINK =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterView()),
                      ),
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ===== WIDGET BANNER WARNING =====
class _LoginWarningBanner extends StatelessWidget {
  final AuthProvider auth;

  const _LoginWarningBanner({required this.auth});

  @override
  Widget build(BuildContext context) {
    final isLocked = auth.isLocked;
    final color = isLocked ? Colors.orange : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isLocked ? Icons.lock_clock : Icons.warning_amber_rounded,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isLocked
                  ? 'Akun terkunci hingga ${_formatTime(auth.lockedUntil!)}'
                  : 'Password salah ${auth.failedAttempts}x. '
                        'Sisa ${5 - auth.failedAttempts} percobaan',
              style: TextStyle(fontSize: 13, color: color),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
