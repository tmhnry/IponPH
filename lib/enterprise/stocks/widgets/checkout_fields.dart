import 'package:flutter/material.dart';
import './checkout_textfield.dart';

class CheckoutFields extends StatelessWidget {
  final Map<String, TextEditingController> namesWithControllers;
  final bool newCustomer;
  const CheckoutFields({
    required this.namesWithControllers,
    required this.newCustomer,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: buildTextFieldList(),
    );
  }

  List<Widget> buildTextFieldList() {
    List<Widget> controllerList = [];
    namesWithControllers.forEach(
      (controllerName, controller) {
        controllerList.add(
          CheckoutTextField(
            newCustomer: newCustomer,
            controller: controller,
            controllerName: controllerName,
          ),
        );
      },
    );
    return controllerList;
  }
}
