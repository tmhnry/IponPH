import 'package:flutter/material.dart';
import '../../../models/item_type_model.dart';

class ItemTypeSelector extends StatelessWidget {
  final ItemTypeModel? Function() getItemType;
  final void Function(ItemTypeModel itemType) setItemType;
  ItemTypeSelector({
    required this.getItemType,
    required this.setItemType,
  });

  ItemTypeModel? get itemTypeValue {
    if (ItemTypes.itemTypesFromSearch().length <= 1)
      return ItemTypes.itemTypesFromSearch().elementAt(0);

    if (getItemType() == null) return null;
    return getItemType();
  }

  @override
  Widget build(BuildContext context) => Card(
        color: Colors.white,
        elevation: 8,
        margin: EdgeInsets.only(top: 5),
        child: DropdownButton(
          isDense: true,
          dropdownColor: Color.fromRGBO(6, 57, 84, 1),
          hint: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Text(
                'Item Type',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          icon: const Icon(
            Icons.arrow_drop_down_outlined,
            color: Colors.orange,
          ),
          value: itemTypeValue,
          underline: SizedBox(
            height: 0,
          ),
          onChanged: (ItemTypeModel? itemType) {
            if (itemType != null)
              setItemType(itemType);
            else
              throw Exception(
                'buildDropDownOrTextField: itemType evaluated to null',
              );
          },
          items: ItemTypes.itemTypesFromSearch()
              .map<DropdownMenuItem<ItemTypeModel>>(
                (ItemTypeModel itemType) => DropdownMenuItem(
                  value: itemType,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      FittedBox(
                        child: Text(
                          itemType.itemTypeName,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  // child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     // FittedBox(
                  //     //   child: Text(
                  //     //     itemType.itemTypeName,
                  //     //     style: TextStyle(
                  //     //       fontSize: 15,
                  //     //       color: Colors.white,
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //   ],
                  // ),
                ),
              )
              .toList(),
        ),
      );
}
