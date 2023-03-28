import 'package:flutter/material.dart';
import './employee_profile_screen.dart';
import './admission_history.dart';
import '../widgets/employee_list.dart';

class HumanResources extends StatefulWidget {
  static String routeName = 'human_resources';

  @override
  _HumanResourcesState createState() => _HumanResourcesState();
}

class _HumanResourcesState extends State<HumanResources> {
  late final TextEditingController searchController;

  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  void dispose() {
    searchController.clear();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(EmployeeProfileScreen.routeName),
        child: const Icon(Icons.person_add),
      ),
      body: Column(
        children: [
          buildTopNavigation(),
          buildTextField(),
          EmployeeList(searchController.text),
        ],
      ),
    );
  }

  Widget buildTopNavigation() => Container(
        child: Container(
          height: 80,
          child: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  color: Colors.green,
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AdmissionHistory.routeName),
                  child: const Text(
                    'ADMISSION HISTORY',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildTextField() => Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.subject_sharp,
                color: Color.fromRGBO(5, 111, 146, 1),
                size: 60,
              ),
            ),
            Expanded(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (_) => null,
              ),
            ),
          ],
        ),
      );
}
