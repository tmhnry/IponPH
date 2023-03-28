import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './checkout_fields.dart';
import '../screens/customer_selector_screen.dart';
import '../../../utils/helpers.dart';
import '../../../layout/names.dart';
import '../../../models/customer_model.dart';

class CheckoutForm extends StatefulWidget {
  final Map<String, TextEditingController> namesWithControllers;
  final void Function(CustomerModel? customer) rebuildCheckoutScreen;
  final CustomerModel? customer;

  CheckoutForm({
    required this.namesWithControllers,
    required this.rebuildCheckoutScreen,
    required this.customer,
  });

  @override
  _CheckoutFormState createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  late bool newCustomer;
  late GlobalKey<FormState> formKey;
  late Gender customerGender;
  CustomerModel? customer;

  void initState() {
    newCustomer = false;
    customerGender = Gender.Male;
    customer = widget.customer;
    formKey = GlobalKey<FormState>();

    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  // A similar method already exists in CheckoutScreen. Either pass that function to this widget or create
  // another one that can be specificallly modified
  void clearAllControllers() => widget.namesWithControllers.values.forEach(
        (
          element,
        ) =>
            element.clear(),
      );

  @override
  Widget build(BuildContext context) {
    final customers = Provider.of<Customers>(context, listen: false);
    return AlertDialog(
      backgroundColor: CustomColors.darkBlueGradient,
      title: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Text(
            'Checkout Form',
            softWrap: false,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTopButton(),
                buildCustomerOption(customers: customers, context: context),
                CheckoutFields(
                  newCustomer: newCustomer,
                  namesWithControllers: widget.namesWithControllers,
                ),
                buildSubmitButton(
                  context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String get customerName {
    TextEditingController? customerNameController =
        widget.namesWithControllers[ControllerNames.customerName];
    if (customerNameController != null)
      return customerNameController.text;
    else {
      throw Exception('CheckoutForm: customerNameController is null');
    }
  }

  double get customerDiscount {
    TextEditingController? discountController =
        widget.namesWithControllers[ControllerNames.discountName];
    if (discountController != null)
      return double.parse(discountController.text);
    else
      throw Exception('CheckoutForm: discountController is null');
  }

  Widget buildCustomerOption({
    required Customers customers,
    required BuildContext context,
  }) {
    return newCustomer
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                iconSize: customerGender == Gender.Male ? 60 : 50,
                onPressed: () => setState(
                  () => customerGender = Gender.Male,
                ),
                icon: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/male.png',
                      ),
                    ),
                    customerGender == Gender.Male
                        ? Container(
                            height: 2,
                            color: Colors.orange,
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              IconButton(
                iconSize: customerGender == Gender.Female ? 60 : 50,
                onPressed: () => setState(
                  () => customerGender = Gender.Female,
                ),
                icon: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/female.png',
                      ),
                    ),
                    customerGender == Gender.Female
                        ? Container(
                            height: 2,
                            color: Colors.orange,
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          )
        : IconButton(
            iconSize: 60,
            color: Colors.orange,
            onPressed: () =>
                Navigator.pushNamed(context, CustomerSelectorScreen.routeName)
                    .then(
              (value) {
                if (value != null) {
                  this.customer = value as CustomerModel;
                  final customer = this.customer;
                  if (customer != null) {
                    final TextEditingController? customerNameController = widget
                        .namesWithControllers[ControllerNames.customerName];
                    final TextEditingController? discountController = widget
                        .namesWithControllers[ControllerNames.discountName];
                    if (discountController != null &&
                        customerNameController != null) {
                      customerNameController.text = customer.customerName;
                      discountController.text =
                          customer.customerDiscount.toString();
                    }
                  } else
                    throw Exception(
                      'CheckoutForm: customer evaluated to null',
                    );
                }
              },
            ),
            icon: Icon(
              Icons.badge_outlined,
            ),
          );
  }

  Widget buildCustomerImage() {
    return Container(
      height: 60,
      width: 60,
      child: FittedBox(
        child: Icon(
          Icons.help_outline_outlined,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget buildTopButton() {
    return MaterialButton(
      onPressed: () {
        clearAllControllers();
        widget.rebuildCheckoutScreen(null);
        setState(() => newCustomer = !newCustomer);
      },
      child: buildTextForTopButton(newCustomer),
    );
  }

  Widget buildTextForTopButton(bool newCustomer) {
    String text = 'New';
    if (newCustomer) text = 'Existing';
    return Text(
      'Click for $text Customer',
      style: TextStyle(
        color: Colors.orange,
      ),
    );
  }

  Future<void> processSubmittedData() async {
    FormState? currentState = formKey.currentState;
    if (currentState != null) {
      if (currentState.validate()) {
        if (newCustomer) {
          final customer = await Customers.createCustomer(
            customerName: customerName,
            customerGender: customerGender,
            customerDiscount: customerDiscount,
          );
          widget.rebuildCheckoutScreen(customer);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Customer Added to Registered Customers',
                textAlign: TextAlign.center,
              ),
            ),
          );
        } else {
          widget.rebuildCheckoutScreen(customer);
          Navigator.pop(context);
        }
      }
    }
  }

  Widget buildSubmitButton(
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () => processSubmittedData(),
      child: Container(
        margin: EdgeInsets.only(top: 20),
        color: CustomColors.darkBlueGradient,
        height: 40,
        child: Center(
          child: Text(
            'SUBMIT',
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
        ),
      ),
    );
  }
}
