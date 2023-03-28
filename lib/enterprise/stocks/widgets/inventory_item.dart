import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/checkout_item_model.dart';
import '../../../models/inventory_item_model.dart';

class InventoryItem extends StatefulWidget {
  final InventoryItemModel inventoryItem;
  InventoryItem(this.inventoryItem);

  @override
  _InventoryItemState createState() => _InventoryItemState();
}

class _InventoryItemState extends State<InventoryItem> {
  late final quantityController;
  late final priceController;

  @override
  void initState() {
    quantityController = TextEditingController();
    priceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    quantityController.clear();
    priceController.clear();
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<InventoryItems>(context);
    // final _reportChanges = Provider.of<ReportsProvider>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Purchase Form'),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: quantityController,
                          decoration: InputDecoration(hintText: 'Quantity'),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: const BorderSide(
                                    color: Colors.blue, width: 2),
                              ),
                            ),
                          ),
                          onPressed: widget.inventoryItem.itemQuantity == 0
                              ? null
                              : () {
                                  InventoryItems.updateInventoryItem(
                                    itemID: widget.inventoryItem.itemID,
                                    itemQuantity:
                                        widget.inventoryItem.itemQuantity -
                                            -int.parse(quantityController.text),
                                  );
                                  // inventoryItems.updateItemQuantity(
                                  //   widget.inventoryItem,
                                  //   int.parse(quantityController.text),
                                  // );

                                  CheckoutItems.createCheckoutItem(
                                    inventoryItem: widget.inventoryItem,
                                    checkoutItemQuantity:
                                        int.parse(quantityController.text),
                                  );
                                  quantityController.clear();
                                  Navigator.of(context).pop();
                                },
                          child: const Text(
                            'Confirm',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: widget.inventoryItem.itemType.itemTypeFigure,
              ),
              Text(
                '${widget.inventoryItem.itemQuantity}',
                style: TextStyle(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 7
                    ..color = Colors.black,
                  // color: Colors.orange,
                  fontSize: 70,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${widget.inventoryItem.itemQuantity}',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 70,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Positioned(
                right: 15,
                top: 5,
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Update Price'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: [
                                TextField(
                                  decoration:
                                      InputDecoration(hintText: 'New Price'),
                                  controller: priceController,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        side: BorderSide(
                                            color: Colors.blue, width: 2),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    final InventoryItemModel inventoryItem =
                                        widget.inventoryItem;

                                    InventoryItems.updateInventoryItem(
                                      itemID: inventoryItem.itemID,
                                      itemPrice: double.parse(
                                        priceController.text,
                                      ),
                                    );
                                    priceController.clear();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Change Price',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.drive_file_rename_outline_rounded,
                    color: Colors.white70,
                    size: 50,
                  ),
                ),
              ),
            ],
          ),
          // child: widget.inventoryItem.type.figure,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Container(
            margin: EdgeInsets.only(
              left: 5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'PHP',
                  style: TextStyle(
                    color: Colors.orange,
                  ),
                ),
                Text(
                  '${widget.inventoryItem.itemPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ),
          title: Text(
            widget.inventoryItem.itemName,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
