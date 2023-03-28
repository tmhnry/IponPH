import './app_db.dart';
import '../../utils/custom_key.dart';
import '../../models/item_type_model.dart';

Map<CustomKey, ItemTypeModel> _itemTypes(List<Map<String, Object?>> jsonList) {
  Map<CustomKey, ItemTypeModel> itemTypes = {};
  jsonList.forEach((json) => itemTypes.addEntries({_itemTypesEntry(json)}));
  return itemTypes;
}

MapEntry<CustomKey, ItemTypeModel> _itemTypesEntry(Map<String, Object?> json) {
  final ItemTypeModel itemType = ItemTypeModel.fromJson(json);
  return MapEntry(itemType.itemTypeKey, itemType);
}
// MapEntry<CustomKey, Object> _itemTypesEntry(Map<String, Object?> json) {
//   final ItemTypeModel itemType = ItemTypeModel.fromJson(json);
//   return MapEntry(itemType.itemTypeKey, itemType);
// }

Future<ItemTypeModel> dbCreateItemType(ItemTypeModel itemType) async {
  final db = await AppDatabase.database;
  final _key = await db.insert(tableItemTypes, itemType.toJson());
  return itemType.copy(dbKey: _key.toString());
}

Future<ItemTypeModel> dbReadItemType(ItemTypeModel itemType) async {
  final db = await AppDatabase.database;
  final maps = await db.query(
    tableItemTypes,
    columns: ItemTypeFields.values,
    where: '${ItemTypeFields.itemTypeKey} = ?',
    whereArgs: [itemType.itemTypeKey.key],
  );

  if (maps.isNotEmpty) {
    return ItemTypeModel.fromJson(maps.first);
  } else {
    throw Exception(
      'dbReadItemType: itemTypeKey ${itemType.itemTypeKey.key} not found',
    );
  }
}

Future<Map<CustomKey, ItemTypeModel>> dbReadAllItemTypes() async {
  final db = await AppDatabase.database;
  final orderBy = '${ItemTypeFields.dateOfItemTypeKey} ASC';
  return _itemTypes(await db.query(tableItemTypes, orderBy: orderBy));
}

// Future<Map<CustomKey, ItemTypeModel>> dbReadAllItemTypes() async {
//   final db = await AppDatabase.database;

//   final orderBy = '${ItemTypeFields.dateOfItemTypeKey} ASC';
//   // final result =
//   //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');
//   return cFuncCustomMap(
//     await db.query(tableItemTypes, orderBy: orderBy),
//     _itemTypesEntry,
//   ) as Map<CustomKey, ItemTypeModel>;
// }

Future<int> dbUpdateItemType(ItemTypeModel itemType) async {
  final db = await AppDatabase.database;
  return await db.update(
    tableItemTypes,
    itemType.toJson(),
    where: '${ItemTypeFields.itemTypeKey} = ?',
    whereArgs: [itemType.itemTypeKey.key],
  );
}

Future<int> dbDeleteItemType(ItemTypeModel itemType) async {
  final db = await AppDatabase.database;
  return await db.delete(
    tableItemTypes,
    where: '${ItemTypeFields.itemTypeKey} = ?',
    whereArgs: [itemType.itemTypeKey.key],
  );
}
