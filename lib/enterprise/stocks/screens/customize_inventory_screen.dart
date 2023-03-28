import 'package:flutter/material.dart';
import './product_type_screen.dart';
import '../../../enterprise_screen.dart';

class CustomizeInventoryScreen extends StatefulWidget {
  const CustomizeInventoryScreen({Key? key}) : super(key: key);
  static const String id = 'customize_inventory';

  @override
  _CustomizeInventoryScreenState createState() =>
      _CustomizeInventoryScreenState();
}

class _CustomizeInventoryScreenState extends State<CustomizeInventoryScreen> {
  Widget _screen = _screens[1];
  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(EnterpriseScreen.routeName);
          },
        ),
        primary: true,
        extendBody: true,
        body: Row(
          children: [
            Container(
              child: Flexible(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(5, 111, 146, 1),
                      Color.fromRGBO(6, 57, 84, 1)
                    ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                  ),
                  height: double.maxFinite,
                  child: Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Center(
                          child: MaterialButton(
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 20,
                                bottom: 20,
                              ),
                              child: Column(
                                children: [
                                  FittedBox(
                                    child: Icon(
                                      Icons.room_preferences,
                                      size: 40,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      'General',
                                      style: TextStyle(
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  _screen = _screens[0];
                                },
                              );
                            },
                          ),
                        ),
                        Center(
                          child: MaterialButton(
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 20,
                                bottom: 20,
                              ),
                              child: Column(
                                children: [
                                  FittedBox(
                                    child: Icon(
                                      Icons.add_chart,
                                      size: 40,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      'Types',
                                      style: TextStyle(
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _screen = _screens[1];
                              });
                            },
                          ),
                        ),
                        Center(
                          child: MaterialButton(
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 20,
                                bottom: 20,
                              ),
                              child: Column(
                                children: [
                                  FittedBox(
                                    child: Icon(
                                      Icons.enhanced_encryption,
                                      size: 40,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      'Products',
                                      style: TextStyle(
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _screen = _screens[2];
                              });
                            },
                          ),
                        ),
                        Center(
                          child: MaterialButton(
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 20,
                                bottom: 20,
                              ),
                              child: Column(
                                children: [
                                  FittedBox(
                                    child: Icon(
                                      Icons.supervisor_account,
                                      size: 40,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      'Customers',
                                      style: TextStyle(
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _screen = _screens[3];
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            VerticalDivider(
              width: 1,
              color: Colors.orangeAccent,
            ),
            Flexible(
              flex: 7,
              child: _screen,
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> _screens = [
  ProductTypeScreen(),
  ProductTypeScreen(),
  ProductTypeScreen(),
  ProductTypeScreen(),
];
