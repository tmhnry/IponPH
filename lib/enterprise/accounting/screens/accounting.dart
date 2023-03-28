import 'package:flutter/material.dart';
import './sales_history.dart';
import '../../../utils/helpers.dart';
import '../../../models/transaction_model.dart';
import '../../../models/customer_model.dart';
import '../../../models/employee_model.dart';

class Accounting extends StatefulWidget {
  @override
  _AccountingTabState createState() => _AccountingTabState();
}

class _AccountingTabState extends State<Accounting> {
  late final TextEditingController searchController;

  @override
  void dispose() {
    searchController.clear();
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  List<TransactionModel> get dailyTransactionsFromSearch =>
      Transactions.transactionsFromSearch(
        search: searchController.text,
        frequency: Frequency.Daily,
      );

  void rebuild() => setState(
        () => null,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            Container(
              height: 80,
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(SalesHistory.routeName),
                      child: const Text(
                        'SALES HISTORY',
                        style: TextStyle(
                          color: Color.fromRGBO(5, 111, 146, 1),
                        ),
                      ),
                    ),
                    SizedBox(width: 80),
                    TextButton(
                      onPressed: () => null,
                      child: const Text(
                        'SALES REPORTING',
                        style: TextStyle(
                          color: Color.fromRGBO(5, 111, 146, 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.subject_sharp,
                      color: Color.fromRGBO(5, 111, 146, 1),
                      size: 60,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (_) => rebuild(),
                    ),
                  ),
                ],
              ),
            ),
            buildListView(),
          ],
        ),
      );

  Widget buildListView() => Expanded(
        child: ListView.builder(
          itemCount: dailyTransactionsFromSearch.length,
          itemBuilder: (context, index) => ListTile(
            leading: dailyTransactionsFromSearch
                    .elementAt(index)
                    .transactionItems
                    .isEmpty
                ? Icon(Icons.payment)
                : Icon(
                    Icons.shopping_cart,
                  ),
            title: Column(
              children: [
                Text(
                  dailyTransactionsFromSearch
                      .elementAt(index)
                      .dateOfTransactionKey
                      .toIso8601String(),
                ),
                Text(
                  Customers.customerFromIDString(
                    dailyTransactionsFromSearch.elementAt(index).customerID.key,
                  ).customerName,
                ),
                Text(
                  Employees.employeeFromIDString(
                    dailyTransactionsFromSearch.elementAt(index).employeeID.key,
                  ).employeeName,
                ),
              ],
            ),
          ),
        ),
      );
}
