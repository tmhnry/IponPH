import 'package:flutter/material.dart';
import '../widgets/checkout_form.dart';
import '../widgets/checkout_list.dart';
import '../widgets/checkout_bottom_form.dart';
import '../../../layout/names.dart';
import '../../../models/customer_model.dart';
import '../../../models/checkout_item_model.dart';

class CheckOutScreen extends StatefulWidget {
  static const String routeName = 'checkout';
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  late final TextEditingController customerNameController;
  late final TextEditingController discountController;
  late final TextEditingController creditByCashController;
  late final TextEditingController creditCardNumberController;
  late String customerName;
  late String discountString;
  late String creditByCashString;
  CustomerModel? customer;

  @override
  void initState() {
    customerNameController = TextEditingController();
    creditByCashController = TextEditingController();
    creditCardNumberController = TextEditingController();
    discountController = TextEditingController();
    setStrings();
    super.initState();
  }

  @override
  void dispose() {
    customerNameController.dispose();
    creditByCashController.dispose();
    creditCardNumberController.dispose();
    discountController.dispose();
    super.dispose();
  }

  Map<String, TextEditingController> get namesWithControllers {
    return {
      ControllerNames.customerName: customerNameController,
      ControllerNames.discountName: discountController,
      ControllerNames.creditByCashName: creditByCashController,
      ControllerNames.creditCardName: creditCardNumberController,
    };
  }

  void initControllers() {
    // Redundant? see https://dart.dev/null-safety/understanding-null-safety#working-with-nullable-fields
    final CustomerModel? customer = this.customer;
    if (customer != null) {
      customerNameController.text = customer.customerName;
      discountController.text = customer.customerDiscount.toString();
    }
  }

  void clearIndividualController(TextEditingController controller) {
    controller.clear();
  }

  void clearAllControllers() {
    customerNameController.clear();
    creditByCashController.clear();
    discountController.clear();
    creditCardNumberController.clear();
  }

  void setStrings() {
    customerName = customerNameController.text;
    discountString = discountController.text;
    creditByCashString = creditByCashController.text;
  }

  void setAndClear(CustomerModel? customer) {
    clearIndividualController(customerNameController);
    clearIndividualController(discountController);
    this.customer = customer;
    initControllers();
    setStrings();
    setState(
      () => null,
    );
  }

  Widget buildEmptyCheckOut() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.production_quantity_limits,
            color: Colors.red,
            size: 100,
          ),
          Text(
            'Empty Checkout',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CheckOut'),
        actions: [
          IconButton(
            onPressed: CheckoutItems.checkoutList.isEmpty
                ? () => null
                : () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => CheckoutForm(
                        namesWithControllers: namesWithControllers,
                        rebuildCheckoutScreen: setAndClear,
                        customer: customer,
                      ),
                    );
                  },
            icon: Icon(Icons.credit_card),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(5, 111, 146, 1),
              Color.fromRGBO(6, 57, 84, 1)
            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
          ),
        ),
      ),
      body: CheckoutItems.checkoutList.isEmpty
          ? buildEmptyCheckOut()
          : Column(
              children: [
                CheckoutList(
                  rebuildCheckoutScreen: setAndClear,
                ),
                CheckoutBottomForm(
                  customer: customer,
                  discountString: discountString,
                  creditByCashString: creditByCashString,
                ),
              ],
            ),
    );
  }
}
