import 'package:flutter/foundation.dart';
import './employee_model.dart';
import './item_type_model.dart';
import '../db/local/db_distribution_items.dart';
import '../utils/custom_key.dart';
import '../utils/custom_functions.dart';
import '../utils/helpers.dart';

final String tableDistributionItems = 'distributionItems';
Future<void> readAllDistributionItems() async =>
    DistributionItems.instance._distributionItems =
        await dbReadAllDistributionItems();

class DistributionItemFields {
  static final List<String> values = [
    distributionItemKey,
    itemIDString,
    itemType,
    itemName,
    itemReceiver,
    itemDistributor,
    itemPrice,
    itemCost,
    itemQuantity,
    dateOfDistributionItemKey,
    isAdded,
  ];

  static final String distributionItemKey = '_distributionItemKey';
  static final String itemIDString = 'itemIDString';
  static final String itemType = 'itemType';
  static final String itemName = 'itemName';
  static final String itemReceiver = 'itemRecevier';
  static final String itemDistributor = 'itemDistributor';
  static final String itemPrice = 'itemPrice';
  static final String itemCost = 'itemCost';
  static final String itemQuantity = 'itemQuantity';
  static final String dateOfDistributionItemKey = 'dateOfDistributionItemKey';
  static final String isAdded = 'isAdded';
}

class DistributionItemModel {
  final CustomKey distributionItemKey;
  final String itemIDString;
  ItemTypeModel itemType;
  CustomKey itemReceiver;
  String itemName;
  String itemDistributor;
  double itemPrice;
  double itemCost;
  int itemQuantity;
  bool isAdded;

  DateTime get dateOfDistributionItemKey => distributionItemKey.date;

  DistributionItemModel({
    required this.distributionItemKey,
    required this.itemIDString,
    required this.itemName,
    required this.itemReceiver,
    required this.itemDistributor,
    required this.itemType,
    required this.itemPrice,
    required this.itemCost,
    required this.itemQuantity,
    required this.isAdded,
  });

  DistributionItemModel copy({
    String? dbKey,
    String? dbItemIDString,
    CustomKey? dbReceiver,
    ItemTypeModel? dbItemType,
    String? dbItemName,
    String? dbItemDistributor,
    double? dbItemPrice,
    double? dbItemCost,
    int? dbItemQuantity,
    DateTime? dbDateOfDistributionItemKey,
    bool? dbIsAdded,
  }) =>
      DistributionItemModel(
        distributionItemKey: CustomKey.create(
          key: dbKey ?? distributionItemKey.key,
          date: dbDateOfDistributionItemKey ?? dateOfDistributionItemKey,
        ),
        itemIDString: dbItemIDString ?? itemIDString,
        itemType: dbItemType ?? itemType,
        itemName: dbItemName ?? itemName,
        itemReceiver: dbReceiver ?? itemReceiver,
        itemDistributor: dbItemDistributor ?? itemDistributor,
        itemPrice: dbItemPrice ?? itemPrice,
        itemCost: dbItemCost ?? itemCost,
        itemQuantity: dbItemQuantity ?? itemQuantity,
        isAdded: dbIsAdded ?? isAdded,
      );

  static DistributionItemModel fromJson(Map<String, Object?> json) {
    return DistributionItemModel(
      distributionItemKey: CustomKey.create(
        key: json[DistributionItemFields.distributionItemKey] as String,
        date: DateTime.parse(
          json[DistributionItemFields.dateOfDistributionItemKey] as String,
        ),
      ),
      itemIDString: json[DistributionItemFields.itemIDString] as String,
      itemReceiver: Employees.employeeFromIDString(
        json[DistributionItemFields.itemReceiver] as String,
      ).employeeID,
      itemDistributor: json[DistributionItemFields.itemDistributor] as String,
      itemName: json[DistributionItemFields.itemName] as String,
      itemType: ItemTypes.itemTypeFromKeyString(
        json[DistributionItemFields.itemType] as String,
      ),
      itemPrice: double.parse(
        json[DistributionItemFields.itemPrice] as String,
      ),
      itemCost: double.parse(
        json[DistributionItemFields.itemCost] as String,
      ),
      itemQuantity: json[DistributionItemFields.itemQuantity] as int,
      isAdded: json[DistributionItemFields.isAdded] == 1,
    );
  }

  Map<String, Object?> toJson() {
    return {
      DistributionItemFields.distributionItemKey: distributionItemKey.key,
      DistributionItemFields.itemIDString: itemIDString,
      DistributionItemFields.itemType: itemType.itemTypeKey.key,
      DistributionItemFields.itemName: itemName,
      DistributionItemFields.itemDistributor: itemDistributor,
      DistributionItemFields.itemReceiver: itemReceiver.key,
      DistributionItemFields.itemPrice: itemPrice.toString(),
      DistributionItemFields.itemCost: itemCost.toString(),
      DistributionItemFields.itemQuantity: itemQuantity,
      DistributionItemFields.dateOfDistributionItemKey:
          dateOfDistributionItemKey.toIso8601String(),
      DistributionItemFields.isAdded: isAdded ? 1 : 0,
    };
  }
}

class DistributionItems with ChangeNotifier {
  static final DistributionItems instance = DistributionItems._init();
  DistributionItems._init();

  Map<CustomKey, DistributionItemModel> _distributionItems = {};
  Map<CustomKey, DistributionItemModel> get distributionItems {
    return {..._distributionItems};
  }

  static DistributionItemModel distributionItemFromKey(
          CustomKey distributionItemKey) =>
      instance.distributionItems.values.firstWhere(
        (distributionItem) =>
            distributionItem.distributionItemKey == distributionItemKey,
      );

  static List<DistributionItemModel> distributionItemsFromSearch({
    String search = '',
    Frequency? frequency,
  }) {
    if (frequency == null) frequency = Frequency.AllTime;
    if (search.isEmpty)
      return distributionItemsByDate(
        frequency: frequency,
      );
    else
      return distributionItemsByDate(frequency: frequency)
          .where(
            (distributionItem) => cFuncContainsString(
              l: [
                distributionItem.itemName,
                distributionItem.dateOfDistributionItemKey.toIso8601String(),
                distributionItem.itemType.itemTypeName,
              ],
              s: search,
            ),
          )
          .toList();
  }

  static List<DistributionItemModel> distributionItemsByDate({
    DateTime? baseDate,
    required Frequency frequency,
  }) =>
      instance.distributionItems.values
          .where(
            (distributionItem) => cFuncObjectIsAfterDate(
              b: baseDate,
              d: distributionItem.dateOfDistributionItemKey,
              f: frequency,
            ),
          )
          .toList();

  static Future<void> createDistributionItem({
    required String itemIDString,
    required ItemTypeModel itemType,
    required String itemName,
    required String itemDistributor,
    required double itemPrice,
    required double itemCost,
    required int itemQuantity,
    CustomKey? itemReceiver,
  }) async {
    CustomKey distributionItemKey = CustomKeyMethods.filter(
      cFuncGetKeyStrings(
        instance.distributionItems,
      ),
    );
    final DistributionItemModel distributionItem = DistributionItemModel(
      distributionItemKey: distributionItemKey,
      itemIDString: itemIDString,
      itemType: itemType,
      itemName: itemName,
      itemReceiver: itemReceiver ?? Employees.activeEmployee.employeeID,
      itemDistributor: itemDistributor,
      itemPrice: itemPrice,
      itemCost: itemCost,
      itemQuantity: itemQuantity,
      isAdded: false,
    );

    await dbCreateDistributionItem(distributionItem);

    instance._distributionItems.addEntries(
      {
        MapEntry(
          distributionItemKey,
          distributionItem,
        ),
      },
    );
    instance.notifyListeners();
  }

  static Future<void> updateDistributionItem({
    required CustomKey distributionItemKey,
    CustomKey? itemReceiver,
    String? itemName,
    String? itemDistributor,
    ItemTypeModel? itemType,
    double? itemPrice,
    double? itemCost,
    int? itemQuantity,
    bool? isAdded,
  }) async {
    final original = distributionItemFromKey(distributionItemKey);
    final originalQuantity = original.itemQuantity;
    final originalName = original.itemName;
    final originalReceiver = original.itemReceiver;
    final originalDistributor = original.itemName;
    final originalType = original.itemType;
    final originalCost = original.itemCost;
    final originalBool = original.isAdded;

    original.itemQuantity = itemQuantity ?? originalQuantity;
    original.itemName = itemName ?? originalName;
    original.itemReceiver = itemReceiver ?? originalReceiver;
    original.itemDistributor = itemDistributor ?? originalDistributor;
    original.itemType = itemType ?? originalType;
    original.itemCost = itemCost ?? originalCost;
    original.isAdded = isAdded ?? originalBool;

    final intAffected = await dbUpdateDistributionItem(original);
    if (intAffected > 0) {
      instance.notifyListeners();
    } else {
      original.itemQuantity = originalQuantity;
      original.itemCost = originalCost;
      original.itemName = originalName;
      original.itemType = originalType;
      original.itemReceiver = originalReceiver;
      original.itemDistributor = originalDistributor;
      original.isAdded = originalBool;
      throw Exception(
        'updateDistributionItem: distributionItemKey ${distributionItemKey.key} not found',
      );
    }
  }

  static Future<void> deleteDistributionItem(
      CustomKey distributionItemKey) async {
    final intAffected = await dbDeleteDistributionItem(
      distributionItemFromKey(distributionItemKey),
    );
    if (intAffected > 0) {
      instance._distributionItems.remove(
        distributionItemKey,
      );
      instance.notifyListeners();
    }
  }
}
