import 'package:flutter/material.dart';
import 'package:iponph/utils/helpers.dart';
import 'package:provider/provider.dart';
import './home_screen.dart';
import './login_screen.dart';
import './signup_screen.dart';
import './enterprise_screen.dart';

import './models/customer_model.dart';
import './models/inventory_item_model.dart';
import './models/distribution_item_model.dart';
import './models/checkout_item_model.dart';
import './models/enterprise_model.dart';
import './models/employee_model.dart';
import './models/item_type_model.dart';
import './models/transaction_model.dart';

import './enterprise/stocks/screens/stocks.dart';
import './enterprise/delivery/screens/distribution_reports_screen.dart';
import './enterprise/stocks/screens/bluetooth_thermal_printer.dart';
import './enterprise/stocks/screens/customer_selector_screen.dart';
import './enterprise/hr/screens/enterprise_profile_screen.dart';
import './enterprise/associations/screens/customer_profile_screen.dart';
import './enterprise/associations/screens/manage_customer_screen.dart';
import './enterprise/hr/screens/employee_profile_screen.dart';
import './enterprise/stocks/screens/checkout_screen.dart';
import './enterprise/accounting/screens/sales_history.dart';
import './enterprise/hr/screens/human_resources.dart';
import './enterprise/stocks/screens/product_type_screen.dart';
import './enterprise/hr/screens/admission_history.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => DistributionItems.instance,
          ),
          ChangeNotifierProvider(
            create: (context) => ItemTypes.instance,
          ),
          ChangeNotifierProvider(
            create: (context) => InventoryItems.instance,
          ),
          ChangeNotifierProvider(
            create: (context) => Employees.instance,
          ),
          ChangeNotifierProvider(
            create: (context) => Enterprises.instance,
          ),
          ChangeNotifierProvider(
            create: (context) => Transactions.instance,
          ),
          ChangeNotifierProvider(
            create: (context) => Customers.instance,
          ),
          ChangeNotifierProvider(
            create: (context) => CheckoutItems.instance,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: LogIn(),
          theme: ThemeData(
            primaryColorDark: CustomColors.charcoal,
            // scaffoldBackgroundColor: CustomColors.charcoal,
            primaryColorLight: Colors.orange,
            // primaryColorDark: CustomColors.darkBlueGradient,
            appBarTheme: AppBarTheme(
              backgroundColor: CustomColors.charcoal,
            ),
            backgroundColor: Colors.white70,
            tabBarTheme: TabBarTheme(
              indicator: BoxDecoration(
                border: BorderDirectional(
                  //   top: BorderSide(
                  //     color: CustomColors.charcoal,
                  //     width: 1,
                  //   ),
                  //   bottom: BorderSide(
                  //     color: CustomColors.charcoal,
                  //     width: 1,
                  //   ),
                  //   start: BorderSide(
                  //     color: CustomColors.charcoal,
                  //     width: 1,
                  //   ),
                  //   end: BorderSide(
                  //     color: CustomColors.charcoal,
                  //     width: 1,
                  //   ),
                  // ),
                  bottom: BorderSide.none,
                ),
              ),
              labelColor: CustomColors.charcoal,
              labelStyle: TextStyle(
                fontFamily: 'Righteous',
              ),
              unselectedLabelColor: CustomColors.darkBlueGradient,
              unselectedLabelStyle: TextStyle(
                fontFamily: 'Quicksand',
              ),
            ),
          ),
          routes: {
            LogIn.routeName: (context) => LogIn(),
            SignUp.routeName: (context) => SignUp(),
            HomeScreen.routeName: (context) => HomeScreen(),
            Stocks.routeName: (context) => Stocks(),
            EnterpriseScreen.routeName: (context) => EnterpriseScreen(),
            DistributionReportsScreen.routeName: (context) =>
                DistributionReportsScreen(),
            EmployeeProfileScreen.routeName: (context) =>
                EmployeeProfileScreen(),
            CheckOutScreen.routeName: (context) => CheckOutScreen(),
            SalesHistory.routeName: (context) => SalesHistory(),
            HumanResources.routeName: (context) => HumanResources(),
            ProductTypeScreen.routeName: (context) => ProductTypeScreen(),
            AdmissionHistory.routeName: (context) => AdmissionHistory(),
            ManageCustomerScreen.routeName: (context) => ManageCustomerScreen(),
            CustomerProfileScreen.routeName: (context) =>
                CustomerProfileScreen(),
            EnterpriseProfileScreen.routeName: (context) =>
                EnterpriseProfileScreen(),
            CustomerSelectorScreen.routeName: (context) =>
                CustomerSelectorScreen(),
            ReceiptPrinter.routeName: (context) => ReceiptPrinter(),
          },
        ),
      );
}
