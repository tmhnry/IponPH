import 'package:flutter/material.dart';
import '../../../utils/helpers.dart';
import '../../../layout/names.dart';

class CheckoutTextField extends StatelessWidget {
  final TextEditingController controller;
  final String controllerName;
  final bool newCustomer;
  CheckoutTextField({
    required this.controller,
    required this.controllerName,
    required this.newCustomer,
  });
  bool get isDouble {
    return controllerName == ControllerNames.creditByCashName;
  }

  bool get isInt {
    return controllerName == ControllerNames.discountName;
  }

  bool get isText {
    return controllerName == ControllerNames.customerName;
  }

  bool get isFixed {
    return isText || controllerName == ControllerNames.discountName;
  }

  bool get isCreditCard {
    return controllerName == ControllerNames.creditCardName;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: newCustomer
          ? false
          : isFixed
              ? true
              : false,
      // @validator: returns false when a string is returned (aside from Exception).
      validator: (value) {
        if (value == null) {
          throw Exception(
            'CheckoutTextField validator: value evaluated to null',
          );
        } else {
          value = value.trim();
          if (isInt) {
            int? parsedDiscount = discountFromString(value);
            if (parsedDiscount == null)
              return 'Invalid Input';
            else if (parsedDiscount < 0 || 100 < parsedDiscount)
              return 'Please Enter Number Between 0 and 100';
          }
          if (isText) {
            if (value.isNotEmpty && value.length < 3)
              return 'Name is Too Short';
          }
          if (isDouble) {
            double? parsedCreditByCash = creditByCashFromString(value);
            if (parsedCreditByCash == null) return 'Invalid Input';
          }
          if (isCreditCard) {
            if (value.isNotEmpty && value.length < 5)
              return 'Credit Card Number is Too Short';
          }
        }
      },
      style: CustomTextStyle.inputStyle,
      keyboardType: !isText ? TextInputType.number : null,
      controller: controller,
      decoration: createDecoration(controllerName),
    );
  }

  String? validator(String? s) {}

  int? discountFromString(String discountString) {
    return int.tryParse(discountString);
  }

  double? creditByCashFromString(String creditByCashString) {
    return double.tryParse(creditByCashString);
  }

  String? get prefixText {
    if (isDouble) return 'PHP ';
    if (isInt) return '% ';
  }

  InputDecoration createDecoration(
    String title,
  ) {
    return InputDecoration(
      isDense: true,
      labelText: title,
      labelStyle: CustomTextStyle.labelStyle,
      prefixText: prefixText,
      prefixStyle: CustomTextStyle.inputPrefixStyle,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: Colors.white,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: Colors.orange,
        ),
      ),
    );
  }
}
