import 'package:flutter/material.dart';
import './names.dart';

class ControllerFigures {
  static const Map<String, Widget> _controllerFigures = {
    ControllerNames.enterpriseName: Icon(Icons.business_rounded),
    ControllerNames.enterpriseAddressName: Icon(Icons.place_rounded),
    ControllerNames.enterpriseContactNumberName: Icon(Icons.phone_callback),
    ControllerNames.enterpriseEmailName: Icon(Icons.email_rounded),
  };
  static List<String> get controllerNames => _controllerFigures.keys.toList();
  static List<Widget> get controllerFigures =>
      _controllerFigures.values.toList();
}
