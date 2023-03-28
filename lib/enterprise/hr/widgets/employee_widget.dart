import 'package:flutter/material.dart';
import '../screens/employee_profile_screen.dart';
import '../../../utils/helpers.dart';
import '../../../models/employee_model.dart';

class EmployeeWidget extends StatefulWidget {
  final EmployeeModel employee;
  EmployeeWidget({required this.employee});

  @override
  _EmployeeWidgetState createState() => _EmployeeWidgetState();
}

class _EmployeeWidgetState extends State<EmployeeWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          EmployeeProfileScreen.routeName,
          arguments: widget.employee.toJson(),
        );
      },
      child: Card(
        elevation: 8.0,
        child: ListTile(
          leading: Icon(
            widget.employee.employeeGender == Gender.Male
                ? Icons.male
                : Icons.female,
          ),
          title: Column(
            children: [
              Text(widget.employee.employeeName),
              Text(widget.employee.employeeID.key),
            ],
          ),
        ),
      ),
    );
  }
}
