import 'package:flutter/material.dart';
import './customer_tile.dart';
import '../../../utils/helpers.dart';
import '../../../models/customer_model.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  late final TextEditingController searchController;
  CustomerModel? customer;
  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.clear();
    searchController.dispose();

    super.dispose();
  }

  void setCustomer(CustomerModel customer) {
    this.customer = customer;
  }

  List<CustomerModel> get customersFromSearch =>
      Customers.customersFromSearch(search: searchController.text);

  void rebuild() => setState(
        () => null,
      );
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            height: 200,
            child: customer == null
                ? Icon(Icons.question_answer)
                : buildImageContainer(),
          ),
          TextField(
            controller: searchController,
            onChanged: (_) => rebuild(),
          ),
          ListView.builder(
            itemCount:
                Customers.customersFromSearch(search: searchController.text)
                    .length,
            itemBuilder: (context, index) => CustomerTile(
              customer: customersFromSearch.elementAt(index),
              setCustomer: setCustomer,
            ),
          ),
        ],
      );

  Widget buildImageContainer() {
    final CustomerModel? customer = this.customer;
    if (customer != null) {
      if (customer.customerGender == Gender.Male)
        return Image.asset('assets/images/male.png');
      return Image.asset('assets/images/female.png');
    }
    throw Exception('buildImageContainer: customer evaluated to null');
  }
}
