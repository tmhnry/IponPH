import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './inventory_item.dart';
import '../../../models/checkout_item_model.dart';
import '../../../models/inventory_item_model.dart';

class InventoryGrid extends StatefulWidget {
  final String search;

  InventoryGrid(
    this.search,
  );

  @override
  _InventoryGridState createState() => _InventoryGridState();
}

class _InventoryGridState extends State<InventoryGrid> {
  bool isLoading = false;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void didUpdateWidget(InventoryGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refresh() async {
    setState(() => isLoading = true);
    readAllInventoryItems();
    await Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(() => this.isLoading = false),
    );
  }

  List<InventoryItemModel> get inventoryItemsFromSearch =>
      InventoryItems.inventoryItemsFromSearch(
        search: widget.search,
      );

  @override
  Widget build(BuildContext context) {
    Provider.of<InventoryItems>(context);

    Provider.of<CheckoutItems>(context);

    return isLoading
        ? buildLoadingScreen()
        : inventoryItemsFromSearch.isEmpty
            ? buildEmptyInventory()
            : Expanded(
                child: Column(
                  children: [
                    buildSwitch(),
                    Flexible(
                      child: GridView.count(
                        childAspectRatio: 1.0,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        crossAxisCount: 2,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        children: inventoryItemsFromSearch
                            .map(
                              (inventoryItem) => InventoryItem(inventoryItem),
                            )
                            .toList(),
                      ),
                    ),
                    buildFooter(),
                  ],
                ),
              );
  }

  Widget buildLoadingScreen() => Expanded(
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 4,
            color: Colors.orange,
          ),
        ),
      );

  Widget buildSwitch() => Container(
        margin: EdgeInsets.only(left: 50, top: 15, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 10,
                  child: Switch(
                    value: true,
                    onChanged: (bool value) {},
                    activeColor: Colors.white,
                    activeTrackColor: Colors.orange,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35),
                  child: Text(
                    'Approved Products',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget buildFooter() => Container(
        height: 45,
        child: Center(
          child: Icon(
            Icons.more_horiz,
            color: Colors.orange,
            size: 30,
          ),
        ),
      );

  Widget buildEmptyInventory() => Expanded(
        child: Container(
          color: Colors.white,
          child: Center(
            child: SingleChildScrollView(
              child: isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        child: Column(
                          children: [
                            IconButton(
                              iconSize: 100,
                              onPressed: () => refresh(),
                              icon: Icon(
                                Icons.restart_alt,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'No Products Found',
                              style: TextStyle(
                                color: Color.fromRGBO(5, 111, 146, 1),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      );
}
