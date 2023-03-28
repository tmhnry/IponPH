import 'package:flutter/material.dart';
import '../../../layout/names.dart';

class DistributionField extends StatelessWidget {
  final String title;
  final bool readOnly;

  final TextEditingController? controller;

  DistributionField(
    this.controller, {
    this.title = '',
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: title == ControllerNames.itemCostName ||
              title == ControllerNames.itemPriceName ||
              title == ControllerNames.itemQuantityName
          ? TextInputType.number
          : null,
      readOnly: readOnly,
      style: TextStyle(fontSize: 15, color: Colors.orange),
      controller: controller,
      decoration: createDecoration(title),
    );
  }
}

String? get prefixText => 'PHP ';

InputDecoration createDecoration(String title) {
  return InputDecoration(
    prefixText: title == ControllerNames.itemCostName ||
            title == ControllerNames.itemPriceName
        ? prefixText
        : null,
    prefixStyle: TextStyle(
      color: Colors.orange,
    ),
    labelText: title,
    labelStyle: TextStyle(
      color: Colors.white,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Colors.white,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Colors.orange,
      ),
    ),
  );
}
