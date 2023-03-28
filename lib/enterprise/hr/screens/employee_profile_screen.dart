import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../home_screen.dart';
import '../../../utils/helpers.dart';
import '../../../models/employee_model.dart';

class EmployeeProfileScreen extends StatefulWidget {
  static const String routeName = 'employee_profile_screen';

  @override
  _EmployeeProfileScreenState createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  bool isLoading = false;
  bool readOnly = true;
  bool hasChanged = false;
  Map<String, Object?>? arguments;
  late TextEditingController employeeNameController;
  late TextEditingController employeeGenderController;
  late TextEditingController employeeDescriptionController;
  late TextEditingController employeeContactNumberController;
  late TextEditingController employeeAddressController;
  late TextEditingController employeeSalaryController;

  @override
  void initState() {
    employeeNameController = TextEditingController();
    employeeGenderController = TextEditingController();
    employeeDescriptionController = TextEditingController();
    employeeContactNumberController = TextEditingController();
    employeeAddressController = TextEditingController();
    employeeSalaryController = TextEditingController();
    retrieveData();
    super.initState();
  }

  void dispose() {
    employeeNameController.dispose();
    employeeGenderController.dispose();
    employeeDescriptionController.dispose();
    employeeAddressController.dispose();
    employeeContactNumberController.dispose();
    employeeSalaryController.dispose();
    super.dispose();
  }

  Future<void> retrieveData() async {
    if (Employees.instance.employees.isEmpty) {
      setState(() => isLoading = true);
      await Future.delayed(
        const Duration(milliseconds: 1500),
        () => setState(() => isLoading = false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeesProvider = Provider.of<Employees>(context, listen: false);
    final ModalRoute<Object?>? route = ModalRoute.of(context);
    final bool noEmployees = employeesProvider.employees.isEmpty;
    if (!hasChanged) {
      if (route != null) {
        Map<String, Object?>? routeArguments =
            route.settings.arguments as Map<String, Object?>?;
        if (routeArguments != null) {
          arguments = routeArguments;
          employeeNameController.text =
              routeArguments[EmployeeModelFields.employeeName] as String;
          employeeGenderController.text =
              routeArguments[EmployeeModelFields.employeeGender] == 1
                  ? 'Male'
                  : 'Female';
          employeeAddressController.text =
              routeArguments[EmployeeModelFields.employeeAddress] as String;
          employeeDescriptionController.text =
              routeArguments[EmployeeModelFields.employeeDescription] as String;
          employeeContactNumberController.text =
              routeArguments[EmployeeModelFields.employeeContactNumber]
                  as String;
          employeeSalaryController.text =
              routeArguments[EmployeeModelFields.employeeSalary] as String;
        }
      }
    }
    if (arguments == null) {
      readOnly = false;
    }
    // If no arguments are passed from the previous screen, routeArguments print null:
    return Scaffold(
      body: isLoading
          ? Center(
              child: Text('Processing...'),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                arguments != null
                    ? IconButton(
                        onPressed: () {
                          setState(
                            () {
                              readOnly = false;
                            },
                          );
                        },
                        icon: Icon(Icons.edit),
                      )
                    : SizedBox(),
                TextField(
                  readOnly: readOnly,
                  controller: employeeNameController,
                  onChanged: (value) => setState(() => hasChanged = true),
                  decoration: InputDecoration(
                    hintText: 'Name',
                    prefixIcon: Icon(Icons.badge),
                  ),
                ),
                TextField(
                  readOnly: readOnly,
                  controller: employeeGenderController,
                  onChanged: (value) {
                    print(readOnly);
                    setState(() => hasChanged = true);
                  },
                  decoration: InputDecoration(
                    hintText: 'Gender: Male or Female',
                    prefixIcon: Icon(Icons.people_alt),
                  ),
                ),
                TextField(
                  readOnly: readOnly,
                  controller: employeeAddressController,
                  onChanged: (value) => setState(() => hasChanged = true),
                  decoration: InputDecoration(
                    hintText: 'Address',
                    prefixIcon: Icon(
                      Icons.place_rounded,
                    ),
                  ),
                ),
                TextField(
                  readOnly: readOnly,
                  controller: employeeContactNumberController,
                  onChanged: (value) => setState(() => hasChanged = true),
                  decoration: InputDecoration(
                    hintText: 'Tel / Phone no.',
                    prefixIcon: Icon(Icons.phone_callback),
                  ),
                ),
                TextField(
                  readOnly: readOnly,
                  controller: employeeDescriptionController,
                  onChanged: (value) => setState(() => hasChanged = true),
                  decoration: InputDecoration(
                    hintText: 'Description',
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                TextField(
                  readOnly: readOnly,
                  keyboardType: TextInputType.number,
                  controller: employeeSalaryController,
                  onChanged: (value) => setState(() => hasChanged = true),
                  decoration: InputDecoration(
                      hintText: 'Salary', prefixIcon: Icon(Icons.attach_money)),
                ),
                SizedBox(
                  height: 15,
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
                  onPressed: () {
                    if (!noEmployees) {
                      Navigator.of(context).pop();
                      return;
                    } else {
                      Employees.createEmployee(
                        employeeName: employeeNameController.text,
                        employeeGender:
                            employeeGenderController.text == 'Female'
                                ? Gender.Female
                                : Gender.Male,
                        employeeDescription: employeeDescriptionController.text,
                        employeeContactNumber:
                            employeeContactNumberController.text,
                        employeeAddress: employeeAddressController.text,
                        employeeSalary:
                            double.parse(employeeSalaryController.text),
                        isActive: employeesProvider.employees.isEmpty,
                      );
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName);
                    }
                  },
                  child: Text(
                    noEmployees
                        ? 'Get Started'
                        : hasChanged
                            ? 'Save Changes'
                            : 'Get Back',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
    );
  }
}
