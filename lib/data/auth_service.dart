import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../database/entity/user_entity.dart';
import '../src/auth/model/auth_model.dart';
import '../src/auth/provider/auth_result.dart';
import 'storage_service.dart';

class AuthService {
  final StorageService _storage;

  AuthService(this._storage);

  // ================= REGISTER =================
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final firebaseUser = credential.user;
      if (firebaseUser == null) throw Exception('Gagal membuat akun');

      // Simpan nama (display name) ke profil Firebase Auth
      await firebaseUser.updateDisplayName(name);

      final now = DateTime.now();
      final newUser = UserEntity(
        id: firebaseUser.uid, // Gunakan UID permanen dari Firebase
        name: name,
        email: email,
        createdAt: now,
        updatedAt: now,
      );

      final newAuth = AuthModel(
        id: const Uuid().v4(),
        userId: newUser.id,
        passwordHash: '', // Tidak perlu simpan password di lokal
        isLoggedIn: true,
        lastLoginAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await _storage.setLoggedIn(true);
      await _storage.saveUser(newUser.toJson());
      await _storage.saveAuth(newAuth.toJson());

      return AuthResult.ok(newUser, newAuth);
    } on FirebaseAuthException catch (e) {
      return AuthResult.fail(_handleFirebaseAuthError(e));
    } catch (e) {
      return AuthResult.fail('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // ================= LOGIN =================
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) throw Exception('Gagal login');

      final now = DateTime.now();

      // Cek apakah data user sudah ada di storage lokal
      UserEntity user;
      final localUserJson = _storage.getUser();

      if (localUserJson != null && localUserJson['id'] == firebaseUser.uid) {
        user = UserEntity.fromJson(localUserJson);
      } else {
        // Jika login dari HP baru (data lokal kosong), buat entitas sementara.
        // Karena UID-nya cocok dengan Firebase, nanti bisa di-restore ke data asli dari Firestore.
        user = UserEntity(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? 'Pengguna',
          email: firebaseUser.email ?? email,
          createdAt: now,
          updatedAt: now,
        );
      }

      final auth = AuthModel(
        id: const Uuid().v4(),
        userId: user.id,
        passwordHash: '',
        isLoggedIn: true,
        lastLoginAt: now,
        createdAt: now,
        updatedAt: now,
      );

      await _storage.setLoggedIn(true);
      await _storage.saveUser(user.toJson());
      await _storage.saveAuth(auth.toJson());

      return AuthResult.ok(user, auth);
    } on FirebaseAuthException catch (e) {
      return AuthResult.fail(_handleFirebaseAuthError(e));
    } catch (e) {
      return AuthResult.fail('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await _storage.clearAuth();
    await _storage.setLoggedIn(false);
  }

  // ================= UPDATE PROFILE =================
  Future<AuthResult> updateProfile(UserEntity updatedUser) async {
    try {
      await _storage.saveUser(updatedUser.toJson());

      final auth = getCurrentAuth();
      if (auth != null) {
        return AuthResult.ok(updatedUser, auth);
      } else {
        return AuthResult.fail('Sesi autentikasi tidak ditemukan');
      }
    } catch (e) {
      return AuthResult.fail('Gagal update profil: ${e.toString()}');
    }
  }

  // ================= HELPERS =================
  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
      case 'wrong-password':
        return 'Password yang Anda masukkan salah.';
      case 'email-already-in-use':
        return 'Email ini sudah terdaftar.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Silakan coba lagi nanti.';
      case 'invalid-credential':
        return 'Email atau password salah.';
      default:
        return e.message ?? 'Terjadi kesalahan autentikasi.';
    }
  }

  UserEntity? getCurrentUser() {
    final userJson = _storage.getUser();
    if (userJson == null) return null;
    return UserEntity.fromJson(userJson);
  }

  AuthModel? getCurrentAuth() {
    final authJson = _storage.getAuth();
    if (authJson == null) return null;
    return AuthModel.fromJson(authJson);
  }

  bool get isLoggedIn => _storage.isLoggedIn;
}
