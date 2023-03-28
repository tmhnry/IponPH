import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './employee_widget.dart';
import '../../../models/employee_model.dart';

class EmployeeList extends StatefulWidget {
  final String search;

  EmployeeList(
    this.search,
  );

  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  bool isLoading = false;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  void didUpdateWidget(EmployeeList oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future refresh() async {
    setState(
      () => isLoading = true,
    );
    readAllEmployees();
    await Future.delayed(
      const Duration(milliseconds: 500),
      () => {
        setState(
          () => this.isLoading = false,
        ),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Employees>(context);
    return isLoading
        ? buildLoadingScreen()
        : Employees.employeesFromSearch(
            search: widget.search,
          ).isEmpty
            ? buildSecondary()
            : Expanded(
                child: Column(
                  children: [
                    buildSwitch(),
                    Flexible(
                      child: ListView.builder(
                        itemCount: Employees.employeesFromSearch(
                          search: widget.search,
                        ).length,
                        itemBuilder: (context, index) => EmployeeWidget(
                          employee: Employees.employeesFromSearch(
                            search: widget.search,
                          )[index],
                        ),
                      ),
                    ),
                    buildFooter(),
                  ],
                ),
              );
  }

  Widget buildLoadingScreen() => Expanded(
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 4,
            color: Colors.orange,
          ),
        ),
      );

  Widget buildSwitch() => Employees.employeesFromSearch(
        search: widget.search,
      ).isEmpty
          ? SizedBox()
          : Container(
              margin: EdgeInsets.only(left: 50, top: 15, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 10,
                        child: Switch(
                          value: false,
                          onChanged: (bool value) {},
                          activeColor: Colors.white,
                          activeTrackColor: Colors.orange,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 35),
                        child: Text(
                          'Show Additional Details',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );

  Widget buildFooter() => Employees.employeesFromSearch(
        search: widget.search,
      ).isEmpty
          ? Container()
          : Container(
              height: 45,
              child: Center(
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.orange,
                  size: 30,
                ),
              ),
            );

  Widget buildSecondary() => Expanded(
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
                              'Cannot find employee',
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
