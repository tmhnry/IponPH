import 'package:flutter/material.dart';
import './item_type.dart';
import '../../../models/item_type_model.dart';

class ItemTypeGrid extends StatelessWidget {
  final List<ItemTypeModel> typeGrid;
  ItemTypeGrid(this.typeGrid);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 1.0,
      padding: EdgeInsets.only(left: 16, right: 16),
      crossAxisCount: 1,
      crossAxisSpacing: 18,
      mainAxisSpacing: 50,
      children: typeGrid
          .map(
            (itemType) => ItemType(
              itemType,
            ),
          )
          .toList(),
    );
  }
}
