import 'package:flutter/material.dart';
import '../../../models/inventory_item_model.dart';
import '../../../models/item_type_model.dart';

class InventoryItemSelector extends StatelessWidget {
  final TextEditingController itemIDController;
  final TextEditingController itemPriceController;
  final TextEditingController itemNameController;
  final void Function(ItemTypeModel itemType) setItemType;
  const InventoryItemSelector({
    required this.itemIDController,
    required this.itemPriceController,
    required this.itemNameController,
    required this.setItemType,
  });

  InventoryItemModel? get inventoryItemValue {
    if (itemIDController.text.isEmpty) return null;
    return InventoryItems.inventoryItemFromIDString(itemIDController.text);
  }

  @override
  Widget build(BuildContext context) => DropdownButton(
        dropdownColor: Color.fromRGBO(6, 57, 84, 1),
        hint: Text(
          InventoryItems.inventoryItemsFromSearch().isEmpty
              ? ''
              : 'Select Product ID',
          style: TextStyle(fontSize: 15, color: Colors.orange),
        ),
        isExpanded: true,
        // Code below is fatal if controller is not cleared:
        // value: _idController.text == '' ? null : _idController.text,
        value: inventoryItemValue,
        icon: const Icon(
          Icons.arrow_drop_down_circle_sharp,
          color: Colors.orange,
        ),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.black54),
        underline: Container(
          height: 2,
          color: Colors.white,
        ),
        onChanged: (InventoryItemModel? inventoryItem) {
          if (inventoryItem != null) {
            itemIDController.text = inventoryItem.itemID.key;
            itemNameController.text = inventoryItem.itemName;
            itemPriceController.text = inventoryItem.itemPrice.toString();
            setItemType(inventoryItem.itemType);
          }
        },
        items: InventoryItems.inventoryItemsFromSearch()
            .map<DropdownMenuItem<InventoryItemModel>>(
              (InventoryItemModel inventoryItem) => DropdownMenuItem(
                value: inventoryItem,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inventoryItem.itemID.key,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.orange,
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        inventoryItem.itemName,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
            .toList(),
      );
}
