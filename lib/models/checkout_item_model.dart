import 'package:flutter/foundation.dart';
import './inventory_item_model.dart';
import '../db/local/db_checkout_items.dart';
import '../utils/custom_key.dart';
import '../utils/custom_functions.dart';

final String tableCheckoutItems = 'checkoutItems';
Future<void> readAllCheckoutItems() async {
  CheckoutItems.instance._checkoutItems = await dbReadAllCheckoutItems();
}

class CheckoutItemFields {
  static final List<String> values = [
    checkoutItemKey,
    itemID,
    checkoutItemQuantity,
    dateOfCheckoutItemKey,
  ];
  static final checkoutItemKey = '_checkoutItemKey';
  static final itemID = 'itemID';
  static final checkoutItemQuantity = 'checkoutItemQuantity';
  static final dateOfCheckoutItemKey = 'dateOfCheckoutItemKey';
}

class CheckoutItemModel {
  final CustomKey checkoutItemKey;
  final InventoryItemModel inventoryItem;
  final int checkoutItemQuantity;

  DateTime get dateOfCheckoutItemKey => this.checkoutItemKey.date;
  double get checkoutItemAmount =>
      this.inventoryItem.itemPrice * checkoutItemQuantity;

  CheckoutItemModel({
    required this.checkoutItemKey,
    required this.inventoryItem,
    required this.checkoutItemQuantity,
  });

  static CheckoutItemModel fromJson(Map<String, Object?> json) =>
      CheckoutItemModel(
        checkoutItemKey: CustomKey.create(
          key: json[CheckoutItemFields.checkoutItemKey] as String,
          date: DateTime.parse(
              json[CheckoutItemFields.dateOfCheckoutItemKey] as String),
        ),
        inventoryItem: InventoryItems.inventoryItemFromIDString(
          json[CheckoutItemFields.itemID] as String,
        ),
        checkoutItemQuantity:
            json[CheckoutItemFields.checkoutItemQuantity] as int,
      );
  CheckoutItemModel copy({
    String? dbKey,
    InventoryItemModel? dbInventoryItem,
    int? dbQuantity,
    DateTime? dbDate,
  }) =>
      CheckoutItemModel(
        checkoutItemKey: CustomKey.create(
          key: dbKey ?? checkoutItemKey.key,
          date: dbDate ?? dateOfCheckoutItemKey,
        ),
        inventoryItem: dbInventoryItem ?? inventoryItem,
        checkoutItemQuantity: dbQuantity ?? checkoutItemQuantity,
      );

  Map<String, Object?> toJson() => {
        CheckoutItemFields.checkoutItemKey: checkoutItemKey.key,
        CheckoutItemFields.itemID: inventoryItem.itemID.key,
        CheckoutItemFields.dateOfCheckoutItemKey:
            dateOfCheckoutItemKey.toIso8601String(),
        CheckoutItemFields.checkoutItemQuantity: checkoutItemQuantity,
      };
}

class CheckoutItems with ChangeNotifier {
  static final CheckoutItems instance = CheckoutItems._init();
  CheckoutItems._init();
  Map<CustomKey, CheckoutItemModel> _checkoutItems = {};
  Map<CustomKey, CheckoutItemModel> get checkoutItems => {..._checkoutItems};

  static List<CheckoutItemModel> get checkoutList =>
      instance.checkoutItems.values.toList();

  static double totalCheckoutAmount() {
    double total = 0.00;
    checkoutList.forEach(
      (checkoutItem) => total += checkoutItem.checkoutItemAmount,
    );
    return total;
  }

  static CheckoutItemModel checkoutItemFromKey(CustomKey checkoutItemKey) =>
      checkoutList.firstWhere(
        (checkoutItem) => checkoutItem.checkoutItemKey == checkoutItemKey,
      );

  static double getChange(double amount) => totalCheckoutAmount() - amount;

  static Future<void> createCheckoutItem({
    required InventoryItemModel inventoryItem,
    required int checkoutItemQuantity,
  }) async {
    CustomKey checkoutItemKey = CustomKeyMethods.filterEight(
      cFuncGetKeyStrings(
        instance.checkoutItems,
      ),
    );

    final CheckoutItemModel checkoutItem = CheckoutItemModel(
      checkoutItemKey: checkoutItemKey,
      inventoryItem: inventoryItem,
      checkoutItemQuantity: checkoutItemQuantity,
    );
    await dbCreateCheckoutItem(checkoutItem);

    instance._checkoutItems.addEntries(
      {
        MapEntry(checkoutItemKey, checkoutItem),
      },
    );
    instance.notifyListeners();
  }

  static Future<void> deleteCheckoutItem(CustomKey checkoutItemKey) async {
    final int intAffected = await dbDeleteCheckoutItem(
      checkoutItemFromKey(
        checkoutItemKey,
      ),
    );
    if (intAffected > 0) {
      instance._checkoutItems.remove(checkoutItemKey);
      instance.notifyListeners();
    }
  }

  static Future<void> deleteAllCheckoutItems() async {
    final int intAffected = await dbDeleteAllCheckoutItems();
    if (intAffected > 0) {
      instance._checkoutItems.clear();
      instance.notifyListeners();
    }
  }
}
