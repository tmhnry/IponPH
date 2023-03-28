import 'package:flutter/material.dart';
import './checkout_screen.dart';
import './customize_inventory_screen.dart';
import '../widgets/inventory_grid.dart';

class Stocks extends StatefulWidget {
  static const String routeName = 'inventory';
  @override
  _StocksState createState() => _StocksState();
}

class _StocksState extends State<Stocks> {
  late TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void rebuild() => super.setState(
        () => null,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CheckOutScreen.routeName);
        },
        child: const Icon(Icons.add_shopping_cart_rounded),
      ),
      body: Column(
        children: [
          buildTopNavigation(),
          buildTextField(),
          InventoryGrid(
            searchController.text,
          ),
        ],
      ),
    );
  }

  Widget buildTopNavigation() => Container(
        height: 80,
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                color: Colors.orange,
                onPressed: () => null,
                child: const Text(
                  'VIEW REPORTS',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 30),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(CustomizeInventoryScreen.id);
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                        Icons.storefront_rounded,
                        color: Colors.red,
                      ),
                    ),
                    const Text(
                      'MANAGE INVENTORY',
                      style: TextStyle(
                        color: Color.fromRGBO(5, 111, 146, 1),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildTextField() => Container(
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
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) => rebuild(),
              ),
            ),
          ],
        ),
      );
}
