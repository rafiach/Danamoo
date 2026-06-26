import 'package:flutter/material.dart';

import '../../../data/auth_service.dart';
import '../../../data/storage_service.dart';
import '../../../data/sync_service.dart';
import '../../../database/entity/user_entity.dart';
import '../model/auth_model.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  late final AuthService _authService;
  SyncService? _syncService;

  AuthStatus _status = AuthStatus.initial;
  UserEntity? _user;
  AuthModel? _auth; // ← tambahan: expose auth state ke UI
  String? _errorMessage;

  AuthStatus get status => _status;
  UserEntity? get user => _user;
  AuthModel? get auth => _auth;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // ← Getter tambahan yang berguna untuk UI
  bool get isLocked => _auth?.isLocked ?? false;
  int get failedAttempts => _auth?.failedAttempts ?? 0;
  DateTime? get lockedUntil => _auth?.lockedUntil;

  // ================= INIT SERVICE =================
  void initService(StorageService storage, {SyncService? syncService}) {
    _authService = AuthService(storage);
    _syncService = syncService;
  }

  // ================= CHECK SESSION =================
  Future<void> checkSession() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (_authService.isLoggedIn) {
      _user = _authService.getCurrentUser();
      _auth = _authService.getCurrentAuth(); // ← tambahan
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }

    notifyListeners();
  }

  // ================= LOGIN =================
  Future<bool> login({required String email, required String password}) async {
    _setLoading();

    final result = await _authService.login(email: email, password: password);

    if (result.success) {
      // Lakukan restore data secara otomatis dari Cloud ke HP (jika ada)
      if (_syncService != null && result.user != null) {
        await _syncService!.restoreData(result.user!.id);
      }

      // Ambil kembali data user dari storage lokal (karena mungkin sudah ditimpa oleh data lama dari Cloud)
      _user = _authService.getCurrentUser() ?? result.user;
      _auth = result.auth; // ← tambahan
      _status = AuthStatus.authenticated;
      _errorMessage = null;
    } else {
      _auth = result.auth; // ← tetap update auth meski gagal
      _status = AuthStatus.error; //   supaya UI bisa baca failedAttempts
      _errorMessage = result.message;
    }

    notifyListeners();
    return result.success;
  }

  // ================= REGISTER =================
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading();

    final result = await _authService.register(
      name: name,
      email: email,
      password: password,
    );

    if (result.success) {
      _user = result.user;
      _auth = result.auth; // ← tambahan
      _status = AuthStatus.authenticated;
      _errorMessage = null;
    } else {
      _status = AuthStatus.error;
      _errorMessage = result.message;
    }

    notifyListeners();
    return result.success;
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    _setLoading();
    await _authService.logout();
    _user = null;
    _auth = null; // ← tambahan
    _status = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  // ================= UPDATE PROFILE =================
  // Dipanggil dari halaman edit profil
  Future<bool> updateProfile({
    String? name,
    String? currency,
    String? avatarPath,
    String? themeMode,
    bool? notifEnabled,
    String? notifTime,
  }) async {
    if (_user == null) return false;
    _setLoading();

    final updatedUser = _user!.copyWith(
      name: name,
      currency: currency,
      avatarPath: avatarPath,
      themeMode: themeMode,
      notifEnabled: notifEnabled,
      notifTime: notifTime,
      updatedAt: DateTime.now(),
    );

    final result = await _authService.updateProfile(updatedUser);

    if (result.success) {
      _user = result.user;
      _auth = result.auth;
      _status = AuthStatus.authenticated;
      _errorMessage = null;
    } else {
      _status = AuthStatus.error;
      _errorMessage = result.message;
    }

    notifyListeners();
    return result.success;
  }

  // ================= CLEAR ERROR =================
  void clearError() {
    _errorMessage = null;
    if (_status == AuthStatus.error) {
      _status = _user != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // ================= INTERNAL =================
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }
}
