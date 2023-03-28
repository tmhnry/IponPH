import 'package:flutter/material.dart';
import '../../../utils/helpers.dart';
import '../../../models/distribution_item_model.dart';

class DistributionReportsScreen extends StatefulWidget {
  static const String routeName = 'distribution_reports';
  const DistributionReportsScreen({Key? key}) : super(key: key);

  @override
  _DistributionReportsScreenState createState() =>
      _DistributionReportsScreenState();
}

class _DistributionReportsScreenState extends State<DistributionReportsScreen> {
  late Frequency frequency;
  late TextEditingController searchController;
  @override
  void initState() {
    frequency = Frequency.Weekly;
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.clear();
    searchController.dispose();
    super.dispose();
  }

  void rebuild() => setState(
        () => null,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTextField(),
        Row(
          children: buildButtons(),
        ),
        buildListView(),
      ],
    );
  }

  static const List<String> frequencies = [
    'Daily',
    'Weekly',
    'Monthly',
    'All Time'
  ];

  List<DistributionItemModel> get distributionItemsFromSearch =>
      DistributionItems.distributionItemsFromSearch(
        search: searchController.text,
        frequency: frequency,
      );

  List<Widget> buildButtons() => frequencies
      .map(
        (frequency) => Expanded(
          child: OutlinedButton(
            onPressed: () => setState(
              () {
                switch (frequency) {
                  case 'Daily':
                    this.frequency = Frequency.Daily;
                    break;
                  case 'Weekly':
                    this.frequency = Frequency.Weekly;
                    break;
                  case 'Monthly':
                    this.frequency = Frequency.Monthly;
                    break;
                  default:
                    this.frequency = Frequency.AllTime;
                }
              },
            ),
            child: Text(frequency),
          ),
        ),
      )
      .toList();

  Widget buildListView() => Expanded(
        child: ListView.builder(
          itemCount: distributionItemsFromSearch.length,
          itemBuilder: (context, index) => ListTile(
            title: Column(
              children: [
                Text(distributionItemsFromSearch.elementAt(index).itemName),
              ],
            ),
          ),
        ),
      );

  Widget buildTextField() => TextField(
        controller: searchController,
        onChanged: (_) => rebuild(),
      );
}
