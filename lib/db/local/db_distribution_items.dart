import './app_db.dart';
import '../../utils/custom_key.dart';
import '../../models/distribution_item_model.dart';

Map<CustomKey, DistributionItemModel> _distributionItems(
    List<Map<String, Object?>> jsonList) {
  Map<CustomKey, DistributionItemModel> distributionItems = {};
  jsonList.forEach(
      (json) => distributionItems.addEntries({_distributionItemsEntry(json)}));
  return distributionItems;
}

MapEntry<CustomKey, DistributionItemModel> _distributionItemsEntry(
    Map<String, Object?> json) {
  final DistributionItemModel distributionItem =
      DistributionItemModel.fromJson(json);
  return MapEntry(
    distributionItem.distributionItemKey,
    distributionItem,
  );
}

// MapEntry<CustomKey, Object> _distributionItemsEntry(Map<String, Object?> json) {
//   final DistributionItemModel distributionItem =
//       DistributionItemModel.fromJson(json);
//   return MapEntry(
//     distributionItem.distributionItemKey,
//     distributionItem,
//   );
// }

Future<DistributionItemModel> dbCreateDistributionItem(
  DistributionItemModel distributionItem,
) async {
  final db = await AppDatabase.database;
  final _key =
      await db.insert(tableDistributionItems, distributionItem.toJson());
  return distributionItem.copy(dbKey: _key.toString());
}

Future<DistributionItemModel> dbReadDistributionItem(
  DistributionItemModel distributionItem,
) async {
  final db = await AppDatabase.database;
  final maps = await db.query(
    tableDistributionItems,
    columns: DistributionItemFields.values,
    where: '${DistributionItemFields.distributionItemKey} = ?',
    whereArgs: [distributionItem.distributionItemKey.key],
  );
  if (maps.isNotEmpty) {
    return DistributionItemModel.fromJson(maps.first);
  } else {
    throw Exception(
        'FrontDistribution Key ${distributionItem.distributionItemKey.key} not found');
  }
}

Future<Map<CustomKey, DistributionItemModel>>
    dbReadAllDistributionItems() async {
  final db = await AppDatabase.database;
  final orderBy = '${DistributionItemFields.dateOfDistributionItemKey} ASC';
  return _distributionItems(
      await db.query(tableDistributionItems, orderBy: orderBy));
}

// Future<Map<CustomKey, DistributionItemModel>>
//     dbReadAllDistributionItems() async {
//   final db = await AppDatabase.database;
//   final orderBy = '${DistributionItemFields.dateOfDistributionItemKey} ASC';
//   return cFuncCustomMap(
//     await db.query(tableDistributionItems, orderBy: orderBy),
//     _distributionItemsEntry,
//   ) as Map<CustomKey, DistributionItemModel>;
// }

Future<int> dbUpdateDistributionItem(
  DistributionItemModel distributionItem,
) async {
  final db = await AppDatabase.database;
  return await db.update(
    tableDistributionItems,
    distributionItem.toJson(),
    where: '${DistributionItemFields.distributionItemKey} = ?',
    whereArgs: [distributionItem.distributionItemKey.key],
  );
}

Future<int> dbDeleteDistributionItem(
  DistributionItemModel distributionItem,
) async {
  final db = await AppDatabase.database;
  return await db.delete(
    tableDistributionItems,
    where: '${DistributionItemFields.distributionItemKey} = ?',
    whereArgs: [distributionItem.distributionItemKey.key],
  );
}
