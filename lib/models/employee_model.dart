import 'package:flutter/foundation.dart';
import '../db/local/db_employees.dart';
import '../utils/custom_key.dart';
import '../utils/custom_functions.dart';
import '../utils/helpers.dart';

Future<void> readAllEmployees() async {
  Employees.instance._employees = await dbReadAllEmployees();
}

final String tableEmployees = 'employees';

class EmployeeModelFields {
  static final List<String> values = [
    employeeID,
    employeeName,
    employeeGender,
    employeeDescription,
    employeeContactNumber,
    employeeAddress,
    employeeSalary,
    transactions,
    distributions,
    dateOfEmployeeID,
    isActive,
  ];

  static final String employeeID = '_employeeID';
  static final String employeeName = 'employeeName';
  static final String employeeGender = 'employeeGender';
  static final String employeeDescription = 'employeeDescription';
  static final String employeeContactNumber = 'employeeContactNumber';
  static final String employeeAddress = 'employeeAddress';
  static final String employeeSalary = 'employeeSalary';
  static final String transactions = 'transactions';
  static final String distributions = 'distributions';
  static final String dateOfEmployeeID = 'dateOfEmployeeID';
  static final String isActive = 'isActive';
}

class EmployeeModel {
  EmployeeModel({
    required this.employeeID,
    required this.employeeName,
    required this.employeeGender,
    required this.employeeDescription,
    required this.employeeContactNumber,
    required this.employeeAddress,
    required this.employeeSalary,
    required this.isActive,
  });
  DateTime get dateOfEmployeeID => this.employeeID.date;

  final CustomKey employeeID;
  final String employeeName;
  Gender employeeGender;
  String employeeDescription;
  String employeeContactNumber;
  String employeeAddress;
  double employeeSalary;
  bool isActive;

  static EmployeeModel fromJson(Map<String, Object?> json) {
    final CustomKey employeeID = CustomKey.create(
      key: json[EmployeeModelFields.employeeID] as String,
      date:
          DateTime.parse(json[EmployeeModelFields.dateOfEmployeeID] as String),
    );
    return EmployeeModel(
      employeeID: employeeID,
      employeeName: json[EmployeeModelFields.employeeName] as String,
      employeeGender: json[EmployeeModelFields.employeeGender] == 1
          ? Gender.Male
          : Gender.Female,
      employeeDescription:
          json[EmployeeModelFields.employeeDescription] as String,
      employeeContactNumber:
          json[EmployeeModelFields.employeeContactNumber] as String,
      employeeSalary:
          double.parse(json[EmployeeModelFields.employeeSalary] as String),
      employeeAddress: json[EmployeeModelFields.employeeAddress] as String,
      isActive: json[EmployeeModelFields.isActive] == 1,
    );
  }

  EmployeeModel copy({
    String? dbID,
    String? dbName,
    Gender? dbGender,
    String? dbDescription,
    String? dbContactNumber,
    String? dbAddress,
    double? dbSalary,
    bool? dbIsActive,
    DateTime? dbDate,
  }) =>
      EmployeeModel(
        employeeID: CustomKey.create(
          key: dbID ?? employeeID.key,
          date: dbDate ?? dateOfEmployeeID,
        ),
        employeeName: dbName ?? employeeName,
        employeeGender: dbGender ?? employeeGender,
        employeeDescription: dbDescription ?? employeeDescription,
        employeeContactNumber: dbContactNumber ?? employeeContactNumber,
        employeeAddress: dbAddress ?? employeeAddress,
        employeeSalary: dbSalary ?? employeeSalary,
        isActive: dbIsActive ?? isActive,
      );

  Map<String, Object?> toJson() {
    return {
      EmployeeModelFields.employeeID: employeeID.key,
      EmployeeModelFields.employeeName: employeeName,
      EmployeeModelFields.employeeGender: employeeGender == Gender.Male ? 1 : 0,
      EmployeeModelFields.employeeDescription: employeeDescription,
      EmployeeModelFields.employeeContactNumber: employeeContactNumber,
      EmployeeModelFields.employeeAddress: employeeAddress,
      EmployeeModelFields.employeeSalary: employeeSalary.toString(),
      EmployeeModelFields.dateOfEmployeeID: dateOfEmployeeID.toIso8601String(),
      EmployeeModelFields.isActive: isActive ? 1 : 0,
    };
  }
}

class Employees with ChangeNotifier {
  static final Employees instance = Employees._init();
  Employees._init();
  Map<CustomKey, EmployeeModel> _employees = {};
  Map<CustomKey, EmployeeModel> get employees => {..._employees};

  static bool get isEmployeesEmpty => instance.employees.isEmpty;

  static EmployeeModel employeeFromIDString(String idString) =>
      instance.employees.values.firstWhere(
        (employee) => employee.employeeID.key == idString,
      );

  static EmployeeModel get activeEmployee =>
      instance.employees.values.firstWhere(
        (employee) => employee.isActive,
      );

  static get totalSalary {
    double totalSalary = 0.00;
    instance.employees.values.forEach(
      (employee) => totalSalary += employee.employeeSalary,
    );
    return totalSalary;
  }

  static List<EmployeeModel> employeesFromSearch({
    String search = '',
  }) {
    if (search.isEmpty)
      return instance.employees.values.toList();
    else
      return instance.employees.values
          .where(
            (employee) => cFuncContainsString(
              l: [
                employee.employeeName,
                employee.employeeDescription,
                employee.dateOfEmployeeID.toIso8601String(),
                employee.employeeContactNumber,
                employee.employeeAddress,
              ],
              s: search,
            ),
          )
          .toList();
  }

  static Future<void> createEmployee({
    required String employeeName,
    required double employeeSalary,
    String employeeDescription = 'Empty',
    Gender employeeGender = Gender.Male,
    String employeeContactNumber = 'Empty',
    String employeeAddress = 'Empty',
    bool isActive = false,
  }) async {
    CustomKey employeeID = CustomKeyMethods.filterEight(
      cFuncGetKeyStrings(
        instance.employees,
      ),
    );
    final EmployeeModel employee = EmployeeModel(
      employeeID: employeeID,
      employeeName: employeeName,
      employeeGender: employeeGender,
      employeeDescription: employeeDescription,
      employeeContactNumber: employeeContactNumber,
      employeeAddress: employeeAddress,
      employeeSalary: employeeSalary,
      isActive: isActive,
    );
    await dbCreateEmployee(employee);
    instance._employees.addEntries(
      {
        MapEntry(employeeID, employee),
      },
    );
    instance.notifyListeners();
  }
}
