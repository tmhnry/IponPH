import 'package:flutter/material.dart';
import 'package:iponph/db/local/app_db.dart';
import 'package:provider/provider.dart';
import './distribution_tile.dart';
import '../../../utils/helpers.dart';
import '../../../models/inventory_item_model.dart';
import '../../../models/distribution_item_model.dart';

class PendingDailyDistribution extends StatefulWidget {
  static const String id = 'daily_distribution_pending';

  final String search;
  const PendingDailyDistribution(
    this.search,
  );

  @override
  _PendingDailyDistributionState createState() =>
      _PendingDailyDistributionState();
}

class _PendingDailyDistributionState extends State<PendingDailyDistribution> {
  bool isLoading = false;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void didUpdateWidget(PendingDailyDistribution oldWidget) {
    refresh();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // AppDatabase.instance.close();
    super.dispose();
  }

  Future refresh() async {
    setState(() => this.isLoading = true);
    await readAllDistributionItems();
    await Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(
        () => this.isLoading = false,
      ),
    );
  }

  List<DistributionItemModel> get dailyDistributionItemsFromSearch =>
      DistributionItems.distributionItemsFromSearch(
        search: widget.search,
        frequency: Frequency.Daily,
      );

  List<DistributionItemModel> get pendingDailyDistributionItems =>
      dailyDistributionItemsFromSearch
          .where(
            (distributionItem) => !distributionItem.isAdded,
          )
          .toList();

  Location? itemLocation(
    int locationIndex,
  ) {
    if (pendingDailyDistributionItems.length == 1) return Location.Only;

    if (locationIndex == 0) return Location.Beginning;

    if (locationIndex == pendingDailyDistributionItems.length - 1)
      return Location.End;

    return null;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<InventoryItems>(context);
    Provider.of<DistributionItems>(context);

    return isLoading
        ? buildLoadingIndicator()
        : pendingDailyDistributionItems.isEmpty
            ? buildEmptyDistribution(context)
            : Expanded(
                child: Column(
                  children: [
                    buildPendingDailyDistributionItems(),
                    buildFooter(),
                  ],
                ),
              );
  }

  Widget buildPendingDailyDistributionItems() =>
      // Flexible == Expanded ?
      Expanded(
        child: Container(
          margin: EdgeInsets.only(top: 15),
          child: ListView.builder(
            itemCount: pendingDailyDistributionItems.length,
            itemBuilder: (context, index) {
              final DistributionItemModel distributionItem =
                  pendingDailyDistributionItems[index];
              return Container(
                margin: EdgeInsets.only(bottom: 2),
                child: GestureDetector(
                  onTap: distributionItem.isAdded
                      ? () => null
                      : () => showDialog(
                            context: context,
                            builder: (context) => buildDialog(
                              context: context,
                              distributionItem: distributionItem,
                            ),
                          ),
                  child: DistributionTile(
                    distributionItem: pendingDailyDistributionItems[index],
                    location: itemLocation(index),
                  ),
                ),
              );
            },
          ),
        ),
      );

  Widget buildLoadingIndicator() => Expanded(
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 4,
            color: Colors.orange,
          ),
        ),
      );

  Widget buildFooter() => Container(
        height: 45,
        child: Center(
          child: Icon(
            Icons.more_horiz,
            color: Colors.orange,
            size: 30,
          ),
        ),
      );

  Widget buildEmptyDistribution(BuildContext context) => Expanded(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: Center(
            child: SingleChildScrollView(
              child: isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      ],
                    )
                  : Center(
                      child: Container(
                        child: Column(
                          children: [
                            IconButton(
                              iconSize: 100,
                              onPressed: () => refresh(),
                              icon: Icon(
                                Icons.restart_alt,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              'No Products Found',
                              style: TextStyle(
                                color: Color.fromRGBO(5, 111, 146, 1),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      );

  Widget buildDialog({
    required BuildContext context,
    required DistributionItemModel distributionItem,
  }) =>
      AlertDialog(
        title: Icon(
          Icons.warning,
          size: 50,
          color: Colors.red,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to confirm this product?, this process cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (InventoryItems.inventoryItemsContainIDString(
                        distributionItem.itemIDString,
                      )) {
                        InventoryItemModel inventoryItem =
                            InventoryItems.inventoryItemFromIDString(
                          distributionItem.itemIDString,
                        );
                        InventoryItems.updateInventoryItem(
                          itemID: inventoryItem.itemID,
                          itemQuantity: inventoryItem.itemQuantity +
                              distributionItem.itemQuantity,
                        );
                      } else {
                        InventoryItems.createInventoryItem(
                          itemIDString: distributionItem.itemIDString,
                          itemQuantity: distributionItem.itemQuantity,
                          itemName: distributionItem.itemName,
                          itemPrice: distributionItem.itemPrice,
                          itemType: distributionItem.itemType,
                        );
                      }
                      DistributionItems.updateDistributionItem(
                        distributionItemKey:
                            distributionItem.distributionItemKey,
                        isAdded: true,
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(color: Colors.blue, width: 2),
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'CANCEL',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
