import 'package:danamoo/database/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'data/storage_service.dart';
import 'data/notification_service.dart';
import 'database/service/transaction_service.dart';
import 'splash_view.dart';
import 'src/auth/provider/auth_provider.dart';
import 'src/auth/view/login_view.dart';
import 'data/sync_service.dart';
import 'firebase_options.dart';
import 'src/home/provider/home_provider.dart';
import 'src/home/view/home_view.dart';
import 'src/history/provider/history_provider.dart';
import 'src/profile/provider/profile_provider.dart';
import 'src/transaction/provider/transaction_provider.dart';
import 'src/insight/provider/insight_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  // Inisialisasi Sistem Notifikasi
  await NotificationService.initialize();

  // Inisialisasi Firebase
  // (Catatan: Pastikan Anda sudah menjalankan perintah `flutterfire configure`
  // untuk mengenerate file firebase_options.dart jika belum)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final storage = await StorageService.getInstance();

  runApp(MyApp(storage: storage));
}

class MyApp extends StatelessWidget {
  final StorageService storage;

  const MyApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => UserService(storage)),
        Provider(create: (_) => TransactionService()),
        Provider(
          create: (ctx) => SyncService(
            ctx.read<UserService>(),
            ctx.read<TransactionService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) =>
              AuthProvider()
                ..initService(storage, syncService: ctx.read<SyncService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) =>
              HomeProvider(transactionService: ctx.read<TransactionService>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => HistoryProvider(
            transactionService: ctx.read<TransactionService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ProfileProvider(
            userService: ctx.read<UserService>(),
            syncService: ctx.read<SyncService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TransactionProvider(
            transactionService: ctx.read<TransactionService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => InsightProvider(
            transactionService: ctx.read<TransactionService>(),
          ),
        ),
      ],
      child: MaterialApp(
        navigatorKey: NotificationService.navigatorKey,
        title: 'DanaMoo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF2196F3),
          useMaterial3: true,
          fontFamily: 'Poppins',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF212121),
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    switch (auth.status) {
      case AuthStatus.initial:
        return const SplashView();

      case AuthStatus.authenticated:
        return const HomeView();

      case AuthStatus.loading:
        // Jika user ada (sedang update profil), tetap di Home. Jika kosong (sedang login), tetap di Login.
        return auth.user != null ? const HomeView() : const LoginView();

      case AuthStatus.unauthenticated:
      case AuthStatus.error:
        return const LoginView();
    }
  }
}
