import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/item_type_grid.dart';
import '../../../models/item_type_model.dart';

class ProductTypeScreen extends StatefulWidget {
  static const String routeName = 'product-type';
  const ProductTypeScreen({Key? key}) : super(key: key);

  @override
  _ProductTypeScreenState createState() => _ProductTypeScreenState();
}

class _ProductTypeScreenState extends State<ProductTypeScreen> {
  @override
  Widget build(BuildContext context) {
    final itemTypes = Provider.of<ItemTypes>(context);
    final typeGrid = itemTypes.itemTypes.values.toList();

    return ItemTypeGrid(
      typeGrid,
    );
  }
}
