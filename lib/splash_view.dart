import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/auth/provider/auth_provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    // Jalankan keduanya bersamaan:
    // checkSession() → cek SharedPreferences (cepat)
    // Future.delayed → pastikan splash minimal 2 detik
    // Setelah keduanya selesai, AuthWrapper otomatis
    // rebuild karena status di AuthProvider sudah berubah
    await Future.wait([
      context.read<AuthProvider>().checkSession(),
      Future.delayed(const Duration(seconds: 2)),
    ]);
    // Tidak perlu Navigator.push apapun di sini —
    // AuthWrapper yang handle perpindahan halaman
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 80),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
