import 'package:flutter/foundation.dart';
import './distribution_item_model.dart';
import './item_type_model.dart';
import '../db/local/db_inventory_items.dart';
import '../utils/custom_key.dart';
import '../utils/custom_functions.dart';

final String tableInventoryItems = 'inventoryItems';

Future<void> readAllInventoryItems() async {
  InventoryItems.instance._inventoryItems = await dbReadAllInventoryItems();
}

class InventoryItemFields {
  static final List<String> values = [
    itemID,
    itemName,
    itemType,
    itemPrice,
    itemQuantity,
    dateOfItemID,
  ];
  static final String itemID = '_itemID';
  static final String itemName = 'itemName';
  static final String itemType = 'itemType';
  static final String itemPrice = 'itemPrice';
  static final String itemQuantity = 'itemQuantity';
  static final String dateOfItemID = 'dateOfItemID';
}

class InventoryItemModel {
  final CustomKey itemID;
  ItemTypeModel itemType;
  String itemName;
  double itemPrice;
  int itemQuantity;

  InventoryItemModel({
    required this.itemID,
    required this.itemName,
    required this.itemType,
    required this.itemPrice,
    required this.itemQuantity,
  });

  DateTime get dateOfItemID => itemID.date;

  InventoryItemModel copy({
    String? dbID,
    String? dbItemName,
    ItemTypeModel? dbItemType,
    double? dbItemPrice,
    int? dbItemQuantity,
    DateTime? dbDate,
  }) =>
      InventoryItemModel(
        itemID: CustomKey.create(
          key: dbID ?? itemID.key,
          date: dbDate ?? dateOfItemID,
        ),
        itemName: dbItemName ?? itemName,
        itemType: dbItemType ?? itemType,
        itemPrice: dbItemPrice ?? itemPrice,
        itemQuantity: dbItemQuantity ?? itemQuantity,
      );

  static InventoryItemModel fromJson(Map<String, Object?> json) {
    return InventoryItemModel(
      itemID: CustomKey.create(
        key: json[InventoryItemFields.itemID] as String,
        date: DateTime.parse(
          json[InventoryItemFields.dateOfItemID] as String,
        ),
      ),
      itemName: json[InventoryItemFields.itemName] as String,
      itemType: ItemTypes.itemTypeFromKeyString(
        json[InventoryItemFields.itemType] as String,
      ),
      itemPrice: double.parse(
        json[InventoryItemFields.itemPrice] as String,
      ),
      itemQuantity: json[InventoryItemFields.itemQuantity] as int,
    );
  }

  Map<String, Object?> toJson() {
    return {
      InventoryItemFields.itemID: itemID.key,
      InventoryItemFields.itemType: itemType.itemTypeKey.key,
      InventoryItemFields.itemName: itemName,
      InventoryItemFields.itemPrice: itemPrice.toString(),
      InventoryItemFields.itemQuantity: itemQuantity,
      InventoryItemFields.dateOfItemID: dateOfItemID.toIso8601String(),
    };
  }
}

class InventoryItems with ChangeNotifier {
  static final InventoryItems instance = InventoryItems._init();
  InventoryItems._init();
  Map<CustomKey, InventoryItemModel> _inventoryItems = {};
  Map<CustomKey, InventoryItemModel> get inventoryItems => {..._inventoryItems};

  static InventoryItemModel inventoryItemFromID(CustomKey itemID) =>
      instance.inventoryItems.values.firstWhere(
        (inventoryItem) => itemID == inventoryItem.itemID,
      );
  static InventoryItemModel inventoryItemFromIDString(String keyString) =>
      instance.inventoryItems.values.firstWhere(
        (inventoryItem) => inventoryItem.itemID.key == keyString,
        orElse: () => throw Exception(
            'inventoryItemFromIDString: keyString $keyString not found'),
      );
  static bool inventoryItemsContainName(String itemName) =>
      instance.inventoryItems.values.any(
        (inventoryItem) => cFuncContainsString(
          l: [inventoryItem.itemName],
          s: itemName,
        ),
      );
  static String generateRandomIDString() {
    String s = cFuncGenerateString(n: 8, g: cFuncSubstringEight);
    while (cFuncGetKeyStrings(instance.inventoryItems).contains(s) &&
        DistributionItems.distributionItemsFromSearch().any(
          (distributionItem) => distributionItem.itemIDString == s,
        )) {
      s = cFuncGenerateString(n: 8, g: cFuncSubstringEight);
    }
    return s;
  }

  static bool inventoryItemsContainID(CustomKey itemID) =>
      instance.inventoryItems.values.any(
        (inventoryItem) => inventoryItem.itemID == itemID,
      );

  static bool inventoryItemsContainIDString(String itemIDString) =>
      instance.inventoryItems.values.any(
        (inventoryItem) => inventoryItem.itemID.key == itemIDString,
      );

  static List<InventoryItemModel> inventoryItemsFromSearch({
    String search = '',
  }) {
    if (search.isEmpty)
      return instance.inventoryItems.values.toList();
    else
      return instance.inventoryItems.values
          .where(
            (inventoryItem) => cFuncContainsString(
              l: [
                inventoryItem.itemName,
                inventoryItem.dateOfItemID.toIso8601String(),
                inventoryItem.itemType.itemTypeName,
              ],
              s: search,
            ),
          )
          .toList();
  }

  static Future<void> createInventoryItem({
    required String itemIDString,
    required String itemName,
    required ItemTypeModel itemType,
    required double itemPrice,
    required int itemQuantity,
  }) async {
    final CustomKey itemID = CustomKey.create(
      key: itemIDString,
      date: DateTime.now(),
    );
    final InventoryItemModel inventoryItem = InventoryItemModel(
      itemID: itemID,
      itemName: itemName,
      itemType: itemType,
      itemQuantity: itemQuantity,
      itemPrice: itemPrice,
    );

    await dbCreateInventoryItem(inventoryItem);

    instance._inventoryItems.addEntries(
      {
        MapEntry(itemID, inventoryItem),
      },
    );
    instance.notifyListeners();
  }

  static Future<void> updateInventoryItem({
    required CustomKey itemID,
    String? itemName,
    ItemTypeModel? itemType,
    double? itemPrice,
    int? itemQuantity,
  }) async {
    InventoryItemModel original = inventoryItemFromID(itemID);

    final String originalName = original.itemName;
    final ItemTypeModel originalType = original.itemType;
    final double originalPrice = original.itemPrice;
    final int originalQuantity = original.itemQuantity;

    original.itemName = itemName ?? originalName;
    original.itemType = itemType ?? originalType;
    original.itemPrice = itemPrice ?? originalPrice;
    original.itemQuantity = itemQuantity ?? originalQuantity;

    final intAffected = await dbUpdateInventoryItem(original);

    if (intAffected > 0) {
      instance.notifyListeners();
    } else {
      original.itemName = originalName;
      //  CONSEQUENCE OF UPDATING PRODUCT TYPE: UNAPPROVED FRONT DISTRIBUTION PRODUCT TYPE
      //  WILL NOT CHANGE, MIGHT CONSIDER THAT AS WELL.
      original.itemType = originalType;
      original.itemPrice = originalPrice;
      original.itemQuantity = originalQuantity;
      throw Exception(
        'updateInventoryItem: InventoryItem with itemID ${itemID.key} not found',
      );
    }
  }

  // void updateItemQuantity(InventoryItemModel item, int itemQuantity) {
  //   if (_inventoryItems.containsKey(item.itemID)) {
  //     _inventoryItems.update(item.itemID, (value) {
  //       value.itemQuantity = value.itemQuantity - itemQuantity;
  //       return value;
  //     });
  //     // This piece of code contains a bug: it creates a new inventoryItem with the same ID.
  //     // _inventoryItems.update(
  //     //   item.itemID,
  //     //   (value) => InventoryItemModel(
  //     //     itemID: item.itemID,
  //     //     itemName: value.itemName,
  //     //     itemType: value.itemType,
  //     //     itemPrice: value.itemPrice,
  //     //     itemQuantity: value.itemQuantity - itemQuantity,
  //     //   ),
  //     // );
  //     notifyListeners();
  //   } else {
  //     assert(false);
  //   }
  // }
}
