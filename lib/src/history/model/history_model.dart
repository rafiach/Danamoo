import '../../../database/entity/category_entity.dart';
import '../../../database/entity/transaction_entity.dart';

// This model is a combination of a transaction and its category details,
// specifically for display purposes in the history list.
class HistoryListItem {
  final TransactionEntity transaction;
  final CategoryEntity? category;

  HistoryListItem({required this.transaction, this.category});
}
