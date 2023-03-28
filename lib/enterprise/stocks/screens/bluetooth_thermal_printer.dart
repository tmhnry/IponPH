import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import '../../../utils/custom_key.dart';
import '../../../models/enterprise_model.dart';
import '../../../models/checkout_item_model.dart';

class ReceiptPrinterFields {
  static const String transactionAmount = 'transactionAmount';
  static const String transactionChange = 'transactionChange';
  static const String totalAmountPaid = 'totalAmountPaid';
}

class ReceiptPrinter extends StatefulWidget {
  static const String routeName = 'receipt_printer';

  @override
  _ReceiptPrinterState createState() => _ReceiptPrinterState();
}

class _ReceiptPrinterState extends State<ReceiptPrinter> {
  late String enterpriseNameForPrint;
  late String enterpriseContactNumberForPrint;
  late String enterpriseAddressForPrint;
  late String enterpriseEmailForPrint;
  late Map<CustomKey, CheckoutItemModel> itemsForPrint;
  late double totalAmountPaid;
  late double transactionAmount;
  late double transactionChange;
  bool connected = true;
  bool isLoading = false;
  List availableBluetoothDevices = [];

  @override
  void initState() {
    enterpriseNameForPrint = Enterprises.activeEnterprise.enterpriseName;
    enterpriseContactNumberForPrint =
        Enterprises.activeEnterprise.enterpriseContactNumber;
    enterpriseAddressForPrint = Enterprises.activeEnterprise.enterpriseAddress;
    enterpriseEmailForPrint = Enterprises.activeEnterprise.enterpriseEmail;
    itemsForPrint = {};
    totalAmountPaid = 0.0;
    transactionAmount = 0.0;
    transactionChange = 0.0;
    processDelay();
    super.initState();
  }

  Future<void> processDelay() async {
    setState(() => isLoading = true);
    Future.delayed(
      Duration(seconds: 3),
      () => setState(() => isLoading = false),
    );
  }

  Future<void> getBluetooth() async {
    final List bluetooths =
        await BluetoothThermalPrinter.getBluetooths as List<dynamic>;
    print("Print $bluetooths");
    setState(() {
      availableBluetoothDevices = bluetooths;
    });
  }

  Future<void> setConnect(String mac) async {
    final String result = await BluetoothThermalPrinter.connect(mac) as String;
    print("state connected $result");
    if (result == "true") {
      setState(
        () {
          connected = true;
        },
      );
    }
  }

  Future<void> printTicket() async {
    String isConnected =
        await BluetoothThermalPrinter.connectionStatus as String;
    if (isConnected == "true") {
      List<int> bytes = await getTicket();
      final result = await BluetoothThermalPrinter.writeBytes(bytes);
      print("Print $result");
    } else {}
  }

  Future<List<int>> getTicket() async {
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    bytes += generator.text('$enterpriseNameForPrint',
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size3,
          width: PosTextSize.size3,
        ),
        linesAfter: 1);

    bytes += generator.text('$enterpriseAddressForPrint',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('$enterpriseContactNumberForPrint',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('$enterpriseEmailForPrint',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('***Sales Invoice***',
        styles: PosStyles(align: PosAlign.center));
    bytes +=
        generator.text('000182072', styles: PosStyles(align: PosAlign.center));

    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'Qty',
          width: 1,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Item',
          width: 5,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Price',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: '',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: '',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);
    for (var i = 0; i < itemsForPrint.length; i++) {
      bytes += generator.row(
        [
          PosColumn(
              text: '${itemsForPrint.values.toList()[i].checkoutItemQuantity}',
              width: 1,
              styles: PosStyles(
                align: PosAlign.left,
              )),
          PosColumn(
              text: itemsForPrint.values.toList()[i].inventoryItem.itemName,
              width: 5,
              styles: PosStyles(
                align: PosAlign.left,
              )),
          PosColumn(
              text:
                  '${itemsForPrint.values.toList()[i].inventoryItem.itemPrice}',
              width: 2,
              styles: PosStyles(
                align: PosAlign.center,
              )),
          PosColumn(
              text: '', width: 2, styles: PosStyles(align: PosAlign.center)),
          PosColumn(
              text: '', width: 2, styles: PosStyles(align: PosAlign.right)),
        ],
      );
    }
    bytes += generator.hr(linesAfter: 1);
    bytes += generator.row([
      PosColumn(
          text: 'Total',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size4,
            width: PosTextSize.size3,
          )),
      PosColumn(
          text: '$transactionAmount',
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size4,
            width: PosTextSize.size3,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Cash',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size4,
            width: PosTextSize.size3,
          )),
      PosColumn(
          text: '$totalAmountPaid',
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size4,
            width: PosTextSize.size3,
          )),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Change',
          width: 6,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size4,
            width: PosTextSize.size3,
          )),
      PosColumn(
          text: ' $transactionChange',
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size4,
            width: PosTextSize.size3,
          )),
    ]);
    bytes += generator.hr(ch: '=', linesAfter: 1);

    bytes += generator.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text(DateTime.now().toString(),
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text('',
        styles: PosStyles(align: PosAlign.center, bold: false));
    bytes += generator.cut();
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    final ModalRoute<Object?>? route = ModalRoute.of(context);
    if (route != null) {
      Map<String, Object?>? routeArguments =
          route.settings.arguments as Map<String, Object?>?;
      if (routeArguments != null) {
        totalAmountPaid =
            routeArguments[ReceiptPrinterFields.totalAmountPaid] as double;
        transactionAmount =
            routeArguments[ReceiptPrinterFields.transactionAmount] as double;
        transactionChange =
            routeArguments[ReceiptPrinterFields.transactionChange] as double;
      }
    }
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: const Text('Bluetooth Thermal Printer'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(5, 111, 146, 1),
              Color.fromRGBO(6, 57, 84, 1)
            ], begin: Alignment.bottomRight, end: Alignment.topLeft),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.orange),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Processing Transaction...'),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Search Thermal Printer"),
                  TextButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: BorderSide(
                                        color: Colors.blue, width: 2)))),
                    onPressed: () {
                      this.getBluetooth();
                    },
                    child: Icon(Icons.bluetooth),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: availableBluetoothDevices.length > 0
                          ? availableBluetoothDevices.length
                          : 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            String select = availableBluetoothDevices[index];
                            List list = select.split("#");
                            // String name = list[0];
                            String mac = list[1];
                            this.setConnect(mac);
                          },
                          title: Text('${availableBluetoothDevices[index]}'),
                          subtitle: Text("Click to connect"),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    side: BorderSide(
                                        color: Colors.blue, width: 2)))),
                    onPressed: connected ? this.printTicket : null,
                    child: Text(
                      "Print Receipt",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
