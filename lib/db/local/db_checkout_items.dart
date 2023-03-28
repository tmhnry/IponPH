import 'dart:convert';

import './app_db.dart';
import '../../utils/custom_key.dart';
import '../../models/checkout_item_model.dart';

// MapEntry<CustomKey, Object> _checkoutItemsEntry(Map<String, Object?> json) {
//   final CheckoutItemModel checkoutItem = CheckoutItemModel.fromJson(json);
//   return MapEntry(
//     checkoutItem.checkoutItemKey,
//     checkoutItem,
//   );
// }

Map<CustomKey, CheckoutItemModel> _checkoutItems(
    List<Map<String, Object?>> jsonList) {
  Map<CustomKey, CheckoutItemModel> checkoutItems = {};
  jsonList
      .forEach((json) => checkoutItems.addEntries({_checkoutItemsEntry(json)}));
  return checkoutItems;
}

MapEntry<CustomKey, CheckoutItemModel> _checkoutItemsEntry(
    Map<String, Object?> json) {
  final CheckoutItemModel checkoutItem = CheckoutItemModel.fromJson(json);
  return MapEntry(
    checkoutItem.checkoutItemKey,
    checkoutItem,
  );
}

Future<CheckoutItemModel> dbCreateCheckoutItem(
    CheckoutItemModel checkoutItem) async {
  final db = await AppDatabase.database;
  final _key = await db.insert(tableCheckoutItems, checkoutItem.toJson());
  return checkoutItem.copy(dbKey: _key.toString());
}

Future<Map<CustomKey, CheckoutItemModel>> dbReadAllCheckoutItems() async {
  final db = await AppDatabase.database;
  final orderBy = '${CheckoutItemFields.dateOfCheckoutItemKey} ASC';
  return _checkoutItems(await db.query(tableCheckoutItems, orderBy: orderBy));
}

// Future<Map<CustomKey, CheckoutItemModel>> dbReadAllCheckoutItems() async {
//   final db = await AppDatabase.database;
//   final orderBy = '${CheckoutItemFields.dateOfCheckoutItemKey} ASC';
//   return cFuncCustomMap(
//     await db.query(tableCheckoutItems, orderBy: orderBy),
//     _checkoutItemsEntry,
//   ) as Map<CustomKey, CheckoutItemModel>;
// }

Future<int> dbUpdateCheckoutItem(CheckoutItemModel checkoutItem) async {
  final db = await AppDatabase.database;
  return await db.update(
    tableCheckoutItems,
    checkoutItem.toJson(),
    where: '${CheckoutItemFields.checkoutItemKey} = ?',
    whereArgs: [checkoutItem.checkoutItemKey.key],
  );
}

Future<int> dbDeleteCheckoutItem(CheckoutItemModel checkoutItem) async {
  final db = await AppDatabase.database;
  return await db.delete(
    tableCheckoutItems,
    where: '${CheckoutItemFields.checkoutItemKey} = ?',
    whereArgs: [checkoutItem.checkoutItemKey.key],
  );
}

Future<int> dbDeleteAllCheckoutItems() async {
  return await AppDatabase.delete(table: tableCheckoutItems);
}
