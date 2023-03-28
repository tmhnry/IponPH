import 'package:flutter/material.dart';
import '../db/local/db_item_types.dart';
import '../utils/custom_key.dart';
import '../utils/custom_functions.dart';

final String tableItemTypes = 'itemTypes';
Future<void> readAllItemTypes() async {
  ItemTypes.instance._itemTypes = await dbReadAllItemTypes();
}

class ItemTypeFields {
  static final List<String> values = [
    itemTypeName,
    itemTypeKey,
    itemTypeDescription,
    dateOfItemTypeKey,
    figureString,
  ];

  static final String itemTypeKey = '_itemTypeKey';
  static final String itemTypeName = 'itemTypeName';
  static final String itemTypeDescription = 'itemTypeDescription';
  static final String figureString = 'figureString';
  static final String dateOfItemTypeKey = 'dateOfItemTypeKey';
}

class ItemTypeModel {
  final CustomKey itemTypeKey;
  final String itemTypeName;
  String itemTypeDescription;
  String figureString;

  ItemTypeModel({
    required this.itemTypeKey,
    required this.itemTypeName,
    required this.itemTypeDescription,
    required this.figureString,
  });

  DateTime get dateOfItemTypeKey => itemTypeKey.date;
  Widget get itemTypeFigure => Image.network(figureString);

  ItemTypeModel copy({
    String? dbKey,
    DateTime? dbDate,
    String? dbItemTypeName,
    String? dbItemTypeDescription,
    String? dbFigureString,
  }) =>
      ItemTypeModel(
        itemTypeKey: CustomKey.create(
          key: dbKey ?? itemTypeKey.key,
          date: dbDate ?? dateOfItemTypeKey,
        ),
        itemTypeName: dbItemTypeName ?? itemTypeName,
        itemTypeDescription: dbItemTypeDescription ?? itemTypeDescription,
        figureString: dbFigureString ?? figureString,
      );

  static ItemTypeModel fromJson(Map<String, Object?> json) => ItemTypeModel(
        itemTypeName: json[ItemTypeFields.itemTypeName] as String,
        itemTypeKey: CustomKey.create(
          key: json[ItemTypeFields.itemTypeKey] as String,
          date: DateTime.parse(
            json[ItemTypeFields.dateOfItemTypeKey] as String,
          ),
        ),
        itemTypeDescription: json[ItemTypeFields.itemTypeDescription] as String,
        figureString: json[ItemTypeFields.figureString] as String,
      );

  Map<String, Object?> toJson() => {
        ItemTypeFields.itemTypeKey: itemTypeKey.key,
        ItemTypeFields.itemTypeName: itemTypeName,
        ItemTypeFields.itemTypeDescription: itemTypeDescription,
        ItemTypeFields.figureString: figureString,
        ItemTypeFields.dateOfItemTypeKey: dateOfItemTypeKey.toIso8601String(),
      };
}

class ItemTypes with ChangeNotifier {
  Map<CustomKey, ItemTypeModel> _itemTypes = {};
  Map<CustomKey, ItemTypeModel> get itemTypes => {..._itemTypes};
  static final ItemTypes instance = ItemTypes._init();
  ItemTypes._init();

  static Future<void> createItemType({
    required String itemTypeName,
    String itemTypeDescription = '',
    String? figureString,
  }) async {
    final CustomKey itemTypeKey = CustomKeyMethods.filterFour(
      cFuncGetKeyStrings(
        instance.itemTypes,
      ),
    );
    final ItemTypeModel itemType = ItemTypeModel(
      itemTypeKey: itemTypeKey,
      itemTypeName: itemTypeName,
      itemTypeDescription: itemTypeDescription,
      figureString: figureString ?? _generalString,
    );

    await dbCreateItemType(itemType);

    instance._itemTypes.addEntries(
      {
        MapEntry(
          itemTypeKey,
          itemType,
        ),
      },
    );
    instance.notifyListeners();
  }

  static ItemTypeModel itemTypeFromKey(CustomKey itemTypeKey) =>
      instance.itemTypes.values.firstWhere(
        (itemType) => itemTypeKey == itemType.itemTypeKey,
      );
  static ItemTypeModel itemTypeFromKeyString(String keyString) =>
      instance.itemTypes.values.firstWhere(
        (itemType) => itemType.itemTypeKey.key == keyString,
      );

  static List<ItemTypeModel> itemTypesFromSearch({String search = ''}) {
    if (search.isEmpty) return instance.itemTypes.values.toList();
    return instance.itemTypes.values
        .where(
          (itemType) => cFuncContainsString(l: [
            itemType.itemTypeName,
            itemType.figureString,
            itemType.itemTypeDescription,
            itemType.dateOfItemTypeKey.toIso8601String(),
          ], s: search),
        )
        .toList();
  }

  static Future<void> changeImage({
    required CustomKey itemTypeKey,
    required String newFigureString,
  }) async {
    final ItemTypeModel itemType = itemTypeFromKey(
      itemTypeKey,
    );
    itemType.figureString = newFigureString;
    await dbUpdateItemType(itemType);
  }

  static Future<void> changeDescription({
    required CustomKey itemTypeKey,
    required String newDescription,
  }) async {
    final ItemTypeModel itemType = itemTypeFromKey(itemTypeKey);
    itemType.itemTypeDescription = newDescription;
    await dbUpdateItemType(itemType);
  }
}

String _generalString =
    'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/fresh-vegetables-in-the-eco-cotton-bag-at-the-royalty-free-image-1583774382.jpg';
String _consumableString =
    'https://media.istockphoto.com/photos/hamburger-with-cheese-and-french-fries-picture-id1188412964?k=6&m=1188412964&s=612x612&w=0&h=860S0kVoWTA60T4wakI8HLv-Y3fFw9jOKLSB4quEkIE=';
String _beverageString =
    'https://cf.shopee.ph/file/0806b3ea54279aa0608e638ecf1ad940';
String _drugString =
    'https://static01.nyt.com/images/2020/05/22/science/22VIRUS-HCQ/22VIRUS-HCQ-mediumSquareAt3X.jpg';
String _utilityString =
    'http://cdn.home-designing.com/wp-content/uploads/2014/09/cute-green-kitchen.jpg';

List<Map<String, Object?>> builtInTypes() {
  List<String> keyStrings = ['BAD0', 'D516', 'B459', '7A3E', 'C4BA'];

  Map<String, String> itemTypeNameDescription = {
    'General': 'General Product',
    'Consumable': 'Consumable Product',
    'Beverage': 'Beverage Product',
    'Drug': 'Drug Product',
    'Utility': 'Utility Product',
  };
  List<String> figureStrings = [
    _generalString,
    _consumableString,
    _beverageString,
    _drugString,
    _utilityString,
  ];

  return keyStrings.map(
    (keyString) {
      return {
        ItemTypeFields.itemTypeKey: keyString,
        ItemTypeFields.itemTypeName: itemTypeNameDescription.keys.elementAt(
          keyStrings.indexOf(keyString),
        ),
        ItemTypeFields.itemTypeDescription:
            itemTypeNameDescription.values.elementAt(
          keyStrings.indexOf(keyString),
        ),
        ItemTypeFields.figureString:
            figureStrings[keyStrings.indexOf(keyString)],
        ItemTypeFields.dateOfItemTypeKey: DateTime.now().toIso8601String(),
      };
    },
  ).toList();
}
