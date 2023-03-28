import './app_db.dart';
import '../../utils/custom_key.dart';
import '../../models/transaction_model.dart';

Future<TransactionItem> dbCreateTransactionItem(
    TransactionItem transactionItem) async {
  final db = await AppDatabase.database;
  final _key = await db.insert(tableTransactionItems, transactionItem.toJson());
  return transactionItem.copy(
    dbKey: _key.toString(),
  );
}

Future<Map<CustomKey, TransactionItem>> dbReadTransactionItems(
    CustomKey transactionKey) async {
  Map<CustomKey, TransactionItem> transactionItems = {};
  final db = await AppDatabase.database;
  final result = await db.query(
    tableTransactionItems,
    columns: TransactionItemFields.values,
    where: '${TransactionItemFields.transactionKey} = ?',
    whereArgs: [transactionKey.key],
  );
  result.forEach(
    (json) {
      final TransactionItem transactionItem =
          TransactionItem.fromJson(json, transactionKey);
      transactionItems.addEntries(
        {
          MapEntry(
            transactionItem.transactionItemKey,
            transactionItem,
          ),
        },
      );
    },
  );
  return transactionItems;
}
