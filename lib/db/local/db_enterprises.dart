import './app_db.dart';
import '../../utils/custom_key.dart';
import '../../models/enterprise_model.dart';

Map<CustomKey, EnterpriseModel> _enterprises(
    List<Map<String, Object?>> jsonList) {
  Map<CustomKey, EnterpriseModel> enterprises = {};
  jsonList.forEach((json) => enterprises.addEntries({_enterprisesEntry(json)}));
  return enterprises;
}

MapEntry<CustomKey, EnterpriseModel> _enterprisesEntry(
    Map<String, Object?> json) {
  final EnterpriseModel enterprise = EnterpriseModel.fromJson(json);
  return MapEntry(enterprise.enterpriseKey, enterprise);
}

// MapEntry<CustomKey, Object> _enterprisesEntry(Map<String, Object?> json) {
//   final EnterpriseModel enterprise = EnterpriseModel.fromJson(json);
//   return MapEntry(enterprise.enterpriseKey, enterprise);
// }

Future<EnterpriseModel> dbCreateEnterprise(EnterpriseModel enterprise) async {
  final db = await AppDatabase.database;
  final _key = await db.insert(tableEnterprises, enterprise.toJson());
  return enterprise.copy(dbKey: _key.toString());
}

Future<Map<CustomKey, EnterpriseModel>> dbReadAllEnterprises() async {
  final db = await AppDatabase.database;
  final orderBy = '${EnterpriseModelFields.dateOfEnterpriseKey} ASC';
  return _enterprises(await db.query(tableEnterprises, orderBy: orderBy));
}

// Future<Map<CustomKey, EnterpriseModel>> dbReadAllEnterprises() async {
//   final db = await AppDatabase.database;
//   final orderBy = '${EnterpriseModelFields.dateOfEnterpriseKey} ASC';

//   return cFuncCustomMap(
//     await db.query(tableEnterprises, orderBy: orderBy),
//     _enterprisesEntry,
//   ) as Map<CustomKey, EnterpriseModel>;
// }
