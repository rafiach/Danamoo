import '../../../database/entity/transaction_entity.dart';
import '../../../database/entity/category_entity.dart';

class TransactionFormData {
  final List<CategoryEntity> incomeCategories;
  final List<CategoryEntity> expenseCategories;

  TransactionFormData({
    required this.incomeCategories,
    required this.expenseCategories,
  });

  List<CategoryEntity> categoriesFor(TransactionType type) {
    return type == TransactionType.income
        ? incomeCategories
        : expenseCategories;
  }
}
