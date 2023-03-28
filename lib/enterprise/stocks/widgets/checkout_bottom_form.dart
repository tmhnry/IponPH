import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/bluetooth_thermal_printer.dart';
import '../../../models/checkout_item_model.dart';
import '../../../models/customer_model.dart';
import '../../../models/transaction_model.dart';
import '../../../models/employee_model.dart';

class CheckoutBottomForm extends StatefulWidget {
  final CustomerModel? customer;
  final String discountString;
  final String creditByCashString;

  CheckoutBottomForm({
    required this.customer,
    required this.discountString,
    required this.creditByCashString,
  });
  @override
  _CheckoutBottomFormState createState() => _CheckoutBottomFormState();
}

class _CheckoutBottomFormState extends State<CheckoutBottomForm> {
  late TextEditingController amountController;
  bool isLoading = false;

  void initState() {
    amountController = TextEditingController();
    super.initState();
  }

  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  Map<String, Object?> confirmTransaction() {
    final double totalAmountPaid = double.parse(amountController.text);
    // CHANGE SO THAT IT WILL INCLUDE CREDIT AND DISCOUNT.
    return {
      ReceiptPrinterFields.totalAmountPaid: totalAmountPaid,
      ReceiptPrinterFields.transactionAmount:
          CheckoutItems.totalCheckoutAmount(),
      ReceiptPrinterFields.transactionChange: CheckoutItems.getChange(
        CheckoutItems.totalCheckoutAmount(),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CheckoutItems>(
      context,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total Discount: \₱ ' +
              amountFromWidgetString(widget.discountString).toStringAsFixed(2),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'Total Credit: \₱ ' +
              amountFromWidgetString(widget.creditByCashString)
                  .toStringAsFixed(2),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          ' Total: \₱ ${CheckoutItems.totalCheckoutAmount().toStringAsFixed(2)} ',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: amountController,
                onChanged: (value) => setState(() {}),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter Amount Here',
                  prefixText: 'Cash: \₱ ',
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
              width: 5,
            ),
          ],
        ),
        Text(
          ' Change: \₱ ' +
              CheckoutItems.getChange(equivalentPaidAmount).toStringAsFixed(2),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        buildConfirmButton()
      ],
    );
  }

  double amountFromWidgetString(String widgetString) {
    return double.parse(
      widgetString.isEmpty ? '0.00' : widgetString,
    );
  }

  double get equivalentPaidAmount {
    return double.parse(
          amountController.text.isEmpty ? '0.00' : amountController.text,
        ) +
        amountFromWidgetString(widget.creditByCashString) +
        amountFromWidgetString(widget.discountString);
  }

  Widget buildConfirmButton() {
    return Center(
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
        onPressed: () {
          final CustomerModel? customer = widget.customer;
          if (customer != null) {
            Transactions.createTransaction(
              checkoutList: CheckoutItems.checkoutList,
              amountPaid: double.parse(amountController.text),
              employeeID: Employees.activeEmployee.employeeID,
              customerID: customer.customerID,
              discount: amountFromWidgetString(widget.discountString),
            );
            Navigator.pushReplacementNamed(
              context,
              ReceiptPrinter.routeName,
              arguments: confirmTransaction(),
            );
            CheckoutItems.deleteAllCheckoutItems();
          }
        },
        child: const Text(
          'Confirm',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
