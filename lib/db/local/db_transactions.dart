import './app_db.dart';
import '../../utils/custom_key.dart';
import '../../models/customer_model.dart';
import '../../models/transaction_model.dart';

Future<TransactionModel> dbCreateTransaction(
    TransactionModel transaction) async {
  final db = await AppDatabase.database;
  final _key = await db.insert(tableTransactions, transaction.toJson());
  return transaction.copy(
    dbKey: _key.toString(),
  );
}

Future<Map<CustomKey, TransactionModel>> dbReadAllTransactions() async {
  Map<CustomKey, TransactionModel> transactions = {};
  final db = await AppDatabase.database;
  final orderBy = '${TransactionFields.dateOfTransactionKey} ASC';
  final result = await db.query(tableTransactions, orderBy: orderBy);
  for (int i = 0; i < result.length; i++) {
    final TransactionModel transaction = await TransactionModel.fromJson(
      result[i],
    );
    MapEntry<CustomKey, TransactionModel> transactionEntry = MapEntry(
      transaction.transactionKey,
      transaction,
    );
    transactions.addEntries(
      {
        transactionEntry,
      },
    );
    final CustomerModel? customer =
        Customers.instance.customers[transaction.customerID];
    if (customer != null)
      customer.customerTransactions.addEntries(
        {
          transactionEntry,
        },
      );
    else
      throw Exception(
        'AppDatabase readAllTransactions: customer evaluated to null',
      );
  }
  return transactions;
}
