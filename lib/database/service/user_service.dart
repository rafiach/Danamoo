import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/user_entity.dart';
import '../../data/storage_service.dart';

class UserService {
  static const _keyUsers = 'registered_users';
  final StorageService _storage;

  UserService(this._storage);

  // ================= GET CURRENT =================
  UserEntity? getCurrentUser() {
    final json = _storage.getUser();
    if (json == null) return null;
    return UserEntity.fromJson(json);
  }

  // ================= UPDATE =================
  Future<bool> update(UserEntity updated) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_keyUsers);
      final List<dynamic> users = raw != null ? jsonDecode(raw) : [];

      final index = users.indexWhere((u) => u['id'] == updated.id);
      if (index == -1) return false;

      users[index] = updated.toJson();
      await prefs.setString(_keyUsers, jsonEncode(users));

      // Update sesi aktif juga
      await _storage.saveUser(updated.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }

  // ================= UPDATE INITIAL BALANCE =================
  Future<bool> updateInitialBalance(String userId, double amount) async {
    final user = getCurrentUser();
    if (user == null || user.id != userId) return false;

    return update(
      user.copyWith(initialBalance: amount, updatedAt: DateTime.now()),
    );
  }
}
