import 'package:flutter/material.dart';
import 'package:iponph/utils/helpers.dart';
import './daily_distribution_screen.dart';
import '../widgets/distribution_dialog.dart';
import '../widgets/expandable_fab.dart';
import '../widgets/action_button.dart';
import '../widgets/distribution_form.dart';

class Delivery extends StatefulWidget {
  @override
  _DistributionState createState() => _DistributionState();
}

class _DistributionState extends State<Delivery> {
  late final TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // AppDatabase.instance.close();
    searchController.clear();
    searchController.dispose();
    super.dispose();
  }

  void rebuild() => setState(() => null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            icon: const Icon(Icons.send),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DistributionForm(),
            ),
          ),
          ActionButton(
            icon: const Icon(Icons.add),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DistributionDialog(),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildTopNavigation(),
          DailyDistributionScreen(
            searchController.text,
          ),
        ],
      ),
    );
  }

  Widget buildTopNavigation() => Container(
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Row(
          children: [
            Expanded(
              child: buildTextField(context),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 5,
              ),
              child: GestureDetector(
                onTap: () => null,
                child: Image.asset(
                  'assets/images/delivery_history_no.png',
                  height: 50,
                  width: 50,
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildTextField(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          border: Border.all(
            color: Colors.black45,
            width: 0.2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  border: Border.all(
                    color: Color.fromRGBO(0, 0, 0, 0),
                  ),
                  color: Colors.white,
                  // border: BorderDirectional(
                  //   start: BorderSide(
                  //     color: Colors.black45,
                  //   ),
                  // ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: InputBorder.none,
                    hintText: 'Search Delivery',
                  ),
                  onChanged: (_) => rebuild(),
                ),
              ),
            ),
          ],
        ),
      );
}
