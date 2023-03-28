import 'package:flutter/material.dart';
import '../../../models/transaction_model.dart';

class SalesHistoryTile extends StatefulWidget {
  final TransactionModel transaction;
  SalesHistoryTile({required this.transaction});
  @override
  _SalesHistoryTileState createState() => _SalesHistoryTileState();
}

class _SalesHistoryTileState extends State<SalesHistoryTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        children: [
          Text('Transaction No.'),
          Text(
            widget.transaction.transactionKey.key,
          )
        ],
      ),
      title: Column(
        children: [
          FittedBox(
            child: Row(
              children: [
                Text('Customer Name: '),
                Text(widget.transaction.customerID.key),
              ],
            ),
          ),
          FittedBox(
            child: Row(
              children: [
                Text('Employee Name: '),
                Text(widget.transaction.employeeID.key),
              ],
            ),
          ),
          FittedBox(
            child: Row(
              children: [
                Text('Amount Paid: '),
                Text(widget.transaction.amountPaid.toString()),
              ],
            ),
          ),
          FittedBox(
            child: Row(
              children: [
                Text('Discount: '),
                Text(widget.transaction.customerDiscount.toString()),
              ],
            ),
          ),
          FittedBox(
            child: Row(
              children: [
                Text('Amounts Receivable: '),
                Text(widget.transaction.accountsReceivable.toString()),
              ],
            ),
          ),
        ],
      ),
      trailing: Icon(Icons.arrow_downward),
    );
  }
}
