import 'package:flutter/foundation.dart';
import './transaction_model.dart';
import '../db/local/db_customers.dart';
import '../utils/custom_functions.dart';
import '../utils/custom_key.dart';
import '../utils/helpers.dart';

final String tableCustomers = 'customers';

class CustomerFields {
  static final List<String> values = [
    customerID,
    customerName,
    customerGender,
    customerContactNumber,
    customerAddress,
    customerDescription,
    customerDiscount,
    dateOfCustomerID,
  ];
  static final String customerID = '_customerID';
  static final String customerName = 'customerName';
  static final String customerGender = 'customerGender';
  static final String customerDiscount = 'customerDiscount';
  static final String customerContactNumber = 'customerContactNumber';
  static final String customerAddress = 'customerAddress';
  static final String customerDescription = 'customerDescription';
  static final String dateOfCustomerID = 'dateOfCustomerID';
}

class CustomerModel {
  final CustomKey customerID;
  double customerDiscount;
  Gender customerGender;
  String customerName;
  String customerContactNumber;
  String customerAddress;
  String customerDescription;
  Map<CustomKey, TransactionModel> customerTransactions;

  DateTime get dateOfCustomerID => customerID.date;
  double get accountsReceivable {
    double accountsReceivable = 0.0;
    customerTransactions.values.forEach(
      (transaction) => accountsReceivable += transaction.accountsReceivable,
    );
    return accountsReceivable;
  }

  CustomerModel({
    required this.customerID,
    required this.customerName,
    required this.customerGender,
    required this.customerDiscount,
    required this.customerContactNumber,
    required this.customerAddress,
    required this.customerDescription,
    required this.customerTransactions,
  });

  static CustomerModel fromJson(Map<String, Object?> json) {
    return CustomerModel(
      customerID: CustomKey.create(
        key: json[CustomerFields.customerID] as String,
        date: DateTime.parse(
          json[CustomerFields.dateOfCustomerID] as String,
        ),
      ),
      customerName: json[CustomerFields.customerName] as String,
      customerGender: json[CustomerFields.customerGender] == 1
          ? Gender.Male
          : Gender.Female,
      customerDiscount: double.parse(
        json[CustomerFields.customerDiscount] as String,
      ),
      customerContactNumber:
          json[CustomerFields.customerContactNumber] as String,
      customerAddress: json[CustomerFields.customerAddress] as String,
      customerDescription: json[CustomerFields.customerDescription] as String,
      customerTransactions: {},
    );
  }

  CustomerModel copy({
    String? dbID,
    DateTime? dbDate,
    Map<CustomKey, TransactionModel>? dbTransactions,
    Gender? dbGender,
    String? dbName,
    String? dbAddress,
    String? dbContactNumber,
    String? dbDescription,
    double? dbDiscount,
  }) {
    return CustomerModel(
      customerID: CustomKey.create(
        key: dbID ?? customerID.key,
        date: dbDate ?? dateOfCustomerID,
      ),
      customerName: dbName ?? customerName,
      customerGender: dbGender ?? customerGender,
      customerDiscount: dbDiscount ?? customerDiscount,
      customerContactNumber: dbContactNumber ?? customerContactNumber,
      customerAddress: dbAddress ?? customerAddress,
      customerDescription: dbDescription ?? customerDescription,
      customerTransactions: dbTransactions ?? customerTransactions,
    );
  }

  Map<String, Object?> toJson() => {
        CustomerFields.customerID: customerID.key,
        CustomerFields.customerGender: customerGender == Gender.Male ? 1 : 0,
        CustomerFields.customerAddress: customerAddress,
        CustomerFields.customerContactNumber: customerContactNumber,
        CustomerFields.customerDescription: customerDescription,
        CustomerFields.customerName: customerName,
        CustomerFields.customerDiscount: customerDiscount.toString(),
        CustomerFields.dateOfCustomerID: dateOfCustomerID.toIso8601String(),
      };
}

class Customers with ChangeNotifier {
  static final Customers instance = Customers._init();
  Customers._init();

  Map<CustomKey, CustomerModel> _customers = {};
  Map<CustomKey, CustomerModel> get customers => {..._customers};

  static CustomerModel customerFromIDString(String keyString) =>
      instance.customers.values.firstWhere(
        (customer) => customer.customerID.key == keyString,
      );

  static List<CustomerModel> customersFromSearch({String search = ''}) {
    if (search.isEmpty)
      return instance.customers.values.toList();
    else
      return instance.customers.values
          .where(
            (customer) => cFuncContainsString(
              l: [
                customer.customerName,
                customer.dateOfCustomerID.toIso8601String(),
                customer.customerAddress,
                customer.customerDescription,
                customer.customerContactNumber,
              ],
              s: search,
            ),
          )
          .toList();
  }

  static Future<CustomerModel> createCustomer({
    String customerName = 'Anonymous',
    Gender customerGender = Gender.Male,
    String customerContactNumber = 'Empty',
    String customerAddress = 'Empty',
    String customerDescription = 'Empty',
    double customerDiscount = 0.0,
    Map<CustomKey, TransactionModel>? customerTransactions,
  }) async {
    final CustomKey customerID = CustomKeyMethods.filter(
      cFuncGetKeyStrings(
        instance.customers,
      ),
    );
    final CustomerModel customer = CustomerModel(
      customerID: customerID,
      customerName: customerName,
      customerGender: customerGender,
      customerDiscount: customerDiscount,
      customerContactNumber: customerContactNumber,
      customerAddress: customerAddress,
      customerDescription: customerDescription,
      customerTransactions: customerTransactions ?? {},
    );
    await dbCreateCustomer(customer);
    instance._customers.addEntries(
      {
        MapEntry(
          customerID,
          customer,
        )
      },
    );
    return customer;
  }
}
