import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './home_screen.dart';
import './signup_screen.dart';
import './enterprise/hr/screens/enterprise_profile_screen.dart';
import './enterprise/hr/screens/employee_profile_screen.dart';
import '../models/enterprise_model.dart';
import '../models/employee_model.dart';

//  for deleting
import './db/local/app_db.dart';
import './models/distribution_item_model.dart';
import './models/inventory_item_model.dart';

class LogIn extends StatefulWidget {
  static String routeName = 'login';

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool initInProgress = false;

  @override
  void initState() {
    init();
    super.initState();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  Future init() async {
    setState(() => initInProgress = true);
    await AppDatabase.delete(table: tableDistributionItems);
    await AppDatabase.delete(table: tableInventoryItems);

    await readAllEmployees();
    await readAllEnterprises();
    await Future.delayed(
      const Duration(seconds: 3),
      () => {
        setState(() => initInProgress = false),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeesProvider = Provider.of<Employees>(context);
    final enterpriseProvider = Provider.of<Enterprises>(context, listen: false);
    return Scaffold(
      body: initInProgress
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: FittedBox(
                      child: Text(
                        'CATALYST',
                        style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'quicktechhalf',
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: FittedBox(
                      child: Text(
                        'IPON',
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'quicktechhalf',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: FittedBox(
                      child: Text(
                        'CATALYST IPON Software Management System',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'AstroheadFREE',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '(c) Copyright Catalyst Company, ',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'AstroheadFREE',
                            ),
                          ),
                          Text(
                            '2021.',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: FittedBox(
                      child: Text(
                        'All Rights Reserved.',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'AstroheadFREE',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Form(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 12),
                                hintText: 'Email',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                prefixIcon: Icon(
                                  Icons.email_sharp,
                                )),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(12),
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 12,
                              ),
                              hintText: 'Password',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.no_encryption_gmailerrorred_rounded,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (enterpriseProvider.enterprises.isEmpty) {
                              Navigator.of(context).pushReplacementNamed(
                                EnterpriseProfileScreen.routeName,
                              );
                            } else if (employeesProvider.employees.isEmpty) {
                              Navigator.of(context).pushReplacementNamed(
                                EmployeeProfileScreen.routeName,
                              );
                            } else {
                              Navigator.of(context)
                                  .pushReplacementNamed(HomeScreen.routeName);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(25)),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width - 150,
                            child: Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account? ',
                              style: TextStyle(fontSize: 15),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(SignUp.routeName);
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    fontSize: 15,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
