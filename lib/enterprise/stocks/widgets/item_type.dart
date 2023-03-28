import 'package:flutter/material.dart';
import '../../../models/item_type_model.dart';

class ItemType extends StatefulWidget {
  final ItemTypeModel itemType;
  ItemType(this.itemType);

  @override
  _ItemTypeState createState() => _ItemTypeState();
}

class _ItemTypeState extends State<ItemType> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          child: Container(
            height: 300,
            width: 300,
            child: Image.asset('assets/images/seal.png'),
          ),
        ),
        Positioned(
          child: ClipOval(
            child: Container(
              height: 150,
              width: 150,
              child: widget.itemType.itemTypeFigure,
            ),
          ),
        ),
        Positioned(
          child: Container(
            width: 500,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
            color: Color.fromRGBO(255, 0, 0, 0.6),
            child: Text(
              widget.itemType.itemTypeName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
