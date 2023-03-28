import 'package:flutter/material.dart';
import '../widgets/sales_history_tile.dart';
import '../../../utils/helpers.dart';
import '../../../models/transaction_model.dart';

class SalesHistory extends StatefulWidget {
  static String routeName = 'sales_history';
  @override
  _SalesHistoryState createState() => _SalesHistoryState();
}

class _SalesHistoryState extends State<SalesHistory> {
  late Frequency frequency;
  late TextEditingController searchController;

  @override
  void initState() {
    frequency = Frequency.Weekly;
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.clear();
    searchController.dispose();
    super.dispose();
  }

  void rebuild() => setState(
        () => null,
      );

  List<TransactionModel> get transactionsFromSearch =>
      Transactions.transactionsFromSearch(
        search: searchController.text,
        frequency: frequency,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Sales History'),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(5, 111, 146, 1),
                  Color.fromRGBO(6, 57, 84, 1)
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Row(
              children: buildButtons(),
            ),
            buildListView(),
          ],
        ),
      );

  static const List<String> frequencies = [
    'Dailiy',
    'Weekly',
    'Monthly',
    'All Times',
  ];

  List<Widget> buildButtons() => frequencies
      .map(
        (frequency) => Expanded(
          child: OutlinedButton(
            onPressed: () => setState(
              () {
                switch (frequency) {
                  case 'Daily':
                    this.frequency = Frequency.Daily;
                    break;
                  case 'Weekly':
                    this.frequency = Frequency.Weekly;
                    break;
                  case 'Monthly':
                    this.frequency = Frequency.Monthly;
                    break;
                  default:
                    this.frequency = Frequency.AllTime;
                }
              },
            ),
            child: Text(frequency),
          ),
        ),
      )
      .toList();

  Widget buildTextfield() => TextField(
        controller: searchController,
      );

  Widget buildListView() => Expanded(
        child: ListView.builder(
          itemCount: transactionsFromSearch.length,
          itemBuilder: (context, index) => SalesHistoryTile(
            transaction: transactionsFromSearch.elementAt(index),
          ),
        ),
      );
}
