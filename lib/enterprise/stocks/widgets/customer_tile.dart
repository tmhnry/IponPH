import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../associations/screens/customer_profile_screen.dart';
import '../../../utils/helpers.dart';
import '../../../models/transaction_model.dart';
import '../../../models/employee_model.dart';
import '../../../models/customer_model.dart';

class CustomerTile extends StatefulWidget {
  final CustomerModel customer;
  final void Function(CustomerModel customer) setCustomer;
  CustomerTile({
    required this.customer,
    required this.setCustomer,
  });

  @override
  _CustomerTileState createState() => _CustomerTileState();
}

class _CustomerTileState extends State<CustomerTile> {
  late TextEditingController amountController;

  @override
  void initState() {
    amountController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    amountController.clear();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Customers>(context);
    return Container(
      margin: EdgeInsets.all(5),
      child: GestureDetector(
        onDoubleTap: () => Navigator.pushNamed(
          context,
          CustomerProfileScreen.routeName,
          arguments: widget.customer.toJson(),
        ),
        onLongPress: () => Navigator.pushNamed(
          context,
          CustomerProfileScreen.routeName,
          arguments: widget.customer.toJson(),
        ),
        onTap: () => widget.setCustomer(widget.customer),
        child: ListTile(
          isThreeLine: true,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discount: ${widget.customer.customerDiscount}%',
              ),
              Text(
                'Address: ${widget.customer.customerAddress}',
              ),
            ],
          ),
          leading: buildLeading(),
          title: Container(
            color: Colors.blue,
            child: Column(
              children: [
                Text(
                  widget.customer.customerName,
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.customer.customerID.key,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          trailing: widget.customer.accountsReceivable > 0
              ? IconButton(
                  icon: Icon(Icons.payment),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => buildDialog(context),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Widget buildLeading() {
    if (widget.customer.customerGender == Gender.Male)
      return Image.asset('assets/images/male.png');
    return Image.asset('assets/images/female.png');
  }

  Widget buildDialog(BuildContext context) => AlertDialog(
        title: Text('Payment'),
        content: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: 'Enter Payment Amount'),
              controller: amountController,
            ),
            OutlinedButton(
              onPressed: () {
                Transactions.createTransaction(
                  customerID: widget.customer.customerID,
                  employeeID: Employees.activeEmployee.employeeID,
                  amountPaid: double.parse(amountController.text),
                  discount: 0,
                );
                Navigator.pop(context);
              },
              child: Text('Submit'),
            )
          ],
        ),
      );
}
