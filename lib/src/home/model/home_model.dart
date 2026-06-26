// Model khusus untuk kebutuhan HomeView
// Dirakit oleh HomeProvider dari entity yang ada di database
// HomeView tidak perlu tahu soal TransactionEntity atau CategoryEntity

import 'package:flutter/material.dart';

import '../../../database/entity/category_entity.dart';
import '../../../database/entity/transaction_entity.dart';

class TransactionItem {
  final String id;
  final String label; // nama kategori
  final String icon; // dari CategoryEntity
  final Color color; // dari CategoryEntity
  final double amount;
  final DateTime date;
  final String? note;
  final TransactionType type;

  TransactionItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.amount,
    required this.date,
    this.note,
    required this.type,
  });

  // Dirakit dari dua entity sekaligus
  factory TransactionItem.fromEntities(
    TransactionEntity tx,
    CategoryEntity category,
  ) {
    return TransactionItem(
      id: tx.id,
      label: category.name,
      icon: category.icon,
      color: category.bgColor,
      amount: tx.amount,
      date: tx.date,
      note: tx.note,
      type: tx.type,
    );
  }
}

class HomeModel {
  final String userName;
  final String? userAvatar;
  final double balance; // initialBalance + income - expense
  final double totalIncome;
  final double totalExpense;
  final List<TransactionItem> todayTransactions;

  HomeModel({
    required this.userName,
    this.userAvatar,
    required this.balance,
    required this.totalIncome,
    required this.totalExpense,
    required this.todayTransactions,
  });

  double get todayTransactionTotal =>
      todayTransactions.fold(0, (sum, e) => sum + e.amount);
}
