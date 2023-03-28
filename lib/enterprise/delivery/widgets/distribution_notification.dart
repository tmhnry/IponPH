import 'package:flutter/material.dart';
import '../../../models/inventory_item_model.dart';

class DistributionNotification extends StatelessWidget {
  final TextEditingController itemNameController;
  final void Function() createDistributionItem;
  final void Function() clearControllers;
  const DistributionNotification({
    required this.itemNameController,
    required this.clearControllers,
    required this.createDistributionItem,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Container(
          child: Column(
            children: [
              Text(
                'Inventory contains product ${InventoryItems.inventoryItemsFromSearch(search: itemNameController.text).elementAt(0).itemName} with ID:',
                textAlign: TextAlign.center,
              ),
              Text(
                '${InventoryItems.inventoryItemsFromSearch(search: itemNameController.text).elementAt(0).itemID}',
                style: TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text('Do You Wish to Continue?'),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      createDistributionItem();
                      clearControllers();
                      Navigator.of(context).pop();
                    },
                    child: Text('Yes'),
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('No'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
