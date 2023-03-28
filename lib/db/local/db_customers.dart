import './app_db.dart';
import '../../utils/custom_key.dart';
import '../../models/customer_model.dart';

// MapEntry<CustomKey, Object> _customersEntry(Map<String, Object?> json) {
//   final CustomerModel customer = CustomerModel.fromJson(json);
//   return MapEntry(
//     customer.customerID,
//     customer,
//   );
// }

Map<CustomKey, CustomerModel> _customers(List<Map<String, Object?>> jsonList) {
  Map<CustomKey, CustomerModel> customers = {};
  jsonList.forEach((json) => customers.addEntries({_customersEntry(json)}));
  return customers;
}

MapEntry<CustomKey, CustomerModel> _customersEntry(Map<String, Object?> json) {
  final CustomerModel customer = CustomerModel.fromJson(json);
  return MapEntry(
    customer.customerID,
    customer,
  );
}

Future<CustomerModel> dbCreateCustomer(CustomerModel customer) async {
  final db = await AppDatabase.database;
  final _key = await db.insert(tableCustomers, customer.toJson());
  return customer.copy(dbID: _key.toString());
}

Future<Map<CustomKey, CustomerModel>> dbReadAllCustomers() async {
  final db = await AppDatabase.database;
  final orderBy = '${CustomerFields.dateOfCustomerID} ASC';
  return _customers(await db.query(tableCustomers, orderBy: orderBy));
}

// Future<Map<CustomKey, CustomerModel>> dbReadAllCustomers() async {
//   final db = await AppDatabase.database;
//   final orderBy = '${CustomerFields.dateOfCustomerID} ASC';
//   return cFuncCustomMap(
//     await db.query(tableCustomers, orderBy: orderBy),
//     _customersEntry,
//   ) as Map<CustomKey, CustomerModel>;
// }

Future<int> dbUpdateCustomer(CustomerModel customer) async {
  final db = await AppDatabase.database;
  return await db.update(
    tableCustomers,
    customer.toJson(),
    where: '${CustomerFields.customerID} = ?',
    whereArgs: [customer.customerID.key],
  );
}
