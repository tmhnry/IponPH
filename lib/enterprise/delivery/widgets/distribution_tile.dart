import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './edit_dialog.dart';
import '../../../utils/helpers.dart';
import '../../../models/distribution_item_model.dart';
import '../../../models/item_type_model.dart';

class DistributionTile extends StatefulWidget {
  final DistributionItemModel distributionItem;
  final Location? location;

  DistributionTile({
    required this.distributionItem,
    required this.location,
  });

  @override
  _DistributionTileState createState() => _DistributionTileState();
}

class _DistributionTileState extends State<DistributionTile> {
  @override
  Widget build(BuildContext context) {
    Provider.of<DistributionItems>(context);
    Provider.of<ItemTypes>(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 50,
      ),
      child: Dismissible(
        key: Key(widget.distributionItem.distributionItemKey.key),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
        ),
        movementDuration: Duration(milliseconds: 500),
        resizeDuration: Duration(milliseconds: 800),
        dismissThresholds: {DismissDirection.endToStart: 0.2},
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (context) => buildDeleteDialog(context),
          );
        },
        onDismissed: (direction) {
          DistributionItems.deleteDistributionItem(
            widget.distributionItem.distributionItemKey,
          );
        },
        child: Container(
          padding: const EdgeInsets.only(
            top: 20,
            bottom: 20,
            left: 30,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(6, 57, 84, 1),
                Color.fromRGBO(5, 111, 146, 1),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: _createBorder(widget.location),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          color: Colors.green,
                          size: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // Why Expanded Works Here?
                        // Expanded doesn't work here if Expanded above is removed.
                        Expanded(
                          child: Text(
                            widget.distributionItem.itemName,
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // Height Same as Font Size of Name
                    margin: EdgeInsets.only(right: 10),
                    child: widget.distributionItem.isAdded
                        ? Icon(
                            Icons.verified,
                            color: Colors.green,
                          )
                        : GestureDetector(
                            child: Icon(
                              Icons.drive_file_rename_outline,
                              color: Colors.orange,
                            ),
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) =>
                                  EditDialog(widget.distributionItem),
                            ),
                          ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 4),
                child: Text(
                  widget.distributionItem.itemIDString,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Cost:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            FittedBox(
                              child: Text(
                                'PHP ${widget.distributionItem.itemCost.toString()}',
                                maxLines: 6,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Quantity:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${widget.distributionItem.itemQuantity.toString()} Items',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDeleteDialog(BuildContext context) => AlertDialog(
        title: Text(
          'Warning!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontSize: 30,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                'Deleting this item may void out valuable data. Do you wish to continue?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    color: Colors.green,
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Continue'),
                  ),
                  MaterialButton(
                    color: Colors.red,
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Cancel'),
                  )
                ],
              )
            ],
          ),
        ),
      );

  BorderRadius? _createBorder(Location? _location) {
    if (_location == Location.Only) {
      return BorderRadius.all(Radius.circular(10));
    }
    if (_location == Location.Beginning) {
      return BorderRadius.vertical(
        top: Radius.circular(10),
      );
    }
    if (_location == Location.End) {
      return BorderRadius.vertical(
        bottom: Radius.circular(10),
      );
    }
  }
}
