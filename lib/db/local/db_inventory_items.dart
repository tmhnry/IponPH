import './app_db.dart';
import '../../utils/custom_key.dart';
import '../../models/inventory_item_model.dart';

// MapEntry<CustomKey, Object> _inventoryItemsEntry(Map<String, Object?> json) {
//   final InventoryItemModel inventoryItem = InventoryItemModel.fromJson(json);
//   return MapEntry(
//     inventoryItem.itemID,
//     inventoryItem,
//   );
// }
Map<CustomKey, InventoryItemModel> _inventoryItems(
    List<Map<String, Object?>> jsonList) {
  Map<CustomKey, InventoryItemModel> inventoryItems = {};
  jsonList.forEach(
      (json) => inventoryItems.addEntries({_inventoryItemsEntry(json)}));
  return inventoryItems;
}

MapEntry<CustomKey, InventoryItemModel> _inventoryItemsEntry(
    Map<String, Object?> json) {
  final InventoryItemModel inventoryItem = InventoryItemModel.fromJson(json);
  return MapEntry(
    inventoryItem.itemID,
    inventoryItem,
  );
}

Future<InventoryItemModel> dbCreateInventoryItem(
    InventoryItemModel inventoryItem) async {
  final db = await AppDatabase.database;
  final _key = await db.insert(tableInventoryItems, inventoryItem.toJson());
  return inventoryItem.copy(dbID: _key.toString());
}

Future<InventoryItemModel> dbReadInventoryItem(
    InventoryItemModel inventoryItem) async {
  final db = await AppDatabase.database;
  final maps = await db.query(
    tableInventoryItems,
    columns: InventoryItemFields.values,
    where: '${InventoryItemFields.itemID} = ?',
    whereArgs: [inventoryItem.itemID.key],
  );
  if (maps.isNotEmpty) {
    return InventoryItemModel.fromJson(maps.first);
  } else {
    throw Exception(
      'dbReadInventoryItem: itemID ${inventoryItem.itemID.key} not found',
    );
  }
}

Future<Map<CustomKey, InventoryItemModel>> dbReadAllInventoryItems() async {
  final db = await AppDatabase.database;
  final orderBy = '${InventoryItemFields.dateOfItemID} ASC';
  // final result =
  //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');
  return _inventoryItems(await db.query(tableInventoryItems, orderBy: orderBy));
}

// Future<Map<CustomKey, InventoryItemModel>> dbReadAllInventoryItems() async {
//   final db = await AppDatabase.database;
//   final orderBy = '${InventoryItemFields.dateOfItemID} ASC';
//   // final result =
//   //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');
//   return cFuncCustomMap(
//     await db.query(tableInventoryItems, orderBy: orderBy),
//     _inventoryItemsEntry,
//   ) as Map<CustomKey, InventoryItemModel>;
// }

Future<int> dbUpdateInventoryItem(InventoryItemModel inventoryItem) async {
  final db = await AppDatabase.database;
  return await db.update(
    tableInventoryItems,
    inventoryItem.toJson(),
    where: '${InventoryItemFields.itemID} = ?',
    whereArgs: [inventoryItem.itemID.key],
  );
}

Future<int> dbDeleteInventoryItem(InventoryItemModel inventoryItem) async {
  final db = await AppDatabase.database;
  return await db.delete(
    tableInventoryItems,
    where: '${InventoryItemFields.itemID} = ?',
    whereArgs: [inventoryItem.itemID.key],
  );
}
