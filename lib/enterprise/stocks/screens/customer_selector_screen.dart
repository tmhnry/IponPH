import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/helpers.dart';
import '../../../models/customer_model.dart';

class CustomerSelectorScreen extends StatelessWidget {
  static const routeName = 'customer_selector';
  @override
  Widget build(BuildContext context) {
    final customers = Provider.of<Customers>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Customer'),
        backgroundColor: CustomColors.darkBlueGradient,
      ),
      body: customers.customers.isEmpty
          ? buildEmptyCustomer()
          : buildCustomerList(
              context,
              customers.customers.values.toList(),
            ),
    );
  }

  Widget buildEmptyCustomer() {
    return Center(
      child: Text('No Customers Found'),
    );
  }

  Widget buildCustomerList(
    BuildContext context,
    List<CustomerModel> customers,
  ) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(5),
          child: GestureDetector(
            onTap: () => Navigator.pop(
              context,
              customers[index],
            ),
            child: ListTile(
              isThreeLine: true,
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discount: ${customers[index].customerDiscount}%',
                  ),
                  Text(
                    'Address: ${customers[index].customerAddress}',
                  ),
                ],
              ),
              leading: buildLeading(customers[index]),
              title: Container(
                color: Colors.blue,
                child: Column(
                  children: [
                    Text(
                      customers[index].customerName,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      customers[index].customerID.key,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: customers.length,
    );
  }

  Widget buildLeading(CustomerModel customer) {
    if (customer.customerGender == Gender.Male) {
      return Image.asset('assets/images/male.png');
    }
    return Image.asset('assets/images/female.png');
  }
}
