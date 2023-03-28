import 'package:flutter/material.dart';
import 'package:iponph/utils/helpers.dart';
import './layout/figures.dart';
import './layout/names.dart';
import './models/item_type_model.dart';
import './models/enterprise_model.dart';
import './enterprise/delivery/screens/delivery.dart';
import './enterprise/stocks/screens/stocks.dart';
import './login_screen.dart';
import './enterprise/associations/screens/associations.dart';
import './enterprise/accounting/screens/accounting.dart';
import './enterprise/hr/screens/human_resources.dart';

class EnterpriseScreen extends StatefulWidget {
  static const String routeName = 'enterprise_screen';

  @override
  _EnterpriseScreenState createState() => _EnterpriseScreenState();
}

class _EnterpriseScreenState extends State<EnterpriseScreen> {
  bool isLoading = false;
  bool openSections = false;

  late final TextEditingController enterpriseNameController;
  late final TextEditingController enterpriseAddressController;
  late final TextEditingController enterpriseEmailController;
  late final TextEditingController enterpriseContactNumberController;
  late final int screenIndex;

  @override
  void initState() {
    enterpriseNameController = TextEditingController();
    enterpriseAddressController = TextEditingController();
    enterpriseEmailController = TextEditingController();
    enterpriseContactNumberController = TextEditingController();
    screenIndex = 0;
    refresh();
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

  Future<void> refresh() async {
    setState(
      () => isLoading = true,
    );
    await readAllItemTypes();

    await Future.delayed(
      const Duration(seconds: 3),
      () => setState(
        () => isLoading = false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: isLoading
            ? buildLoadingScreen()
            : buildEnterpriseScreen(
                context,
              ),
      );

  Widget buildLoadingScreen() => Center(
        child: Text('Retrieving data...'),
      );

  Widget buildEnterpriseScreen(
    BuildContext context,
  ) {
    EnterpriseModel activeEnterprise = Enterprises.activeEnterprise;
    return DefaultTabController(
      length: 5,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(activeEnterprise.enterpriseName),
          actions: [
            IconButton(
              icon: Icon(Icons.menu_open),
              onPressed: () {
                setState(
                  () => openSections = !openSections,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add_business_sharp),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => buildDialog(),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed(LogIn.routeName),
            )
          ],
          // flexibleSpace: Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(colors: [
          //       Color.fromRGBO(5, 111, 146, 1),
          //       Color.fromRGBO(6, 57, 84, 1)
          //     ], begin: Alignment.bottomRight, end: Alignment.topLeft),
          //   ),
          // ),
          // bottom: buildTabBar(),
        ),
        body: Container(
          child: Column(
            children: [
              openSections
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      margin: EdgeInsets.only(
                        top: 20,
                        right: 30,
                        left: 30,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(5, 111, 146, 1),
                            Color.fromRGBO(6, 57, 84, 1)
                          ],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          buildFirstRowIcons(),
                          buildSecondRowIcons(),
                        ],
                      ),
                    )
                  : SizedBox(),
              Expanded(
                child: screens.elementAt(screenIndex),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFirstRowIcons() => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: firstRowIcons,
        ),
      );

  Widget buildSecondRowIcons() => Container(
        margin: EdgeInsets.only(
          top: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: secondRowIcons,
        ),
      );

  List<Widget> get firstRowIcons => pngs
      .sublist(0, 3)
      .map(
        (png) => Container(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.orange,
            child: IconButton(
              splashRadius: 30,
              iconSize: 60,
              onPressed: () => null,
              icon: Image.asset(
                png,
              ),
            ),
          ),
        ),
      )
      .toList();

  List<Widget> get secondRowIcons => pngs
      .sublist(3)
      .map(
        (png) => Container(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.orange,
            child: IconButton(
              splashRadius: 30,
              iconSize: 60,
              onPressed: () => null,
              icon: Image.asset(
                png,
              ),
            ),
          ),
        ),
      )
      .toList();

  List<String> pngs = [
    'assets/images/delivery.png',
    'assets/images/inventory.png',
    'assets/images/transactions.png',
    'assets/images/human_resources.png',
    'assets/images/associations.png',
  ];

  Widget buildTabBarView() => TabBarView(
        children: screens,
      );

  List<Widget> screens = [
    Delivery(),
    Stocks(),
    Accounting(),
    HumanResources(),
    Associations(),
  ];

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

  Widget buildDialog() => AlertDialog(
        title: Text('Enterprise / Business Info'),
        content: SingleChildScrollView(
          child: Column(
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
                  );
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildFittedTab(String tabName) => Tab(
        child: FittedBox(
          child: Text(
            tabName,
            style: TextStyle(fontSize: 18),
          ),
        ),
      );

  List<Widget> buildTabs() => EnterpriseSections.sectionNames
      .map(
        (String tabName) => buildFittedTab(tabName),
      )
      .toList();

  TabBar buildTabBar() => TabBar(
        indicatorColor: Colors.white,
        isScrollable: true,
        tabs: buildTabs(),
      );
}
