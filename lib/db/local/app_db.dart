import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/employee_model.dart';
import '../../models/enterprise_model.dart';
import '../../models/distribution_item_model.dart';
import '../../models/item_type_model.dart';
import '../../models/inventory_item_model.dart';
import '../../models/customer_model.dart';
import '../../models/checkout_item_model.dart';
import '../../models/transaction_model.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await instance._initDB('ipon.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final keyType = 'TEXT PRIMARY KEY';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableEnterprises (
      ${EnterpriseModelFields.enterpriseKey} $keyType,
      ${EnterpriseModelFields.enterpriseName} $textType,
      ${EnterpriseModelFields.enterpriseAddress} $textType,
      ${EnterpriseModelFields.enterpriseContactNumber} $textType,
      ${EnterpriseModelFields.enterpriseEmail} $textType,
      ${EnterpriseModelFields.isActive} $boolType,
      ${EnterpriseModelFields.dateOfEnterpriseKey} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableItemTypes (
      ${ItemTypeFields.itemTypeKey} $keyType,
      ${ItemTypeFields.itemTypeName} $textType,
      ${ItemTypeFields.itemTypeDescription} $textType,
      ${ItemTypeFields.figureString} $textType,
      ${ItemTypeFields.dateOfItemTypeKey} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableDistributionItems (
      ${DistributionItemFields.distributionItemKey} $keyType,
      ${DistributionItemFields.itemIDString} $textType,
      ${DistributionItemFields.itemType} $textType,
      ${DistributionItemFields.itemName} $textType,
      ${DistributionItemFields.itemDistributor} $textType,
      ${DistributionItemFields.itemReceiver} $textType,
      ${DistributionItemFields.itemPrice} $textType,
      ${DistributionItemFields.itemCost} $textType,
      ${DistributionItemFields.itemQuantity} $integerType,
      ${DistributionItemFields.isAdded} $boolType,
      ${DistributionItemFields.dateOfDistributionItemKey} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableInventoryItems (
      ${InventoryItemFields.itemID} $keyType,
      ${InventoryItemFields.itemName} $textType,
      ${InventoryItemFields.itemPrice} $textType,
      ${InventoryItemFields.itemQuantity} $integerType,
      ${InventoryItemFields.itemType} $textType,
      ${InventoryItemFields.dateOfItemID} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableEmployees (
      ${EmployeeModelFields.employeeID} $keyType,
      ${EmployeeModelFields.employeeName} $textType,
      ${EmployeeModelFields.employeeGender} $boolType,
      ${EmployeeModelFields.employeeContactNumber} $textType,
      ${EmployeeModelFields.employeeAddress} $textType,
      ${EmployeeModelFields.employeeDescription} $textType,
      ${EmployeeModelFields.employeeSalary} $textType,
      ${EmployeeModelFields.dateOfEmployeeID} $textType,
      ${EmployeeModelFields.isActive} $boolType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableCustomers (
      ${CustomerFields.customerID} $keyType,
      ${CustomerFields.customerName} $textType,
      ${CustomerFields.customerGender} $boolType,
      ${CustomerFields.customerContactNumber} $textType,
      ${CustomerFields.customerAddress} $textType,
      ${CustomerFields.customerDescription} $textType,
      ${CustomerFields.customerDiscount} $textType,
      ${CustomerFields.dateOfCustomerID} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableTransactionItems (
      ${TransactionItemFields.transactionItemKey} $keyType,
      ${TransactionItemFields.transactionKey} $textType,
      ${TransactionItemFields.itemID} $textType,
      ${TransactionItemFields.itemName} $textType,
      ${TransactionItemFields.itemPrice} $textType,
      ${TransactionItemFields.transactionQuantity} $integerType,
      ${TransactionItemFields.dateOfTransactionItemKey} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableTransactions (
      ${TransactionFields.transactionKey} $keyType,
      ${TransactionFields.customerID} $textType,
      ${TransactionFields.employeeID} $textType,
      ${TransactionFields.amountPaid} $textType,
      ${TransactionFields.customerDiscount} $textType,
      ${TransactionFields.dateOfTransactionKey} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE $tableCheckoutItems (
      ${CheckoutItemFields.checkoutItemKey} $keyType,
      ${CheckoutItemFields.itemID} $textType,
      ${CheckoutItemFields.checkoutItemQuantity} $integerType,
      ${CheckoutItemFields.dateOfCheckoutItemKey} $textType
    )
    ''');

    await storeBuiltInTypesToDB(db);
  }

  Future<void> storeBuiltInTypesToDB(Database db) async {
    final List<Map<String, Object?>> _builtInTypes = builtInTypes();
    for (int i = 0; i < _builtInTypes.length; i++) {
      await db.insert(
        tableItemTypes,
        _builtInTypes[i],
      );
    }
  }

  Future<ItemTypeModel> createItemType(ItemTypeModel itemType) async {
    final db = await AppDatabase.database;
    final _key = await db.insert(tableItemTypes, itemType.toJson());
    return itemType.copy(dbKey: _key.toString());
  }

  Future close() async {
    final db = await database;
    db.close();
  }

  static Future<int> delete({String? table}) async {
    final db = await database;
    if (table != null) {
      return await db.delete(table);
    } else {
      throw Exception('Invalid Operation');
    }
  }
}
