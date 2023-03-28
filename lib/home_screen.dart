import 'package:flutter/material.dart';
import './enterprise_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home_screen';
  final List<String> sections = [
    'Visit Enterprise',
    'Reports and Documents',
    'Management',
    'Miscellaneous',
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                buildImage(),
              ],
            ),
            buildGridView(context),
            buildFooter(),
          ],
        ),
      );

  Widget buildGridView(BuildContext context) => Expanded(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          crossAxisCount: 2,
          children: buildChildren(context),
        ),
      );

  Widget buildImage() => Container(
        height: 200,
        child: Text('SomeText'),
      );

  List<Widget> buildChildren(BuildContext context) => sections
      .map(
        (section) => GestureDetector(
          onTap: () {
            switch (section) {
              case 'Visit Enterprise':
                Navigator.pushReplacementNamed(
                  context,
                  EnterpriseScreen.routeName,
                );
                break;
              case 'Reports and Documents':
                Navigator.pushReplacementNamed(
                  context,
                  EnterpriseScreen.routeName,
                );
                break;
              default:
                Navigator.pushReplacementNamed(
                  context,
                  EnterpriseScreen.routeName,
                );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.teal[100 * sections.indexOf(section)],
              border: Border.all(
                width: 2,
                color: Colors.white54,
              ),
            ),
            child: Text(section),
          ),
        ),
      )
      .toList();

  Widget buildFooter() => Container(
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'About Us',
                style: TextStyle(fontSize: 17),
              ),
              buildDivider(),
              Text(
                'Support',
                style: TextStyle(fontSize: 17),
              ),
              buildDivider(),
              Text(
                'Our Products',
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
        ),
      );

  Widget buildDivider() => Container(
        color: Colors.black,
        width: 1,
        height: 17,
      );

  //  test version:

  // final List<String> sections = [
  //   'First',
  //   'Second',
  //   'Third',
  //   'Fourth',
  //   'Fifth',
  //   'Sixth',
  //   'Seventh',
  //   'Eighth',
  //   'Ninth',
  //   'Last',
  // ];

  //  use sections (test version) and inspect the layout
  //  use both below and comment out top versions

  // @override
  // Widget build(BuildContext context) => Scaffold(
  //       body: SingleChildScrollView(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Stack(
  //               children: [
  //                 buildImage(),
  //               ],
  //             ),
  //             buildGridView(),
  //             buildFooter(),
  //           ],
  //         ),
  //       ),
  //     );

  // Widget buildGridView() => GridView.count(
  //       shrinkWrap: true,
  //       primary: false,
  //       padding: const EdgeInsets.all(20),
  //       crossAxisSpacing: 50,
  //       mainAxisSpacing: 50,
  //       crossAxisCount: 2,
  //       children: children,
  //     );
}
