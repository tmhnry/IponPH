import 'package:flutter/material.dart';
import './distribution_field.dart';
import '../../../layout/names.dart';
import '../../../models/distribution_item_model.dart';
import '../../../models/inventory_item_model.dart';
import '../../../models/item_type_model.dart';

class EditDialog extends StatefulWidget {
  final DistributionItemModel distributionItem;
  const EditDialog(this.distributionItem);

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late final TextEditingController itemTypeController;
  late final TextEditingController itemNameController;
  late final TextEditingController itemDistributorController;
  late final TextEditingController itemPriceController;
  late final TextEditingController itemCostController;
  late final TextEditingController itemQuantityController;
//  actually selectedItemType (this is intentional for homogeneity)
  ItemTypeModel? itemType;

  Map<String, TextEditingController> get namesWithControllers => {
        ControllerNames.itemTypeName: itemTypeController,
        ControllerNames.itemName: itemNameController,
        ControllerNames.itemDistributorName: itemDistributorController,
        ControllerNames.itemPriceName: itemPriceController,
        ControllerNames.itemCostName: itemCostController,
        ControllerNames.itemQuantityName: itemQuantityController,
      };

  void clearControllers() {
    namesWithControllers.values.forEach(
      (controller) => controller.clear(),
    );
  }

  void disposeControllers() {
    namesWithControllers.values.forEach(
      (controller) => controller.dispose(),
    );
  }

  @override
  void initState() {
    itemTypeController = TextEditingController(
        text: widget.distributionItem.itemType.itemTypeName);
    itemNameController =
        TextEditingController(text: widget.distributionItem.itemName);
    itemDistributorController =
        TextEditingController(text: widget.distributionItem.itemDistributor);
    itemPriceController = TextEditingController(
        text: widget.distributionItem.itemPrice.toString());
    itemCostController = TextEditingController(
        text: widget.distributionItem.itemCost.toString());
    itemQuantityController = TextEditingController(
        text: widget.distributionItem.itemQuantity.toString());
    super.initState();
  }

  @override
  void dispose() {
    clearControllers();
    disposeControllers();
    super.dispose();
  }

  bool get inventoryItemsContainIDString =>
      InventoryItems.inventoryItemsContainIDString(
        widget.distributionItem.itemIDString,
      );

  void updateDistributionItem() {
    DistributionItems.updateDistributionItem(
      distributionItemKey: widget.distributionItem.distributionItemKey,
      itemType: itemType ?? widget.distributionItem.itemType,
      itemName: itemNameController.text,
      itemDistributor: itemDistributorController.text,
      itemPrice: double.parse(
        itemPriceController.text,
      ),
      itemCost: double.parse(
        itemCostController.text,
      ),
      itemQuantity: int.parse(
        itemQuantityController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: Color.fromRGBO(6, 57, 84, 1),
        title: Center(
          child: Text(
            'Edit Product',
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              buildDropDownOrTextField(),
              DistributionField(
                itemNameController,
                title: ControllerNames.itemName,
                readOnly: inventoryItemsContainIDString,
              ),
              DistributionField(
                itemDistributorController,
                title: ControllerNames.itemDistributorName,
                readOnly: false,
              ),
              DistributionField(
                itemCostController,
                title: ControllerNames.itemCostName,
                readOnly: false,
              ),
              DistributionField(
                itemPriceController,
                title: ControllerNames.itemPriceName,
                readOnly: inventoryItemsContainIDString,
              ),
              DistributionField(
                itemQuantityController,
                title: ControllerNames.itemQuantityName,
                readOnly: false,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    color: Colors.orange,
                    onPressed: () {
                      updateDistributionItem();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: Colors.red,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );

  Widget buildDropDownOrTextField() => inventoryItemsContainIDString
      ? DistributionField(
          itemTypeController,
          title: widget.distributionItem.itemType.itemTypeName,
          readOnly: true,
        )
      : DropdownButton(
          dropdownColor: Color.fromRGBO(6, 57, 84, 1),
          hint: Text(
            widget.distributionItem.itemType.itemTypeName,
            style: TextStyle(
              fontSize: 15,
              color: Colors.orange,
            ),
          ),
          isExpanded: true,
          value: itemType,
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
          onChanged: (ItemTypeModel? itemType) {
            if (itemType != null) {
              this.itemType = itemType;
              setState(() => null);
            } else
              throw Exception(
                'buildDropDownOrTextField: selectedItemType evaluated to null',
              );
          },
          items: ItemTypes.itemTypesFromSearch()
              .map<DropdownMenuItem<ItemTypeModel>>(
                (ItemTypeModel itemType) => DropdownMenuItem(
                  value: itemType,
                  child: FittedBox(
                    child: Text(
                      itemType.itemTypeName,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );
}
