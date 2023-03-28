import 'package:flutter/material.dart';
import '../widgets/distribution_tile.dart';
import '../../../utils/helpers.dart';
import '../../../models/distribution_item_model.dart';

class ApprovedDailyDistribution extends StatefulWidget {
  static const String id = 'daily_distribution_approved';

  final String search;
  const ApprovedDailyDistribution(
    this.search,
  );

  @override
  _ApprovedDailyDistributionState createState() =>
      _ApprovedDailyDistributionState();
}

class _ApprovedDailyDistributionState extends State<ApprovedDailyDistribution> {
  bool isLoading = false;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void didUpdateWidget(ApprovedDailyDistribution oldWidget) {
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

  List<DistributionItemModel> get approvedDailyDistributionItems =>
      dailyDistributionItemsFromSearch
          .where(
            (distributionItem) => distributionItem.isAdded,
          )
          .toList();

  Location? itemLocation(
    int locationIndex,
  ) {
    if (approvedDailyDistributionItems.length == 1) return Location.Only;

    if (locationIndex == 0) return Location.Beginning;

    if (locationIndex == approvedDailyDistributionItems.length - 1)
      return Location.End;

    return null;
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? buildLoadingIndicator()
      : approvedDailyDistributionItems.isEmpty
          ? buildEmptyDistribution()
          : Expanded(
              child: Column(
                children: [
                  buildApprovedDailyDistributionItems(),
                  buildFooter(),
                ],
              ),
            );

  Widget buildApprovedDailyDistributionItems() =>
      // Flexible == Expanded ?
      Expanded(
        child: Container(
          margin: EdgeInsets.only(top: 15),
          child: ListView.builder(
            itemCount: approvedDailyDistributionItems.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 2),
                child: DistributionTile(
                  distributionItem: approvedDailyDistributionItems[index],
                  location: itemLocation(index),
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

  Widget buildEmptyDistribution() => Expanded(
        child: Container(
          color: Colors.white,
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
}
