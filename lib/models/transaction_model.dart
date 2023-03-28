import 'package:flutter/foundation.dart';
import './inventory_item_model.dart';
import './employee_model.dart';
import './customer_model.dart';
import './checkout_item_model.dart';
import '../db/local/db_transactions.dart';
import '../db/local/db_transaction_items.dart';
import '../utils/custom_functions.dart';
import '../utils/custom_key.dart';
import '../utils/helpers.dart';

final String tableTransactionItems = 'transactionItems';
final String tableTransactions = 'transactions';

class TransactionFields {
  static final List<String> values = [
    transactionKey,
    customerID,
    employeeID,
    amountPaid,
    customerDiscount,
    dateOfTransactionKey,
  ];

  static final String transactionKey = '_transactionKey';
  static final String customerID = 'customerID';
  static final String employeeID = 'employeeID';
  static final String amountPaid = 'amountPaid';
  static final String customerDiscount = 'customerDiscount';
  static final String dateOfTransactionKey = 'dateOfTransactionKey';
}

class TransactionItemFields {
  static final List<String> values = [
    transactionItemKey,
    transactionKey,
    itemID,
    itemName,
    itemPrice,
    transactionQuantity,
    dateOfTransactionItemKey,
  ];

  static final String transactionItemKey = '_transactionItemKey';
  static final String transactionKey = 'transactionKey';
  static final String itemID = 'itemID';
  static final String itemName = 'itemName';
  static final String itemPrice = 'itemPrice';
  static final String transactionQuantity = 'transactionQuantity';
  static final String dateOfTransactionItemKey = 'dateOfTransactionItemKey';
}

class TransactionItem {
  final CustomKey transactionItemKey;
  final CustomKey transactionKey;
  final CustomKey itemID;
  final int transactionQuantity;
  final double itemPrice;
  final String itemName;

  DateTime get dateOfTransactionItemKey => transactionItemKey.date;

  double get totalAmount => itemPrice * transactionQuantity;

  TransactionItem({
    required this.transactionItemKey,
    required this.transactionKey,
    required this.itemID,
    required this.itemName,
    required this.itemPrice,
    required this.transactionQuantity,
  });

  static TransactionItem fromJson(
      Map<String, Object?> json, CustomKey transactionKey) {
    return TransactionItem(
      transactionItemKey: CustomKey.create(
        key: json[TransactionItemFields.itemID] as String,
        date: DateTime.parse(
            json[TransactionItemFields.dateOfTransactionItemKey] as String),
      ),
      transactionKey: transactionKey,
      itemID: InventoryItems.inventoryItemFromIDString(
        json[TransactionItemFields.itemID] as String,
      ).itemID,
      itemName: json[TransactionItemFields.itemName] as String,
      itemPrice: double.parse(json[TransactionItemFields.itemPrice] as String),
      transactionQuantity:
          json[TransactionItemFields.transactionQuantity] as int,
    );
  }

  TransactionItem copy({
    String? dbKey,
    CustomKey? dbtxKey,
    CustomKey? dbProductID,
    String? dbName,
    double? dbPrice,
    int? dbQuantity,
    DateTime? dbDate,
  }) =>
      TransactionItem(
        transactionItemKey: CustomKey.create(
          key: dbKey ?? transactionItemKey.key,
          date: dbDate ?? dateOfTransactionItemKey,
        ),
        transactionKey: dbtxKey ?? transactionKey,
        itemID: dbProductID ?? itemID,
        itemName: dbName ?? itemName,
        itemPrice: dbPrice ?? itemPrice,
        transactionQuantity: dbQuantity ?? transactionQuantity,
      );

  Map<String, Object?> toJson() {
    return {
      TransactionItemFields.transactionItemKey: transactionItemKey.key,
      TransactionItemFields.transactionKey: transactionKey.key,
      TransactionItemFields.itemID: itemID,
      TransactionItemFields.itemName: itemName,
      TransactionItemFields.itemPrice: itemPrice.toString(),
      TransactionItemFields.transactionQuantity: transactionQuantity,
      TransactionItemFields.dateOfTransactionItemKey:
          dateOfTransactionItemKey.toIso8601String(),
    };
  }
}

class TransactionModel {
  TransactionModel({
    required this.transactionKey,
    required this.transactionItems,
    required this.customerID,
    required this.employeeID,
    required this.customerDiscount,
    required this.amountPaid,
  });
  final CustomKey transactionKey;
  final CustomKey customerID;
  final CustomKey employeeID;
  final double customerDiscount;
  final double amountPaid;
  final Map<CustomKey, TransactionItem> transactionItems;

  DateTime get dateOfTransactionKey => transactionKey.date;

  double get accountsReceivable =>
      totalAmount * (1 - customerDiscount) - amountPaid;

  double get totalAmount {
    double _total = 0;
    transactionItems.forEach((key, value) {
      _total += value.itemPrice * value.transactionQuantity;
    });
    return _total;
  }

  static Future<TransactionModel> fromJson(Map<String, Object?> json) async {
    final CustomKey transactionKey = CustomKey.create(
      key: json[TransactionFields.transactionKey] as String,
      date: DateTime.parse(
        json[TransactionFields.dateOfTransactionKey] as String,
      ),
    );
    return TransactionModel(
      transactionKey: transactionKey,
      transactionItems: await dbReadTransactionItems(transactionKey),
      customerID: Customers.customerFromIDString(
        json[TransactionFields.customerID] as String,
      ).customerID,
      employeeID: Employees.employeeFromIDString(
        json[TransactionFields.employeeID] as String,
      ).employeeID,
      customerDiscount: double.parse(
        json[TransactionFields.customerDiscount] as String,
      ),
      amountPaid: double.parse(
        json[TransactionFields.amountPaid] as String,
      ),
    );
  }

  TransactionModel copy({
    String? dbKey,
    CustomKey? dbCustomerID,
    CustomKey? dbemployeeID,
    Map<CustomKey, TransactionItem>? dbTransactionItems,
    double? dbDiscount,
    double? dbAmountPaid,
    DateTime? dbDate,
  }) =>
      TransactionModel(
        transactionKey: CustomKey.create(
          key: dbKey ?? transactionKey.key,
          date: dbDate ?? dateOfTransactionKey,
        ),
        transactionItems: dbTransactionItems ?? transactionItems,
        customerID: dbCustomerID ?? customerID,
        employeeID: dbemployeeID ?? employeeID,
        customerDiscount: dbDiscount ?? customerDiscount,
        amountPaid: dbAmountPaid ?? amountPaid,
      );

  Map<String, Object?> toJson() {
    return {
      TransactionFields.transactionKey: transactionKey.key,
      TransactionFields.customerID: customerID.key,
      TransactionFields.employeeID: employeeID.key,
      TransactionFields.amountPaid: amountPaid.toString(),
      TransactionFields.customerDiscount: customerDiscount.toString(),
      TransactionFields.dateOfTransactionKey:
          dateOfTransactionKey.toIso8601String(),
    };
  }
}

class Transactions with ChangeNotifier {
  static final Transactions instance = Transactions._init();
  Transactions._init();

  Map<CustomKey, TransactionModel> _transactions = {};
  Map<CustomKey, TransactionItem> _transactionItems = {};
  Map<CustomKey, TransactionModel> get transactions => {..._transactions};

  Map<CustomKey, TransactionItem> get transactionItems =>
      {..._transactionItems};

  static List<TransactionModel> transactionsByDate({
    DateTime? baseDate,
    required Frequency frequency,
  }) =>
      instance.transactions.values
          .where(
            (transaction) => cFuncObjectIsAfterDate(
              b: baseDate,
              d: transaction.dateOfTransactionKey,
              f: frequency,
            ),
          )
          .toList();

  static List<TransactionModel> transactionsFromSearch({
    String search = '',
    Frequency? frequency,
  }) {
    if (frequency == null) frequency = Frequency.AllTime;
    if (search.isEmpty)
      return transactionsByDate(frequency: frequency);
    else
      return transactionsByDate(frequency: frequency)
          .where(
            (transaction) => cFuncContainsString(
              l: [
                transaction.dateOfTransactionKey.toIso8601String(),
                transaction.totalAmount.toString(),
                transaction.amountPaid.toString(),
                Employees.employeeFromIDString(transaction.employeeID.key)
                    .employeeName,
                Customers.customerFromIDString(transaction.customerID.key)
                    .customerName,
              ],
              s: search,
            ),
          )
          .toList();
  }

  static Future<MapEntry<CustomKey, TransactionItem>> createTransactionItem({
    required CheckoutItemModel checkoutItem,
    required CustomKey transactionKey,
  }) async {
    CustomKey transactionItemKey = CustomKeyMethods.filterEight(
      cFuncGetKeyStrings(
        instance.transactionItems,
      ),
    );
    final CustomKey itemID = checkoutItem.inventoryItem.itemID;
    final String itemName = checkoutItem.inventoryItem.itemName;
    final double itemPrice = checkoutItem.inventoryItem.itemPrice;
    final int transactionQuantity = checkoutItem.checkoutItemQuantity;
    final TransactionItem transactionItem = TransactionItem(
      transactionItemKey: transactionItemKey,
      transactionKey: transactionKey,
      itemID: itemID,
      itemName: itemName,
      itemPrice: itemPrice,
      transactionQuantity: transactionQuantity,
    );

    await dbCreateTransactionItem(transactionItem);
    final MapEntry<CustomKey, TransactionItem> transactionItemEntry =
        MapEntry(transactionItemKey, transactionItem);
    instance._transactionItems.addEntries(
      {transactionItemEntry},
    );
    return transactionItemEntry;
  }

  static Future<void> createTransaction({
    List<CheckoutItemModel>? checkoutList,
    required CustomKey customerID,
    required CustomKey employeeID,
    required double amountPaid,
    required double discount,
  }) async {
    if (checkoutList == null) checkoutList = [];
    CustomKey transactionKey = CustomKeyMethods.filterSixteen(
      cFuncGetKeyStrings(instance.transactions),
    );
    Map<CustomKey, TransactionItem> _transactionItems = {};
    for (int i = 0; i < checkoutList.length; i++) {
      MapEntry<CustomKey, TransactionItem> transactionItemEntry =
          await createTransactionItem(
        checkoutItem: checkoutList[i],
        transactionKey: transactionKey,
      );
      _transactionItems.addEntries(
        {
          transactionItemEntry,
        },
      );
    }

    // forEach is not preferred over for-loop because it requires async but forEach always returns void and not a future.
    // checkoutList.forEach(
    //   (element) async {
    //     _transactionItems.addEntries(
    //       {
    //         await addTransactionItem(element),
    //       },
    //     );
    //   },
    // );
    final TransactionModel transaction = TransactionModel(
      transactionKey: transactionKey,
      customerID: customerID,
      employeeID: employeeID,
      amountPaid: amountPaid,
      customerDiscount: discount,
      transactionItems: _transactionItems,
    );
    await dbCreateTransaction(transaction);
    instance._transactions.addEntries(
      {
        MapEntry(transactionKey, transaction),
      },
    );
  }
}
