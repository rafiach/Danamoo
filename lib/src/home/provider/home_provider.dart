import 'package:flutter/material.dart';

import '../../../database/entity/transaction_entity.dart';
import '../../../database/entity/category_entity.dart';
import '../../../database/entity/user_entity.dart';
import '../../../database/service/transaction_service.dart';
import '../model/home_model.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  final TransactionService _transactionService;

  HomeStatus _status = HomeStatus.initial;
  HomeModel? _homeModel;
  String? _errorMessage;

  HomeProvider({required TransactionService transactionService})
    : _transactionService = transactionService;

  HomeStatus get status => _status;
  HomeModel? get homeModel => _homeModel;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == HomeStatus.loading;

  // ================= FETCH =================
  Future<void> fetchData(UserEntity user) async {
    _status = HomeStatus.loading;
    notifyListeners();

    try {
      // Ambil semua data dari service
      final transactions = await _transactionService.getAll(user.id);
      final categories = CategoryEntity.all;

      // Hitung summary
      final income = transactions
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount);

      final expense = transactions
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount);

      final balance = user.initialBalance + income - expense;

      // Filter hari ini
      final now = DateTime.now();
      final todayTx =
          transactions
              .where(
                (t) =>
                    t.date.year == now.year &&
                    t.date.month == now.month &&
                    t.date.day == now.day,
              )
              .toList()
            ..sort((a, b) => b.date.compareTo(a.date));

      // Rakit TransactionItem dari transaction + category
      final categoryMap = {for (var c in categories) c.id: c};
      final todayTransactions = todayTx
          .where((t) => categoryMap.containsKey(t.categoryId))
          .map(
            (t) => TransactionItem.fromEntities(t, categoryMap[t.categoryId]!),
          )
          .toList();

      // Simpan sebagai HomeData — provider tidak expose entity mentah ke view
      _homeModel = HomeModel(
        userName: user.name,
        userAvatar: user.avatarPath,
        balance: balance,
        totalIncome: income,
        totalExpense: expense,
        todayTransactions: todayTransactions,
      );

      _status = HomeStatus.loaded;
    } catch (e) {
      _errorMessage = 'Gagal memuat data: ${e.toString()}';
      _status = HomeStatus.error;
    }

    notifyListeners();
  }

  // ================= CLEAR =================
  void clear() {
    _homeModel = null;
    _status = HomeStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
