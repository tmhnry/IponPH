import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './distribution_notification.dart';
import './inventory_item_selector.dart';
import './item_type_selector.dart';
import './distribution_field.dart';
import '../../../layout/names.dart';
import '../../../models/inventory_item_model.dart';
import '../../../models/item_type_model.dart';
import '../../../models/distribution_item_model.dart';

class DistributionDialog extends StatefulWidget {
  @override
  _DistributionDialogState createState() => _DistributionDialogState();
}

class _DistributionDialogState extends State<DistributionDialog> {
  late final TextEditingController itemIDController;
  late final TextEditingController itemNameController;
  late final TextEditingController itemDistributorController;
  late final TextEditingController itemPriceController;
  late final TextEditingController itemCostController;
  late final TextEditingController itemQuantityController;
  late String title;
  ItemTypeModel? itemType;
  InventoryItemModel? inventoryItem;

  bool newProduct = false;

  Map<String, TextEditingController> get namesWithControllers => {
        ControllerNames.itemIDName: itemIDController,
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
    itemIDController = TextEditingController();
    itemNameController = TextEditingController();
    itemDistributorController = TextEditingController();
    itemPriceController = TextEditingController();
    itemCostController = TextEditingController();
    itemQuantityController = TextEditingController();
    title = 'EXISTING';
    super.initState();
  }

  void dispose() {
    clearControllers();
    disposeControllers();
    // AppDatabase.instance.close();
    super.dispose();
  }

  void toggleExistingOrNewProduct() {
    setState(() {
      newProduct = !newProduct;
      itemType = null;
      clearControllers();
      if (newProduct) generateRandomIDString();
      title = newProduct ? 'NEW' : 'EXISTING';
    });
  }

  void createDistributionItem() {
    final ItemTypeModel? itemType = this.itemType;
    if (itemType != null) {
      DistributionItems.createDistributionItem(
        itemIDString: itemIDController.text,
        itemType: itemType,
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
    } else
      throw Exception('createDistributionItem: itemType evaluated to null');
  }

  ItemTypeModel? getItemType() => itemType;

  TextEditingController? get itemTypeController {
    ItemTypeModel? itemType = this.itemType;
    if (itemType != null) {
      return TextEditingController(
        text: itemType.itemTypeName,
      );
    }
    return null;
  }

  void setItemType(ItemTypeModel itemType) => setState(
        () => this.itemType = itemType,
      );

  void generateRandomIDString() =>
      itemIDController.text = InventoryItems.generateRandomIDString();

  @override
  Widget build(BuildContext context) {
    Provider.of<DistributionItems>(context);
    return AlertDialog(
      backgroundColor: Color.fromRGBO(6, 57, 84, 1),
      title: const Text(
        'Delivery Form',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          child: Column(
            children: [
              Center(
                child: TextButton(
                  onPressed: () => toggleExistingOrNewProduct(),
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.orange, fontSize: 16),
                  ),
                ),
              ),
              newProduct
                  ? Container(
                      child: Column(
                        children: [
                          ItemTypeSelector(
                            getItemType: getItemType,
                            setItemType: setItemType,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  readOnly: true,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.orange),
                                  controller: itemIDController,
                                  decoration: InputDecoration(
                                    labelText: 'Identifier',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => generateRandomIDString(),
                                child: Icon(
                                  Icons.vpn_key_outlined,
                                  color: Colors.orange,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  : InventoryItemSelector(
                      itemIDController: itemIDController,
                      itemNameController: itemNameController,
                      itemPriceController: itemPriceController,
                      setItemType: setItemType,
                    ),
              DistributionField(
                itemNameController,
                title: ControllerNames.itemName,
                readOnly: !newProduct,
              ),
              newProduct
                  // ? DistributionField(
                  //     _controllers['typeController']!,
                  //     title: 'Product Type',
                  //     readOnly: false,
                  //   )
                  ? SizedBox()
                  : DistributionField(
                      itemTypeController,
                      title: ControllerNames.itemTypeName,
                      readOnly: true,
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
                readOnly: !newProduct,
              ),
              DistributionField(
                itemQuantityController,
                title: ControllerNames.itemQuantityName,
                readOnly: false,
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.deepOrange,
                elevation: 8,
                onPressed: () {
                  if (InventoryItems.inventoryItemsContainName(
                          itemNameController.text) &&
                      newProduct)
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => DistributionNotification(
                        itemNameController: itemNameController,
                        clearControllers: clearControllers,
                        createDistributionItem: createDistributionItem,
                      ),
                    );
                  else {
                    createDistributionItem();
                    clearControllers();
                  }
                },
                child: const Text(
                  'Add Product',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
