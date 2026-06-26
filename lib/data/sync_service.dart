import 'package:cloud_firestore/cloud_firestore.dart';

import '../database/entity/transaction_entity.dart';
import '../database/entity/user_entity.dart';
import '../database/service/transaction_service.dart';
import '../database/service/user_service.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService;
  final TransactionService _transactionService;

  SyncService(this._userService, this._transactionService);

  Future<bool> backupData(String userId) async {
    try {
      final user = _userService.getCurrentUser();
      if (user == null || user.id != userId) return false;

      // Backup Data User
      final userRef = _firestore.collection('users').doc(userId);
      await userRef.set(user.toJson());

      // Backup Semua Transaksi secara batch
      final transactions = await _transactionService.getAll(userId);
      final batch = _firestore.batch();

      final txCollection = userRef.collection('transactions');
      for (var tx in transactions) {
        batch.set(txCollection.doc(tx.id), tx.toJson());
      }

      await batch.commit();

      // Update waktu last backup secara lokal
      final updatedUser = user.copyWith(lastBackupAt: DateTime.now());
      await _userService.update(updatedUser);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> restoreData(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userDoc = await userRef.get();

      if (!userDoc.exists || userDoc.data() == null) return false;

      // Restore User
      final user = UserEntity.fromJson(userDoc.data()!);
      await _userService.update(user);

      // Restore Transaksi
      final txSnapshot = await userRef.collection('transactions').get();
      final transactions = txSnapshot.docs
          .map((doc) => TransactionEntity.fromJson(doc.data()))
          .toList();
      await _transactionService.saveAll(userId, transactions);

      return true;
    } catch (e) {
      return false;
    }
  }
}
