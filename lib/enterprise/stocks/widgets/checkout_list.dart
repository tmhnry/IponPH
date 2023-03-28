import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/checkout_item_model.dart';
import '../../../models/customer_model.dart';
import '../../../models/inventory_item_model.dart';

class CheckoutList extends StatefulWidget {
  final void Function(CustomerModel? customer) rebuildCheckoutScreen;
  CheckoutList({required this.rebuildCheckoutScreen});

  @override
  CheckoutListState createState() => CheckoutListState();
}

class CheckoutListState extends State<CheckoutList> {
  @override
  Widget build(BuildContext context) {
    Provider.of<CheckoutItems>(context);
    Provider.of<InventoryItems>(context);

    return Expanded(
      child: ListView.builder(
        itemCount: CheckoutItems.checkoutList.length,
        itemBuilder: (context, index) {
          final InventoryItemModel inventoryItem =
              CheckoutItems.checkoutList[index].inventoryItem;
          return ListTile(
            leading: Text(
              CheckoutItems.checkoutList[index].checkoutItemQuantity.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            title: Text(
              inventoryItem.itemName,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              '\₱ ' +
                  CheckoutItems.checkoutList[index].checkoutItemAmount
                      .toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                widget.rebuildCheckoutScreen(
                  null,
                );
                returnInventoryItem(
                  CheckoutItems.checkoutList[index],
                );
              },
              icon: Icon(Icons.remove),
            ),
          );
        },
      ),
    );
  }

  void returnInventoryItem(
    CheckoutItemModel checkoutItem,
  ) {
    InventoryItems.updateInventoryItem(
      itemID: checkoutItem.inventoryItem.itemID,
      itemQuantity: checkoutItem.inventoryItem.itemQuantity +
          checkoutItem.checkoutItemQuantity,
    );
    CheckoutItems.deleteCheckoutItem(
      checkoutItem.checkoutItemKey,
    );
  }
}
