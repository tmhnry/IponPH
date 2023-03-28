import 'package:flutter/material.dart';
import '../db/local/db_enterprises.dart';
import '../utils/custom_key.dart';
import '../utils/custom_functions.dart';

const String tableEnterprises = 'enterprises';

Future<void> readAllEnterprises() async {
  Enterprises.instance._enterprises = await dbReadAllEnterprises();
}

class EnterpriseModelFields {
  static const List<String> values = [
    enterpriseKey,
    enterpriseName,
    enterpriseAddress,
    enterpriseContactNumber,
    enterpriseEmail,
    dateOfEnterpriseKey,
    isActive,
  ];
  static const String enterpriseKey = '_enterpriseKey';
  static const String enterpriseName = 'enterpriseName';
  static const String enterpriseAddress = 'enterpriseAddress';
  static const String enterpriseContactNumber = 'enterpriseContactNumber';
  static const String enterpriseEmail = 'enterpriseEmail';
  static const String dateOfEnterpriseKey = 'dateOfEnterpriseKey';
  static const String isActive = 'isActive';
}

class EnterpriseModel {
  EnterpriseModel({
    required this.enterpriseKey,
    required this.enterpriseName,
    required this.enterpriseAddress,
    required this.enterpriseContactNumber,
    required this.enterpriseEmail,
    required this.isActive,
  });

  final CustomKey enterpriseKey;
  final String enterpriseName;
  final String enterpriseAddress;
  final String enterpriseContactNumber;
  final String enterpriseEmail;
  bool isActive;

  DateTime get dateOfEnterpriseKey => enterpriseKey.date;

  EnterpriseModel copy({
    String? dbKey,
    String? dbName,
    String? dbAddress,
    String? dbContactNumber,
    String? dbEmail,
    DateTime? dbDate,
    bool? dbIsActive,
  }) =>
      EnterpriseModel(
        enterpriseKey: CustomKey.create(
          key: dbKey ?? enterpriseKey.key,
          date: dbDate ?? dateOfEnterpriseKey,
        ),
        enterpriseName: dbName ?? enterpriseName,
        enterpriseAddress: dbAddress ?? enterpriseAddress,
        enterpriseContactNumber: dbContactNumber ?? enterpriseContactNumber,
        enterpriseEmail: dbEmail ?? enterpriseEmail,
        isActive: dbIsActive ?? isActive,
      );

  static EnterpriseModel fromJson(Map<String, Object?> json) {
    final CustomKey enterpriseKey = CustomKey.create(
      key: json[EnterpriseModelFields.enterpriseKey] as String,
      date: DateTime.parse(
          json[EnterpriseModelFields.dateOfEnterpriseKey] as String),
    );
    return EnterpriseModel(
      enterpriseKey: enterpriseKey,
      enterpriseName: json[EnterpriseModelFields.enterpriseName] as String,
      enterpriseAddress:
          json[EnterpriseModelFields.enterpriseAddress] as String,
      enterpriseContactNumber:
          json[EnterpriseModelFields.enterpriseContactNumber] as String,
      enterpriseEmail: json[EnterpriseModelFields.enterpriseEmail] as String,
      isActive: json[EnterpriseModelFields.isActive] == 1,
    );
  }

  Map<String, Object?> toJson() {
    return {
      EnterpriseModelFields.enterpriseKey: enterpriseKey.key,
      EnterpriseModelFields.enterpriseName: enterpriseName,
      EnterpriseModelFields.enterpriseAddress: enterpriseAddress,
      EnterpriseModelFields.enterpriseContactNumber: enterpriseContactNumber,
      EnterpriseModelFields.enterpriseEmail: enterpriseEmail,
      EnterpriseModelFields.dateOfEnterpriseKey:
          dateOfEnterpriseKey.toIso8601String(),
      EnterpriseModelFields.isActive: isActive ? 1 : 0,
    };
  }
}

class Enterprises with ChangeNotifier {
  static final Enterprises instance = Enterprises._init();
  Enterprises._init();

  Map<CustomKey, EnterpriseModel> _enterprises = {};
  Map<CustomKey, EnterpriseModel> get enterprises => {..._enterprises};

  static EnterpriseModel get activeEnterprise =>
      instance.enterprises.values.firstWhere(
        (enterprise) => enterprise.isActive,
      );

  static bool get isEnterprisesEmpty => instance.enterprises.isEmpty;

  static Future<void> createEnterprise({
    required String enterpriseName,
    required String enterpriseAddress,
    required String enterpriseContactNumber,
    required String enterpriseEmail,
    bool isActive = false,
  }) async {
    CustomKey enterpriseKey = CustomKeyMethods.filterFour(
      cFuncGetKeyStrings(
        instance.enterprises,
      ),
    );

    final EnterpriseModel enterprise = EnterpriseModel(
      enterpriseKey: enterpriseKey,
      enterpriseName: enterpriseName,
      enterpriseAddress: enterpriseAddress,
      enterpriseContactNumber: enterpriseContactNumber,
      enterpriseEmail: enterpriseEmail,
      isActive: isActive,
    );

    await dbCreateEnterprise(enterprise);

    instance._enterprises.addEntries(
      {
        MapEntry(enterpriseKey, enterprise),
      },
    );
    instance.notifyListeners();
  }
}
