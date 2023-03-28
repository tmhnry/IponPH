import 'package:flutter/material.dart';
import 'package:iponph/layout/figures.dart';
import './employee_profile_screen.dart';
import '../../../layout/names.dart';
import '../../../models/employee_model.dart';
import '../../../models/enterprise_model.dart';
import '../../../enterprise_screen.dart';

class EnterpriseProfileScreen extends StatefulWidget {
  static const String routeName = 'enterprise_profile_screen';

  @override
  _CompanyProfileScreenState createState() => _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends State<EnterpriseProfileScreen> {
  bool isLoading = false;
  late final TextEditingController enterpriseNameController;
  late final TextEditingController enterpriseAddressController;
  late final TextEditingController enterpriseEmailController;
  late final TextEditingController enterpriseContactNumberController;

  @override
  void initState() {
    enterpriseNameController = TextEditingController();
    enterpriseAddressController = TextEditingController();
    enterpriseEmailController = TextEditingController();
    enterpriseContactNumberController = TextEditingController();
    retrieveData();
    super.initState();
  }

  @override
  void dispose() {
    clearControllers();
    disposeControllers();
    super.dispose();
  }

  Map<String, TextEditingController> get namesWithControllers => {
        ControllerNames.enterpriseName: enterpriseNameController,
        ControllerNames.enterpriseAddressName: enterpriseAddressController,
        ControllerNames.enterpriseEmailName: enterpriseEmailController,
        ControllerNames.enterpriseContactNumberName:
            enterpriseContactNumberController,
      };

  void clearControllers() {
    namesWithControllers.values.forEach(
      (controller) => controller.clear(),
    );
  }

  void disposeControllers() {
    namesWithControllers.values.forEach(
      (controller) => controller.dispose(),
    );
  }

  Future<void> retrieveData() async {
    if (Enterprises.isEnterprisesEmpty) {
      setState(
        () => isLoading = true,
      );
      await Future.delayed(
        const Duration(seconds: 3),
        () => setState(
          () => isLoading = false,
        ),
      );
    }
  }

  Widget buildTextFields() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: namesWithControllers.values
            .map(
              (controller) => buildTextField(
                controllerName: ControllerFigures.controllerNames.elementAt(
                  namesWithControllers.values.toList().indexOf(controller),
                ),
                controller: controller,
              ),
            )
            .toList(),
      );

  Widget buildTextField({
    required String controllerName,
    required TextEditingController controller,
  }) =>
      TextField(
        controller: controller,
        decoration: buildDecoration(
          controllerName,
        ),
      );

  InputDecoration buildDecoration(String controllerName) => InputDecoration(
        hintText: controllerName,
        prefix: ControllerFigures.controllerFigures.elementAt(
          ControllerFigures.controllerNames.indexOf(
            controllerName,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Text('Retrieving Data...'),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTextFields(),
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
                    Enterprises.createEnterprise(
                      enterpriseName: enterpriseNameController.text,
                      enterpriseAddress: enterpriseAddressController.text,
                      enterpriseContactNumber:
                          enterpriseContactNumberController.text,
                      enterpriseEmail: enterpriseEmailController.text,
                      isActive: Enterprises.isEnterprisesEmpty ? true : false,
                    );
                    if (Employees.isEmployeesEmpty) {
                      Navigator.pushReplacementNamed(
                        context,
                        EmployeeProfileScreen.routeName,
                      );
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        EnterpriseScreen.routeName,
                      );
                    }
                  },
                  child: Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
    );
  }
}
