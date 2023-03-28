import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './manage_customer_screen.dart';
import '../../../utils/helpers.dart';
import '../../../models/customer_model.dart';

class CustomerProfileScreen extends StatefulWidget {
  static const String routeName = 'customer_profile';

  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  late TextEditingController customerNameController;
  late TextEditingController customerGenderController;
  late TextEditingController customerContactNumberController;
  late TextEditingController customerAddressController;
  late TextEditingController customerDescriptionController;
  Map<String, Object?>? arguments;
  bool readOnly = true;

  @override
  void initState() {
    customerNameController = TextEditingController();
    customerGenderController = TextEditingController();
    customerContactNumberController = TextEditingController();
    customerAddressController = TextEditingController();
    customerDescriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    customerNameController.dispose();
    customerGenderController.dispose();
    customerContactNumberController.dispose();
    customerAddressController.dispose();
    customerDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customers = Provider.of<Customers>(context);
    final ModalRoute<Object?>? route = ModalRoute.of(context);
    if (route != null) {
      Map<String, Object?>? routeArguments =
          route.settings.arguments as Map<String, Object?>?;
      if (routeArguments != null) {
        arguments = routeArguments;
        customerNameController.text =
            routeArguments[CustomerFields.customerName] as String;
        customerGenderController.text =
            routeArguments[CustomerFields.customerGender] == 1
                ? 'Male'
                : 'Female';
        customerAddressController.text =
            routeArguments[CustomerFields.customerAddress] as String;
        customerDescriptionController.text =
            routeArguments[CustomerFields.customerDescription] as String;
        customerContactNumberController.text =
            routeArguments[CustomerFields.customerContactNumber] as String;
      }
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_left),
          )
        ],
        title: Text('Customer Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(Icons.transfer_within_a_station),
              MaterialButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    ManageCustomerScreen.routeName,
                  );
                },
                child: Text('Discount and Transaction History'),
              ),
            ],
          ),
          IconButton(
            onPressed: () => setState(
              () => readOnly = false,
            ),
            icon: Icon(Icons.edit),
          ),
          TextField(
            controller: customerNameController,
            readOnly: readOnly,
            decoration: InputDecoration(
              hintText: 'Name',
              prefixIcon: Icon(Icons.badge),
            ),
          ),
          TextField(
            controller: customerGenderController,
            readOnly: readOnly,
            decoration: InputDecoration(
              hintText: 'Gender: Male or Female',
              prefixIcon: Icon(Icons.people_alt),
            ),
          ),
          TextField(
            controller: customerAddressController,
            readOnly: readOnly,
            decoration: InputDecoration(
              hintText: 'Address',
              prefixIcon: Icon(
                Icons.place_rounded,
              ),
            ),
          ),
          TextField(
            controller: customerContactNumberController,
            readOnly: readOnly,
            decoration: InputDecoration(
              hintText: 'Tel / Phone no.',
              prefixIcon: Icon(Icons.phone_callback),
            ),
          ),
          TextField(
            controller: customerDescriptionController,
            readOnly: readOnly,
            decoration: InputDecoration(
              hintText: 'Description',
              prefixIcon: Icon(Icons.description),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          readOnly
              ? SizedBox()
              : TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Customers.createCustomer(
                      customerName: customerNameController.text,
                      customerGender: customerGenderController.text == 'Female'
                          ? Gender.Female
                          : Gender.Male,
                      customerContactNumber:
                          customerContactNumberController.text,
                      customerAddress: customerAddressController.text,
                      customerDescription: customerDescriptionController.text,
                      customerDiscount: 0,
                      customerTransactions: {},
                    );
                  },
                  child: Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
        ],
      ),
    );
  }
}
