import './app_db.dart';
import '../../utils/custom_key.dart';
import '../../models/employee_model.dart';

Map<CustomKey, EmployeeModel> _employees(List<Map<String, Object?>> jsonList) {
  Map<CustomKey, EmployeeModel> employees = {};
  jsonList.forEach((json) => employees.addEntries({_employeesEntry(json)}));
  return employees;
}

// MapEntry<CustomKey, Object> _employeesEntry(Map<String, Object?> json) {
//   final EmployeeModel employee = EmployeeModel.fromJson(json);
//   return MapEntry(employee.employeeID, employee);
// }

MapEntry<CustomKey, EmployeeModel> _employeesEntry(Map<String, Object?> json) {
  final EmployeeModel employee = EmployeeModel.fromJson(json);
  return MapEntry(employee.employeeID, employee);
}

Future<EmployeeModel> dbCreateEmployee(EmployeeModel employee) async {
  final db = await AppDatabase.database;
  final _key = await db.insert(tableEmployees, employee.toJson());
  return employee.copy(dbID: _key.toString());
}

Future<Map<CustomKey, EmployeeModel>> dbReadAllEmployees() async {
  Map<CustomKey, EmployeeModel> employees = {};
  final db = await AppDatabase.database;
  final orderBy = '${EmployeeModelFields.dateOfEmployeeID} ASC';
  return _employees(await db.query(tableEmployees, orderBy: orderBy));
}

// Future<Map<CustomKey, EmployeeModel>> dbReadAllEmployees() async {
//   final db = await AppDatabase.database;
//   final orderBy = '${EmployeeModelFields.dateOfEmployeeID} ASC';
//   return cFuncCustomMap(
//     await db.query(tableEmployees, orderBy: orderBy),
//     _employeesEntry,
//   ) as Map<CustomKey, EmployeeModel>;
// }
